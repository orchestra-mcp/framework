# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Orchestra MCP is an AI-agentic IDE targeting 5 platforms: Desktop (Wails), Chrome Extension, Mobile iOS, Mobile Android, and Web Dashboard. Built with Go (Fiber v3 + GORM), Rust (Tonic gRPC + Tree-sitter + Tantivy), and React/TypeScript (pnpm + Turborepo + Zustand).

The old Laravel codebase is preserved at `old-ref/` for reference. All new development happens in the repo root.

## Key Commands

```bash
# Development
make dev                 # Start Go backend + Rust engine + all frontends
make dev-go              # Go server only (air hot-reload)
make dev-rust            # Rust engine only (cargo watch)
make dev-frontend        # All frontends via Turborepo

# Build
make build               # Build everything (Go + Rust + MCP + frontends)
make build-go            # Go server binary -> bin/server
make build-rust          # Rust engine binary
make build-mcp           # MCP plugin binary -> bin/orchestra-mcp
make build-frontend      # All frontend apps

# MCP Plugin
make mcp-build           # Build MCP plugin binary
make mcp-init            # Initialize MCP in current project
make mcp-start           # Start MCP stdio server

# Install & Test
make install             # Install all deps (Go + Rust + pnpm)
make test                # All tests (Go + MCP + Rust + Frontend)
make clean               # Remove build artifacts

# Proto (generate Go + Rust + TypeScript from .proto files)
make proto

# Add a shadcn component
cd resources/ui && npx shadcn@latest add {component}
```

## Project Structure

```
orchestra-mcp/
├── app/                      # Go backend (Fiber + GORM)
│   ├── handlers/             # HTTP handlers (controllers)
│   ├── models/               # GORM models
│   ├── services/             # Business logic
│   ├── repositories/         # Data access
│   ├── middleware/            # Fiber middleware
│   ├── routes/               # Route registration
│   ├── plugins/              # Plugin runtime (8 files — the foundation)
│   │   ├── contracts.go      # Plugin interface + 15 Has* capability interfaces
│   │   ├── manager.go        # PluginManager with topological sort
│   │   ├── context.go        # PluginContext with DI
│   │   ├── manifest.go       # PluginManifest
│   │   ├── registry.go       # ServiceRegistry (thread-safe DI)
│   │   ├── contributes.go    # ContributesRegistry
│   │   ├── features.go       # FeatureManager (feature flags)
│   │   └── loader.go         # PluginLoader (auto-discovery)
│   └── gen/proto/            # Generated protobuf Go code
├── config/                   # Go configuration
│   └── plugins.go            # Plugin registry config
├── plugins/                  # ALL PLUGINS (each is standalone)
│   └── mcp/                  # MCP Plugin — first plugin (57 tools)
│       ├── go.mod            # Standalone module
│       ├── config/mcp.go     # McpConfig
│       ├── providers/        # Plugin registration (bridges to app/plugins)
│       ├── src/
│       │   ├── cmd/main.go   # CLI entry -> orchestra-mcp binary
│       │   ├── types/        # Type definitions (5 files)
│       │   ├── toon/         # TOON/YAML file parser
│       │   ├── workflow/     # State machine transitions
│       │   ├── helpers/      # Shared utilities (5 files)
│       │   ├── transport/    # MCP stdio JSON-RPC server
│       │   ├── tools/        # All 57 MCP tools (12 files)
│       │   └── bootstrap/    # Workspace init command
│       └── resources/        # Bundled skills + agents
├── cmd/server/main.go        # Go HTTP server entry point
├── engine/                   # Rust engine (gRPC)
│   └── src/                  # Tree-sitter, Tantivy, tower-lsp, rusqlite
├── proto/                    # Shared protobuf definitions
├── database/migrations/      # PostgreSQL SQL migrations
├── resources/                # All frontends (pnpm monorepo)
│   ├── shared/               # @orchestra/shared
│   ├── ui/                   # @orchestra/ui (shadcn/ui)
│   ├── extension/            # Chrome Extension
│   ├── dashboard/            # Web Dashboard
│   ├── desktop/              # Wails Desktop UI
│   └── mobile/               # React Native
├── old-ref/                  # Old Laravel codebase (reference only)
├── Makefile                  # Central command runner
├── go.mod                    # Root Go module
└── pnpm-workspace.yaml       # Frontend workspace config
```

## Architecture

### Plugin System (Component-First)

Everything is a plugin. The plugin runtime at `app/plugins/` provides:
- **Plugin interface** with capability contracts (Has* interfaces)
- **PluginManager** with topological dependency sort and boot sequence
- **FeatureManager** for runtime feature flags — disable any feature by turning off its plugin
- **ServiceRegistry** for plugin-scoped dependency injection
- **ContributesRegistry** for VS Code-style contributions (commands, menus, settings)

Each plugin is a standalone Go module with its own `go.mod`, pushable as a separate GitHub repo. Plugin folder convention: `config/`, `providers/`, `src/`, `resources/`, `README.md`.

