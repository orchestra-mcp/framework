# Orchestra MCP

Cross-platform productivity IDE built on a plugin-first architecture. Go backend, Rust engine, React frontends across 5 platforms.

## Quick Start

```bash
# Install all dependencies
make install

# Start development (Go + Rust + MCP + frontends in parallel)
make dev

# Production build
make build

# Run all tests
make test
```

## Architecture

```
orchestra-mcp/
├── app/plugins/              # Plugin runtime (Go core)
├── cmd/server/               # HTTP server entry point
├── config/                   # App configuration
├── plugins/                  # All plugins
│   └── mcp/                  # MCP Server (first plugin)
├── engine/                   # Rust engine (Tree-sitter, Tantivy, LSP)
├── resources/                # Frontend monorepo (5 React apps)
├── tests/                    # Test suite
│   ├── unit/                 # Unit tests
│   ├── feature/              # Integration tests
│   └── testutil/             # Shared test helpers
├── proto/                    # Protobuf (Go ↔ Rust)
└── docs/                     # Documentation
```

**Stack:** Go (Fiber v3 + GORM) | Rust (Tonic + Tree-sitter + Tantivy) | React + TypeScript + Zustand | PostgreSQL + SQLite + Redis

## Plugin System

Everything is a plugin. The runtime at `app/plugins/` provides:

- **15 capability interfaces** — HasRoutes, HasConfig, HasMcpTools, HasCommands, HasJobs, HasMiddleware, HasServices, HasMigrations, HasSchedule, Contributable, HasFeatureFlag, Marketable, HasDesktopViews, HasChromeViews, HasWebViews
- **Dependency resolution** — topological sort with cycle detection
- **Feature flags** — disable any plugin via config or runtime
- **Service registry** — thread-safe DI container
- **Contributions** — VS Code-style commands, menus, settings, keybindings, themes
- **Standalone modules** — each plugin has its own `go.mod`, can be a separate GitHub repo

```go
// Register a plugin
pm := plugins.NewPluginManager(cfg)
pm.Register(providers.NewMcpPlugin())
pm.Boot() // resolves deps, activates in order
```

See [Plugin System Guide](docs/guides/plugin-system.md) and [Plugin API Reference](docs/api/plugin-contracts.md).

## MCP Plugin

40-tool Model Context Protocol server for AI-powered project management. Works standalone or integrated.

```bash
# Standalone CLI
cd plugins/mcp && go build -o orchestra-mcp ./src/cmd/
./orchestra-mcp --workspace /path/to/project

# Via Go plugin system
pm.Register(providers.NewMcpPlugin())
```

See [MCP Plugin README](plugins/mcp/README.md) and [MCP Plugin Docs](plugins/mcp/docs/).

## Development

| Command | Description |
|---------|-------------|
| `make dev` | Start all services with hot-reload |
| `make build` | Production build (Go + Rust + MCP + frontends) |
| `make test` | Run all tests across all stacks |
| `make lint` | Run golangci-lint on framework + all plugins |
| `make fmt` | Format all Go code with gofumpt |
| `make fmt-check` | Check formatting without modifying files |
| `make check` | Full CI pipeline (format check + lint + tests) |
| `make install` | Install all dependencies |
| `make clean` | Remove build artifacts |

### Running Tests

```bash
# Framework tests
go test ./tests/...

# MCP plugin tests
cd plugins/mcp && go test ./tests/...

# Rust engine
cd engine && cargo test

# Frontends
pnpm --filter './resources/*' test
```

### Code Quality

Three tools enforce code quality across all Go code:

| Tool | Command | Purpose |
|------|---------|---------|
| **golangci-lint** | `make lint` | 26 linters (errcheck, govet, staticcheck, revive, goconst, misspell, etc.) |
| **gofumpt** | `make fmt` | Strict Go formatter (superset of gofmt, like PHP Pint) |
| **go test** | `make test` | Unit + integration tests across framework and plugins |

Run `make check` before pushing — it runs all three in sequence.

Configuration:
- Linter: [.golangci.yml](.golangci.yml) — 26 linters enabled, test files excluded from errcheck/unparam/goconst
- Formatter: gofumpt with `extra-rules: true`

## Documentation

| Doc | Description |
|-----|-------------|
| [Plugin System Guide](docs/guides/plugin-system.md) | How to create and extend plugins |
| [Plugin API Reference](docs/api/plugin-contracts.md) | All interfaces and types |
| [Plugin Manager Reference](docs/api/plugin-manager.md) | Manager lifecycle and methods |
| [Creating Plugins](docs/guides/creating-plugins.md) | Step-by-step plugin creation |
| [MCP Plugin](plugins/mcp/README.md) | MCP server plugin documentation |
| [CLAUDE.md](CLAUDE.md) | Commands, structure, conventions |
| [CONTEXT.md](CONTEXT.md) | Full architectural context |
| [AGENTS.md](AGENTS.md) | Agent descriptions and delegation |

## Project Structure

| Directory | Purpose |
|-----------|---------|
| `app/plugins/` | Plugin runtime — contracts, manager, registry, features |
| `cmd/server/` | Go HTTP server (Fiber v3) |
| `config/` | App and plugin configuration |
| `plugins/mcp/` | MCP Server plugin (standalone module) |
| `engine/` | Rust engine (gRPC, parsing, indexing, search) |
| `resources/` | React frontends (desktop, chrome, dashboard, mobile, admin) |
| `tests/` | Go test suite (unit + feature + testutil) |
| `proto/` | Protobuf definitions |
| `docs/` | Project documentation |

## License

MIT
