---
title: Plugin Architecture
description: How Orchestra's plugin system works — in-process routing, QUIC, and the plugin lifecycle
order: 1
---

# Plugin Architecture

Orchestra uses a **single-process in-process architecture** for local IDE use. All core plugins run in the same process as the orchestrator, communicating via direct Go function calls. External plugins (like the Rust-based engine.rag) connect over QUIC with mTLS.

## Plugin Types

### Core Plugins (In-Process)

4 plugins are always bundled with the orchestra binary:

| Plugin | Tools | Purpose |
|--------|-------|---------|
| `storage.markdown` | — | Markdown + YAML frontmatter storage |
| `transport.stdio` | — | MCP stdio transport for IDE communication |
| `tools.features` | 70 | Feature lifecycle, plans, requests, git |
| `tools.marketplace` | 15 + 5p | Pack management, stack detection |

### Optional Plugins (In-Process)

34 additional plugins can be installed and run in-process:

- `bridge.claude`, `bridge.openai`, `bridge.gemini`, `bridge.ollama`, `bridge.firecrawl`
- `agent.orchestrator` (20 tools)
- `tools.agentops`, `tools.sessions`, `tools.workspace`
- `devtools.*` (docker, database, terminal, git, ssh, etc.)
- `ai.*` (browser-context, screenshot, screen-reader, vision)
- `services.*` (notifications, voice)
- `integration.figma`

### External Plugins (QUIC)

Plugins that need a separate process (different language, resource isolation):

- `engine.rag` — Rust binary with Tree-sitter, Tantivy, SQLite
- Third-party plugins

## In-Process Router

The `InProcessRouter` at `libs/cli/internal/inprocess/router.go` implements the `Sender` interface and dispatches tool calls via direct Go function calls — no network overhead.

```go
// Each plugin exports a Register function
func Register(builder *plugin.PluginBuilder) {
    builder.RegisterTool("my_tool", myToolHandler)
}

// The router calls handlers directly
router.CallTool("my_tool", params) → result
```

### Export Pattern

Each plugin has an `export.go` file at its root that exposes `Register(builder)`. This bypasses Go's internal package restriction and allows the CLI to import plugin handlers directly.

## QUIC Transport (External Plugins)

External plugins connect over QUIC with mutual TLS:

```
Orchestra CLI                    External Plugin
     │                                │
     │◄─── QUIC + mTLS ──────────────│
     │     Length-delimited Protobuf  │
     │                                │
     │  PluginManifest (on connect)   │
     │  ToolCall → ToolResult         │
     │  Lifecycle events              │
     │                                │
```

### Protocol Details

| Aspect | Detail |
|--------|--------|
| Transport | QUIC (quic-go for Go, quinn for Rust) |
| Auth | mTLS with ed25519 certificates |
| Framing | Length-delimited Protobuf |
| Cert Storage | `~/.orchestra/certs/` |
| Default Port | 9100 (orchestrator) |

## TCP Server (Desktop Apps)

Desktop apps (macOS Swift, Windows C#, Linux GTK4) connect via TCP on port 50101 with the same length-delimited Protobuf framing:

```
Desktop App (Swift/C#/Vala)
     │
     │◄─── TCP :50101 ────────────────│ Orchestra CLI
     │     Length-delimited Protobuf   │
     │                                 │
```

## Plugin Lifecycle

1. **Registration** — Plugin calls `Register(builder)` to declare tools and prompts
2. **Boot** — Orchestrator calls `OnBoot(config)` with plugin configuration
3. **Ready** — Plugin starts handling tool calls
4. **Shutdown** — Orchestrator calls `OnShutdown()` for cleanup

## Storage Layer

The `storage.markdown` plugin stores all data as Markdown files with YAML frontmatter in `.projects/`:

```
.projects/
├── <project>/
│   ├── features/     FEAT-XXX.md
│   ├── plans/        PLAN-XXX.md
│   ├── requests/     REQ-XXX.md
│   ├── persons/      PERS-XXX.md
│   └── project.json
└── .packs/
    └── registry.json
```

This approach means all project data is version-controlled, human-readable, and portable.