### MCP Plugin (Pure Go, 57 tools)

The first plugin at `plugins/mcp/`. Provides project management tools via MCP protocol:
- **Build**: `cd plugins/mcp && go build -o orchestra-mcp ./src/cmd/`
- **Run**: `orchestra-mcp --workspace .` (stdio JSON-RPC)
- **Init**: `orchestra-mcp init --workspace .` (creates .mcp.json, .projects/, .claude/, CLAUDE.md, AGENTS.md, CONTEXT.md)
- **Packages**: `types/`, `toon/`, `workflow/`, `helpers/`, `transport/`, `tools/`, `engine/`, `bootstrap/`
- **Workflow**: 13-state lifecycle (backlog → todo → in-progress → ready-for-testing → in-testing → ready-for-docs → in-docs → documented → in-review → done)
- **Engine**: Optional Rust gRPC engine for vector search memory (auto-starts/stops, TOON fallback)
- **Extensible**: Other plugins push tools via `RegisterExternalTools()` — appears in stdio + REST

### Three-Layer Database

- **PostgreSQL** (cloud) — Source of truth. pgvector for embeddings, JSONB for settings, tsvector for full-text search, partitioned sync_log
- **SQLite** (local) — Offline support on Desktop and Mobile. Managed by Rust engine (rusqlite) and WatermelonDB (React Native)
- **Redis** — Real-time pub/sub for sync, session cache, rate limiting

### Sync System

All syncable entities use UUID primary keys and include `version`, `created_at`, `updated_at`, `deleted_at`. Changes are logged to `sync_log` and published via Redis pub/sub. Clients push local changes and pull remote changes via WebSocket. Conflict resolution: last-write-wins with version vectors.

### Go Backend (Fiber v3 + GORM)

REST API, WebSocket sync hub, job queue, auth (JWT). Architecture: Handlers → Services → Repositories. All data mutations go through SyncService to log changes.

### Rust Engine (Tonic gRPC)

CPU-intensive operations: Tree-sitter parsing, Tantivy search indexing, file diffing, content hashing, zstd compression, AES-256-GCM encryption, local SQLite management. Go communicates with Rust via gRPC.

### React Frontends (pnpm + Turborepo + Zustand)

Five apps share `@orchestra/shared` (types, stores, hooks, API client) and `@orchestra/ui` (shadcn/ui components, Tailwind CSS v4 theme). Platform-specific code stays in each app directory.

## Skills (Slash Commands)

Every skill is both auto-activated by context AND available as a `/command`. Use `/skill-name` to manually load a skill's patterns and conventions.

| Command | Domain | Technologies |
|---------|--------|-------------|
| `/go-backend` | Go API layer | Fiber v3, GORM, JWT, asynq, gocron, stripe-go, zerolog, go-mail, validator |
| `/rust-engine` | Rust engine | Tonic gRPC, Tree-sitter, Tantivy, tower-lsp, ropey, dashmap, ring, rusqlite |
| `/typescript-react` | Frontend | React, TypeScript, Zustand, React Query, Axios, React Router, Monaco, xterm.js, Vite |
| `/ui-design` | Design system | shadcn/ui, Tailwind CSS v4, Lucide icons, themes, responsive, accessibility |
| `/database-sync` | Data layer | PostgreSQL, pgvector, SQLite, Redis, sync protocol, migrations |
| `/proto-grpc` | Contracts | Protobuf, Buf, tonic-build, Go/Rust code generation |
| `/chrome-extension` | Browser | Chrome Manifest V3, service worker, content scripts, side panel |
| `/wails-desktop` | Desktop | Wails v3, Go-React bindings, system tray, window management |
| `/react-native-mobile` | Mobile | React Native, WatermelonDB, React Navigation, offline sync |
| `/native-widgets` | OS Widgets | macOS WidgetKit, Windows Adaptive Cards, Linux GNOME/KDE |
| `/macos-integration` | macOS | CGo, Spotlight, Keychain, iCloud, Notifications, file associations |
| `/native-extensions` | Extension API | Lifecycle, commands, editor, AI, filesystem, UI, permissions, sandbox |
| `/raycast-compat` | Raycast shim | List/Detail/Form/Action components, ~95% compatibility |
| `/vscode-compat` | VS Code shim | LSP/DAP, themes, snippets, grammars, ~85% compatibility |
| `/extension-marketplace` | Marketplace | Publishing, search, CLI, versioning, reviews, auto-updates |
| `/ai-agentic` | AI/LLM | Anthropic SDK, OpenAI SDK, langchaingo, chromem-go, pgvector, RAG |
| `/gcp-infrastructure` | Infrastructure | Cloud Run, Cloud SQL, CDN, Cloud Build, Docker, nginx, Sentry, PostHog |
| `/project-manager` | Process | Sprint planning, feature breakdown, ADRs, cross-team coordination |
| `/docs` | Documentation | Architecture, plugin system, API references, package relationships |
| `/qa-testing` | QA/Testing | Multi-agent: go test, cargo test, vitest, Playwright, coverage, CI |

