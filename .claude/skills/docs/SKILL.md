---
name: orchestra-docs
description: >-
  Navigates and references Orchestra MCP documentation. Activates when finding docs,
  understanding architecture, writing or updating documentation, or answering questions
  about any component; or when the user mentions docs, documentation, README, architecture,
  API reference, or asks how something works.
---

# Orchestra Documentation

## When to Apply

Activate this skill when:

- Finding or reading documentation for any Orchestra component
- Writing or updating documentation
- Answering questions about architecture, APIs, or configuration
- Understanding how components relate to each other
- The user asks "how does X work" for any Orchestra component

## Documentation Map

### Root-Level Docs

| File | Contains |
|------|----------|
| `README.md` | Project overview, quick start, architecture |
| `CLAUDE.md` | Commands, project structure, conventions, skills, agents |
| `CONTEXT.md` | Full architecture, tech stack, data flow, platform details |
| `AGENTS.md` | Agent descriptions and delegation patterns |

### Framework Docs (`docs/`)

| File | Contains |
|------|----------|
| `docs/guides/plugin-system.md` | Plugin system overview, lifecycle, capabilities |
| `docs/guides/creating-plugins.md` | Step-by-step plugin creation guide |
| `docs/api/plugin-contracts.md` | All Plugin interfaces and types reference |
| `docs/api/plugin-manager.md` | PluginManager lifecycle and methods |
| `docs/api/plugin-config.md` | PluginsConfig reference |

### MCP Plugin Docs (`plugins/mcp/`)

| File | Contains |
|------|----------|
| `plugins/mcp/README.md` | Install, usage, tools, REST API, config |
| `plugins/mcp/docs/architecture.md` | Internal architecture, dual-mode, data storage |
| `plugins/mcp/docs/tool-development.md` | How to add new MCP tools |

## Architecture Overview

Orchestra MCP is a Go + Rust + React monorepo with a plugin-first architecture.

```
orchestra-mcp/
├── app/plugins/          # Plugin runtime (Go) — the foundation
├── config/plugins.go     # Plugin registry config
├── plugins/              # All plugins live here
│   └── mcp/              # MCP Plugin (first plugin, standalone Go module)
├── cmd/server/           # Go backend entry point
├── engine/               # Rust engine (gRPC)
├── resources/            # Frontend monorepo (React/TypeScript)
├── tests/                # Test suite (unit + feature + testutil)
├── docs/                 # Framework documentation
├── proto/                # Protobuf definitions
└── database/             # PostgreSQL migrations
```

## Plugin System (Go)

Every feature is a plugin. The runtime lives at `app/plugins/` (8 files):

| File | Purpose |
|------|---------|
| `contracts.go` | Plugin interface + 15 Has* capability interfaces |
| `manager.go` | PluginManager with topological dependency sort |
| `context.go` | PluginContext with DI container |
| `manifest.go` | PluginManifest validated metadata |
| `registry.go` | ServiceRegistry (thread-safe DI) |
| `contributes.go` | ContributesRegistry (commands, menus, settings) |
| `features.go` | FeatureManager (feature flags) |
| `loader.go` | PluginLoader (auto-discovery) |

**Plugin contracts:**
- `Plugin` — ID, Name, Version, Dependencies, Activate, Deactivate
- `HasRoutes` — register Fiber routes
- `HasConfig` — ConfigKey, DefaultConfig
- `HasCommands` — CLI commands
- `HasMcpTools` — MCP tools
- `HasMigrations`, `HasMiddleware`, `HasJobs`, `HasSchedule`, `HasServices`
- `Contributable` — commands, menus, settings, keybindings
- `HasFeatureFlag` — feature flag gating
- `Marketable` — marketplace listing
- `HasDesktopViews`, `HasChromeViews`, `HasWebViews` — platform views

## MCP Plugin

Standalone Go module at `plugins/mcp/` (`github.com/orchestra-mcp/mcp`).

- **40 tools:** project (5), epic (5), story (5), task (5), workflow (5), PRD (7), bugfix (2), usage (3), readme (1), artifacts (2)
- **Dual-mode:** standalone stdio CLI + integrated Go plugin with REST API
- **Extensible:** other plugins push tools via `RegisterExternalTools()`
- **Build:** `cd plugins/mcp && go build -o orchestra-mcp ./src/cmd/`

## Plugin Folder Convention

Every plugin follows this structure (can be pushed as standalone GitHub repo):

```
plugins/{name}/
  go.mod                    # Standalone module
  config/                   # Plugin config structs
  providers/                # Plugin registration (bridges to app/plugins)
  src/                      # All source code
  resources/                # Bundled assets (skills, agents, views)
  tests/                    # Test suite (unit + feature)
  docs/                     # Plugin documentation
  README.md
```

## Test Structure

```
tests/                      # Framework tests
  unit/plugins/             # Plugin runtime unit tests
  feature/plugins/          # Integration tests
  testutil/                 # Shared test helpers (MockPlugin, NewManager)

plugins/mcp/tests/          # MCP plugin tests
  unit/{package}/           # Unit tests by source package
  feature/                  # Integration tests
```

## Code Quality

Three tools enforce code quality across all Go code:

| Tool | Command | Config |
|------|---------|--------|
| **golangci-lint** | `make lint` | `.golangci.yml` — 26 linters enabled |
| **gofumpt** | `make fmt` | Strict formatter (superset of gofmt) |
| **go test** | `make test` | Unit + integration tests |

Full pipeline: `make check` = format check + lint + tests.

Linter config excludes `old-ref/` and `vendor/`, and relaxes `errcheck`/`unparam`/`goconst` for test files.

## Rust Engine

CPU-heavy operations at `engine/` — Tree-sitter, Tantivy, tower-lsp, rusqlite. Go communicates via gRPC.

## Frontends

5 React apps in `resources/` sharing `@orchestra/shared` and `@orchestra/ui`:
- `desktop/` (Wails), `extension/` (Chrome), `dashboard/` (Web), `admin/`, `mobile/` (React Native)

## Writing New Documentation

1. Every plugin gets a `README.md` at its root
2. Framework-level guides go in `docs/guides/`
3. API references go in `docs/api/`
4. Plugin-specific docs go in `plugins/{name}/docs/`
5. Use tables for config, tools, and API references
6. Link between related docs across components
