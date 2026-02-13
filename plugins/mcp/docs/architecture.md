# MCP Plugin Architecture

## Module Structure

The MCP plugin is a standalone Go module (`github.com/orchestra-mcp/mcp`) with a `replace` directive back to the core framework.

```
plugins/mcp/
├── go.mod                    # Standalone module
├── config/                   # Plugin-specific config
├── providers/                # Bridge to core plugin system
│   ├── plugin.go             # McpPlugin struct + lifecycle
│   └── tools.go              # Tool aggregation + REST routes
└── src/                      # All implementation
    ├── cmd/                  # CLI entry point
    ├── types/                # Type definitions
    ├── toon/                 # TOON file format
    ├── workflow/             # State machine
    ├── helpers/              # Shared utilities
    ├── transport/            # Stdio JSON-RPC server
    ├── tools/                # 40 tool implementations
    └── bootstrap/            # Workspace init
```

## Dual-Mode Operation

### Standalone (stdio)

```
Claude Code <-> stdio JSON-RPC <-> MCPServer (transport/server.go)
                                        |
                                   tools/* handlers
                                        |
                                   .projects/ TOON files
```

Entry point: `src/cmd/main.go`. Reads stdin line-by-line, parses JSON-RPC 2.0 requests, dispatches to tool handlers.

### Integrated (Go plugin)

```
HTTP Client -> Fiber Router -> /api/mcp/tools/call -> McpPlugin.allTools()
                                                           |
                                                      tool.Handler(args)
                                                           |
                                                      .projects/ TOON files
```

Entry point: `providers/tools.go`. The `RegisterRoutes()` method adds REST endpoints under `/api/mcp/`.

## Tool Architecture

### Tool Definition

Every tool is a `types.Tool` — a definition paired with a handler:

```go
type Tool struct {
    Definition ToolDefinition
    Handler    ToolHandler // func(map[string]any) (*ToolResult, error)
}
```

### Tool Categories

Each file in `src/tools/` exports a function that returns `[]Tool`:

```go
func Project(workspace string) []Tool { ... }
func Epic(workspace string) []Tool    { ... }
// etc.
```

Tools are aggregated in `providers/tools.go`:

```go
func (p *McpPlugin) builtinTools() []Tool {
    ws := p.workspace
    all = append(all, tools.Project(ws)...)
    all = append(all, tools.Epic(ws)...)
    // ... 10 tool groups
    return all
}
```

### External Tools

Other plugins push tools via `RegisterExternalTools()`. These are stored in `McpPlugin.externalTools` (thread-safe via `sync.RWMutex`). The `allTools()` method combines built-in + external.

## Data Storage

All project data is stored as TOON (YAML) files in `.projects/`:

```
.projects/
├── my-app/
│   ├── project-status.toon      # Project metadata
│   ├── EPIC-1/
│   │   ├── issue.toon            # Epic details
│   │   ├── STORY-1/
│   │   │   ├── issue.toon        # Story details
│   │   │   ├── TASK-1.toon       # Task
│   │   │   └── TASK-2.toon       # Task
│   │   └── STORY-2/
│   └── EPIC-2/
└── other-project/
```

## Protocol

The stdio server implements MCP protocol version `2024-11-05`:

| Method | Description |
|--------|-------------|
| `initialize` | Handshake, returns capabilities |
| `tools/list` | Returns all tool definitions |
| `tools/call` | Executes a tool by name |
| `ping` | Health check |

Messages are newline-delimited JSON (JSON Lines), not Content-Length framed.