## Agents

Specialized agents in `.claude/agents/` auto-delegate based on task context. See [AGENTS.md](AGENTS.md) for full details.

| Agent | Role |
|-------|------|
| `go-architect` | Go backend design (Fiber v3, GORM, services, routes) |
| `rust-engineer` | Rust engine (Tonic, Tree-sitter, Tantivy, tower-lsp) |
| `frontend-dev` | React/TypeScript across all 5 platforms |
| `ui-ux-designer` | shadcn/ui, Tailwind, accessibility, responsive |
| `dba` | PostgreSQL, SQLite, Redis, sync protocol |
| `mobile-dev` | React Native, WatermelonDB, offline sync |
| `scrum-master` | Sprint planning, ADRs, cross-team coordination |
| `widget-engineer` | Native OS widgets (Swift/C#/JS/QML) |
| `platform-engineer` | macOS CGo, Spotlight, Keychain, iCloud |
| `extension-architect` | Extension system (native, Raycast, VS Code, marketplace) |
| `ai-engineer` | AI chat, RAG, agents, embeddings, vector search |
| `devops` | Docker, GCP, CI/CD, monitoring, deployment |
| `qa-go` | Go testing (go test, testify, httptest, plugin tests) |
| `qa-rust` | Rust testing (cargo test, tokio::test, tempfile, tonic mock) |
| `qa-node` | Node/React testing (vitest, @testing-library, component/store tests) |
| `qa-playwright` | E2E browser testing (Playwright, page objects, visual regression) |

## Sub-Agent Orchestration Rules

Sub-agents (launched via the `Task` tool) do **NOT** have access to MCP tools. They cannot call `advance_task`, `set_current_task`, or any workflow tools. The main agent must own the full task lifecycle.

### Rules

1. **Sub-agents are for code writing ONLY** — Use sub-agents only during the `in-progress` phase to write code. They return code results, nothing more.
2. **Main agent owns the lifecycle** — The main agent (you) must handle ALL gate transitions: test, document, review. Never delegate gate work to a sub-agent that can't call MCP tools.
3. **One task at a time** — Work one task through its FULL lifecycle (in-progress → done) before starting the next. Never batch multiple tasks in parallel through gates.
4. **Summarize sub-agent results** — After a sub-agent returns, summarize what it built to the user before advancing. The user must see what happened.
5. **Never mark done without gates** — After a sub-agent writes code, YOU must: run tests (Gate 1), verify coverage (Gate 2), write docs (Gate 3), review quality (Gate 4). Each gate needs real evidence.

### Correct Pattern

```
1. set_current_task(task_id)                    → in-progress
2. Delegate code writing to sub-agent (Task tool)
3. Sub-agent returns → summarize results to user
4. Run tests yourself or delegate to qa-* agent
5. advance_task(evidence="test results...")     → ready-for-testing [GATE 1]
6. advance_task                                  → in-testing
7. Verify coverage and edge cases
8. advance_task(evidence="coverage...")          → ready-for-docs [GATE 2]
9. advance_task                                  → in-docs
10. Write documentation yourself
11. advance_task(evidence="docs...")             → documented [GATE 3]
12. advance_task                                 → in-review
13. Review code quality yourself
14. advance_task(evidence="review...")           → done [GATE 4]
15. Move to next task
```

### Anti-Patterns (NEVER DO)

- Spawning 5 sub-agents in parallel, then batch-advancing all 5 tasks to done
- Letting a sub-agent "handle everything" including testing and docs
- Advancing through gates without providing real evidence
- Starting the next task before the current one reaches done

## Conventions

### Go
- Handler methods: `Index`, `Show`, `Store`, `Update`, `Delete`
- Services contain business logic; repositories are pure data access
- All entities use UUID primary keys with `SyncModel` base
- Error responses: `{"error": "code", "message": "...", "details": {}}`
- Always pass `context.Context` through the call chain
- Use interfaces for services (testability)

### Rust
- Use `thiserror` for typed errors, `anyhow` for application errors
- Never use `unwrap()` in production — use `?` operator
- Use `tokio::task::spawn_blocking` for CPU-heavy synchronous work
- Proto code via `tonic-build` in `build.rs` (not buf for Rust)
- Logging via `tracing` crate

### TypeScript/React
- Import types with `type` keyword
- Zustand stores: separate `State` and `Actions` interfaces
- Use `@orchestra/*` aliases, never relative `../../../` cross-package
- All API responses typed with `ApiResponse<T>`
- Functional components only, `FC` for typing

### Database
- All syncable entities: UUID PK + version + timestamps + soft delete
- PostgreSQL: `TIMESTAMPTZ`; SQLite: ISO 8601 strings
- JSONB for flexible metadata, never for queried fields
- Never store file contents in DB — use content_hash + object storage
