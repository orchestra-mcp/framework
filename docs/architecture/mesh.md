---
title: Plugin Mesh
description: How plugins discover, connect, and communicate in the Orchestra mesh
order: 2
---

# Plugin Mesh

The plugin mesh is the communication layer between the orchestrator and all registered plugins.

## In-Process Routing (Local)

For local IDE use, Orchestra uses an **in-process router** — all Go plugins run in the same process and communicate via direct function calls. This eliminates network overhead entirely.

```go
// InProcessRouter implements the Sender interface
type InProcessRouter struct {
    handlers map[string]ToolHandler
}

func (r *InProcessRouter) CallTool(name string, params map[string]any) (any, error) {
    handler, ok := r.handlers[name]
    if !ok {
        return nil, fmt.Errorf("unknown tool: %s", name)
    }
    return handler(ctx, params)
}
```

### Plugin Registration

Each plugin has an `export.go` at its package root:

```go
package mytools

import "github.com/orchestra-mcp/sdk-go/plugin"

func Register(builder *plugin.PluginBuilder) {
    builder.RegisterTool("my_tool", myToolHandler)
    builder.RegisterTool("my_other_tool", myOtherHandler)
}
```

The CLI imports all plugin packages and calls `Register()` during startup.

## QUIC Mesh (External Plugins)

External plugins (Rust, third-party) connect over QUIC:

1. **Discovery** — Plugin reads orchestrator address from `~/.orchestra/config.json`
2. **Connect** — QUIC connection with mTLS (ed25519 certs)
3. **Manifest** — Plugin sends `PluginManifest` declaring its tools
4. **Ready** — Orchestrator adds tools to the global routing table
5. **Dispatch** — Tool calls are forwarded to the plugin over QUIC streams

### Multiplexed Streams

QUIC supports multiplexed streams, allowing parallel tool calls over a single connection. Each tool call opens a new stream — no head-of-line blocking.

## Cross-Plugin Calls

Plugins can call tools from other plugins via the orchestrator:

```go
// From within a tool handler
result, err := plugin.CallTool(ctx, "search_memory", map[string]any{
    "query": "authentication",
})
```

### Provider-Aware Routing

AI bridge calls include a provider field for routing:

```go
result, err := plugin.CallToolWithProvider(ctx, "ai_prompt", "claude", map[string]any{
    "prompt": "Explain this code",
})
```

The orchestrator's `providerAliases` map routes requests to the correct bridge:

| Provider | Routes To |
|----------|-----------|
| claude | bridge.claude |
| openai | bridge.openai |
| gemini | bridge.gemini |
| ollama | bridge.ollama |
| deepseek | bridge.openai (custom base URL) |
| grok | bridge.openai (custom base URL) |
| perplexity | bridge.openai (custom base URL) |

## TCP Server (Desktop)

Desktop apps connect via TCP with the same Protobuf protocol:

```
Desktop App ←→ TCP :50101 ←→ InProcessRouter ←→ Plugins
```

The `TCPServer` at `libs/cli/internal/inprocess/tcpserver.go` accepts connections and forwards tool calls to the in-process router.

## Lifecycle Management

The orchestrator manages plugin lifecycle:

| Event | Action |
|-------|--------|
| Startup | Load core plugins → start optional plugins → accept QUIC connections |
| Tool call | Route to correct plugin handler |
| Plugin crash | Log error, mark tools as unavailable |
| Shutdown | Call `OnShutdown()` on all plugins, close QUIC connections |
