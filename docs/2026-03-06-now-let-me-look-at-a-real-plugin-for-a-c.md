# Assistant Message

> Exported from chat: New Chat
> Date: 2026-03-06

---

Now let me look at a real plugin for a complete picture:
Here's a comprehensive breakdown of the codebase and a concrete code example:

---

## Codebase Overview

Orchestra Agents is a **plugin-based MCP server** written in Go. All components communicate via **length-delimited Protobuf over QUIC** with mTLS.

### Key Layers

```
┌──────────────────────────────────────────┐
│  IDE (Claude Code / Cursor / VS Code)    │
│  ← JSON-RPC over stdio (MCP protocol) → │
├──────────────────────────────────────────┤
│  transport-stdio plugin                  │  ← Bridges MCP ↔ Orchestrator
├──────────────────────────────────────────┤
│  Orchestrator  (libs/orchestrator/)      │  ← Routes tool calls to plugins
├──────────────────────────────────────────┤
│  Plugins (each a standalone Go binary)   │
│  tools.features | storage.markdown | ... │
└──────────────────────────────────────────┘
```

### Core SDK (`libs/sdk-go/`)

| File | Purpose |
|------|---------|
| `plugin/plugin.go` | `PluginBuilder` — fluent API for constructing a plugin |
| `plugin/server.go` | QUIC server that receives tool calls |
| `plugin/client.go` | QUIC client to connect back to orchestrator |
| `plugin/framing.go` | `WriteMessage`/`ReadMessage` — 4-byte length-delimited Protobuf |
| `plugin/lifecycle.go` | `OnBoot`/`OnShutdown` hooks interface |
| `helpers/args.go` | `GetString`, `GetInt`, `GetBool`, `GetStringSlice` |
| `helpers/results.go` | `TextResult`, `JSONResult`, `ErrorResult` + Markdown formatters |
| `helpers/validate.go` | `ValidateRequired` |

---

## Complete Plugin Example

Here's the full pattern for writing a plugin, mirroring the real `tools.features` plugin:

**`internal/tools/greet.go`** — Tool handler:
```go
package tools

import (
    "context"
    "fmt"

    pluginv1 "github.com/orchestra-mcp/gen-go/orchestra/plugin/v1"
    "github.com/orchestra-mcp/sdk-go/helpers"
    "google.golang.org/protobuf/types/known/structpb"
)

// Schema returns the JSON Schema for the greet tool's input arguments.
func GreetSchema() *structpb.Struct {
    s, _ := structpb.NewStruct(map[string]any{
        "type": "object",
        "properties": map[string]any{
            "name": map[string]any{
                "type":        "string",
                "description": "The name to greet",
            },
            "formal": map[string]any{
                "type":        "boolean",
                "description": "Use formal greeting",
            },
        },
        "required": []any{"name"},
    })
    return s
}

// Greet is the tool handler. Signature must be:
//   func(ctx context.Context, req *pluginv1.ToolRequest) (*pluginv1.ToolResponse, error)
func Greet(ctx context.Context, req *pluginv1.ToolRequest) (*pluginv1.ToolResponse, error) {
    // 1. Validate required args
    if err := helpers.ValidateRequired(req.Arguments, "name"); err != nil {
        return helpers.ErrorResult("validation_error", err.Error()), nil
    }

    // 2. Extract typed values from structpb
    name   := helpers.GetString(req.Arguments, "name")
    formal := helpers.GetBool(req.Arguments, "formal")

    // 3. Business logic
    greeting := "Hey"
    if formal {
        greeting = "Good day"
    }

    // 4. Return text response
    return helpers.TextResult(fmt.Sprintf("%s, %s!", greeting, name)), nil
}
```

**`cmd/main.go`** — Entry point:
```go
package main

import (
    "context"
    "log"
    "os"
    "os/signal"
    "syscall"

    "github.com/orchestra-mcp/sdk-go/plugin"
    "github.com/my-org/my-plugin/internal/tools"
)

func main() {
    p := plugin.New("tools.greet").        // unique plugin ID
        Version("0.1.0").
        Description("Greeting plugin").
        RegisterTool(
            "greet",                        // tool name exposed to IDE
            "Greet someone by name",        // description shown to LLM
            tools.GreetSchema(),            // JSON Schema for args
            tools.Greet,                    // handler func
        ).
        BuildWithTools()

    p.ParseFlags() // adds --orchestrator-addr, --listen-addr, --certs-dir, --manifest

    ctx, cancel := context.WithCancel(context.Background())
    defer cancel()

    sigCh := make(chan os.Signal, 1)
    signal.Notify(sigCh, syscall.SIGINT, syscall.SIGTERM)
    go func() { <-sigCh; cancel() }()

    if err := p.Run(ctx); err != nil {
        log.Fatalf("plugin error: %v", err)
    }
}
```

**`plugins.yaml`** — Register it with the orchestrator:
```yaml
plugins:
  - id: tools.greet
    binary: ./bin/greet
    enabled: true
```

---

## Key Patterns

### Storage-dependent tool (closure captures store)
```go
// The handler closes over *storage.FeatureStorage, injected at startup
func CreateProject(store *storage.FeatureStorage) ToolHandler {
    return func(ctx context.Context, req *pluginv1.ToolRequest) (*pluginv1.ToolResponse, error) {
        name := helpers.GetString(req.Arguments, "name")
        // ... write to storage via orchestrator QUIC client
    }
}
```

### In-process mode (no QUIC — used by `orchestra serve`)
```go
// Each plugin exposes Export() instead of BuildWithTools() for in-process embed
ep := builder.Export()  // returns *ExportedPlugin with Tools/Prompts slices
// InProcessRouter dispatches directly via function call, no network hop
```

### Lifecycle hooks
```go
type MyHooks struct{ db *sql.DB }

func (h *MyHooks) OnBoot(config map[string]string) error {
    // called by orchestrator Boot request — open DB, load state
    return nil
}
func (h *MyHooks) OnShutdown() error {
    return h.db.Close()
}

// register: builder.Lifecycle(&MyHooks{})
```

---

The real plugins to study as references:
- `libs/plugin-tools-features/` — 34 tools, storage access, full lifecycle
- `libs/plugin-storage-markdown/` — implements `StorageHandler` (Read/Write/Delete/List)
- `libs/plugin-transport-stdio/` — bridges MCP JSON-RPC ↔ orchestrator QUIC