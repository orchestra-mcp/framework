# Contributing to Orchestra MCP Plugin

Contributions are **welcome** and will be fully **credited**.

## Development Setup

```bash
# From the plugin directory
cd plugins/mcp

# Build
go build -o orchestra-mcp ./src/cmd/

# Run tests
go test ./tests/... -v

# Lint
golangci-lint run ./...

# Format
gofumpt -w config/ providers/ src/ tests/
```

Or from the monorepo root:

```bash
make check    # format + lint + tests for everything
```

### Requirements

- Go 1.23+
- golangci-lint
- gofumpt

## Code Quality

All code must pass before merging:

| Check | Command | Description |
|-------|---------|-------------|
| **Format** | `gofumpt -l config/ providers/ src/ tests/` | Must return no output |
| **Lint** | `golangci-lint run ./...` | Zero errors |
| **Test** | `go test ./tests/...` | All tests pass |

## Adding MCP Tools

See [Tool Development Guide](../docs/tool-development.md) for the full process:

1. Create a tool file in `src/tools/`
2. Register it in `providers/tools.go`
3. Write tests in `tests/unit/tools/`

## Plugin Structure

```
plugins/mcp/
├── config/           # Plugin configuration
├── providers/        # Bridge to framework plugin system
├── src/
│   ├── cmd/          # CLI entry point
│   ├── types/        # Type definitions
│   ├── toon/         # TOON file format
│   ├── workflow/     # Issue state machine
│   ├── helpers/      # Utilities
│   ├── transport/    # Stdio JSON-RPC server
│   ├── tools/        # 40 tool implementations
│   └── bootstrap/    # Workspace init
├── tests/            # Test suite
├── docs/             # Documentation
└── resources/        # Bundled skills + agents
```

## Pull Request Process

1. **Fork** and branch from `main`.
2. **Write tests** for new tools or behavior changes.
3. **Run `golangci-lint run ./...`** — zero errors required.
4. **One PR per feature/tool.**
5. **Update docs** if adding tools or changing behavior.
6. **Follow [SemVer v2.0.0](https://semver.org/)** — do not break public APIs.

## Conventions

- Every tool returns `(*types.ToolResult, error)`.
- Use helpers from `src/helpers/` (args, results, paths, strings).
- Data stored as TOON (YAML) files in `.projects/`.
- Workflow transitions must be validated via `workflow.IsValid()`.

**Happy coding!**
