# Orchestra MCP Plugin

Model Context Protocol server for AI-powered project management. Pure Go, 40 built-in tools, extensible by other plugins.

## Overview

The MCP plugin provides a complete project management toolkit that AI assistants (Claude Code, Cursor, etc.) can use via the Model Context Protocol. It works in two modes:

- **Standalone CLI** — any project, no Go server needed
- **Integrated plugin** — registered with Orchestra's plugin system, tools available via REST API

## Install

### Homebrew (macOS/Linux)

```bash
brew install orchestra-mcp/tap/orchestra-mcp
```

### npm / npx

```bash
npx @orchestra-mcp/cli init
# or install globally
npm install -g @orchestra-mcp/cli
```

### Direct Download

```bash
curl -fsSL https://raw.githubusercontent.com/orchestra-mcp/mcp/main/scripts/install.sh | sh
```

### From Source

```bash
cd plugins/mcp && go build -o orchestra-mcp ./src/cmd/
```

## Usage

### Standalone CLI

```bash
# Initialize a workspace (creates .projects/, .mcp.json)
./orchestra-mcp init --workspace /path/to/project

# Start stdio MCP server
./orchestra-mcp --workspace /path/to/project
```

### Integrated Plugin

```go
import mcpproviders "github.com/orchestra-mcp/mcp/providers"

pm := plugins.NewPluginManager(cfg)
pm.Register(mcpproviders.NewMcpPlugin())
pm.Boot()

// Tools are now available via:
// - REST: GET /api/mcp/tools, POST /api/mcp/tools/call
// - CollectMcpTools() aggregation
// - Stdio (standalone binary)
```

### Claude Code Integration

Add to `.mcp.json`:

```json
{
  "mcpServers": {
    "orchestra": {
      "command": "plugins/mcp/orchestra-mcp",
      "args": ["--workspace", "."]
    }
  }
}
```

## Structure

```
plugins/mcp/
├── go.mod                          # Standalone module
├── .goreleaser.yaml                # Multi-platform build config
├── config/mcp.go                   # McpConfig (Enabled, Binary)
├── providers/
│   ├── plugin.go                   # McpPlugin — Go plugin registration
│   └── tools.go                    # Tool bridge + REST API routes
├── src/
│   ├── cmd/main.go                 # CLI entry point (--version, --help)
│   ├── version/version.go          # Build-time version (ldflags)
│   ├── types/                      # Protocol, tool, data types
│   ├── toon/toon.go                # TOON file read/write (YAML)
│   ├── workflow/workflow.go        # Issue state machine
│   ├── helpers/                    # Path, string, args, result utilities
│   ├── transport/server.go         # Stdio JSON-RPC server
│   ├── tools/                      # 40 tool implementations
│   └── bootstrap/
│       ├── init.go                 # Workspace init command
│       └── resources/              # go:embed bundled skills + agents
├── tests/
│   └── unit/                       # Unit tests by package
├── npm/                            # npm wrapper (@orchestra-mcp/cli)
├── scripts/install.sh              # Curl one-liner installer
└── docs/                           # Plugin documentation
```

## Tools (40 Built-in)

| Category | Count | Tools |
|----------|-------|-------|
| Project | 5 | `list_projects`, `create_project`, `get_project_status`, `read_prd`, `write_prd` |
| Epic | 5 | `list_epics`, `create_epic`, `get_epic`, `update_epic`, `delete_epic` |
| Story | 5 | `list_stories`, `create_story`, `get_story`, `update_story`, `delete_story` |
| Task | 5 | `list_tasks`, `create_task`, `get_task`, `update_task`, `delete_task` |
| Workflow | 5 | `get_next_task`, `set_current_task`, `complete_task`, `search`, `get_workflow_status` |
| PRD | 7 | `start_prd_session`, `answer_prd_question`, `get_prd_session`, `abandon_prd_session`, `skip_prd_question`, `back_prd_question`, `preview_prd` |
| Bugfix | 2 | `report_bug`, `log_request` |
| Usage | 3 | `get_usage`, `record_usage`, `reset_session_usage` |
| Readme | 1 | `regenerate_readme` |
| Artifacts | 2 | `save_plan`, `list_plans` |

## Extensibility

Other plugins can push tools into the MCP server:

```go
mcpPlugin.RegisterExternalTools([]plugins.McpToolDefinition{
    {
        Name:        "my_custom_tool",
        Description: "A tool from my plugin",
        InputSchema: map[string]any{"type": "object"},
        Handler:     func(input map[string]any) (any, error) { return "ok", nil },
    },
})
```

External tools appear in all channels: stdio, REST API, and `CollectMcpTools()`.

## Workflow State Machine

```
backlog → todo → in-progress → review → done
                → blocked → in-progress
                                        → cancelled
```

Transitions are validated — invalid transitions return an error with valid next states.

## REST API

When integrated with the Go server:

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/api/mcp/tools` | List all tools (built-in + external) |
| `POST` | `/api/mcp/tools/call` | Call a tool by name |
| `GET` | `/health` | Server health + active plugin count |

### Call a tool via REST

```bash
curl -X POST http://localhost:8080/api/mcp/tools/call \
  -H 'Content-Type: application/json' \
  -d '{"name": "list_projects", "arguments": {}}'
```

## Configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `enabled` | bool | `true` | Enable the MCP plugin |
| `binary` | string | `orchestra-mcp` | Path to the standalone binary |
| `workspace` | string | `.` | Default workspace root |

## Testing & Code Quality

```bash
# Run tests
cd plugins/mcp && go test ./tests/... -v

# Run linter
cd plugins/mcp && golangci-lint run ./...

# Format code
gofumpt -w config/ providers/ src/ tests/
```

Or from the repo root:

```bash
make test      # runs all tests (framework + plugin)
make lint      # runs linter on framework + plugin
make fmt       # formats all Go code
make check     # full pipeline: format check + lint + tests
```

## Documentation

- [Architecture](docs/architecture.md) — internal architecture and data flow
- [Tool Development](docs/tool-development.md) — adding new tools
- [Plugin System Guide](../../docs/guides/plugin-system.md) — framework docs
