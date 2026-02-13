# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Orchestra MCP is an AI-agentic IDE targeting 5 platforms: Desktop (Wails), Chrome Extension, Mobile iOS, Mobile Android, and Web Dashboard. Built with Go (Fiber v3 + GORM), Rust (Tonic gRPC + Tree-sitter + Tantivy), and React/TypeScript (pnpm + Turborepo + Zustand).

The old Laravel codebase is preserved at `old-ref/` for reference. All new development happens in the repo root.

## Key Commands

```bash
# Start everything (PostgreSQL, Redis, Go server, Rust engine, frontends)
make dev

# Individual services
make dev-server          # Go server only
make dev-engine          # Rust engine only
make dev-frontend        # All frontends via Turborepo
make dev-desktop         # Wails desktop app
make dev-mobile          # React Native

# Build
make build               # Build everything
make build-server        # Go binary
make build-engine        # Rust binary
make build-frontend      # All frontend apps
make build-desktop       # Wails production binary

# Database
make migrate             # Run PostgreSQL migrations
make migrate-rollback    # Rollback last migration
make migrate-fresh       # Drop + recreate
make seed                # Seed database

# Generators
make make-handler name=X   # New Go handler
make make-model name=X     # New GORM model
make make-service name=X   # New service
make make-migration name=X # New SQL migration

# Proto (generate Go + Rust + TypeScript from .proto files)
make proto

# Testing
make test                # All tests (Go + Rust + Frontend)
make test-go             # Go tests only
make test-rust           # Rust tests only
make test-frontend       # Frontend tests only

# Linting
make lint                # golangci-lint + cargo clippy + eslint

# Add a shadcn component
cd resources/ui && npx shadcn@latest add {component}
```

## Project Structure

```
orchestra-mcp/
├── cmd/                      # Entry points
│   ├── server/main.go        # Go HTTP server
│   ├── daemon/main.go        # Desktop tray daemon
│   ├── desktop/main.go       # Wails desktop app
│   └── cli/main.go           # CLI tool
├── app/                      # Go backend (Fiber + GORM)
│   ├── handlers/             # HTTP handlers (controllers)
│   ├── models/               # GORM models
│   ├── services/             # Business logic
│   ├── repositories/         # Data access
│   ├── middleware/            # Fiber middleware
│   ├── routes/               # Route registration
│   ├── requests/             # Validation structs
│   ├── resources/            # Response transformers
│   └── gen/proto/            # Generated protobuf Go code
├── engine/                   # Rust engine (gRPC)
│   ├── Cargo.toml
│   ├── build.rs              # Proto compilation
│   └── src/
│       ├── services/         # Parser, indexer, search, differ
│       ├── handlers/         # gRPC handlers
│       ├── repositories/     # Local SQLite (rusqlite)
│       └── gen/              # Generated proto code
├── proto/                    # Shared protobuf definitions
│   ├── buf.yaml
│   ├── common/               # Shared types
│   ├── engine/               # Engine service definitions
│   ├── sync/                 # Sync protocol
│   └── ai/                   # AI agent protocol
├── database/
│   ├── migrations/           # PostgreSQL SQL migrations
│   └── seeders/              # Go seeder functions
├── resources/                # All frontends (pnpm monorepo)
│   ├── shared/               # @orchestra/shared (types, API, hooks, stores)
│   ├── ui/                   # @orchestra/ui (shadcn/ui component library)
│   ├── extension/            # Chrome Extension
│   ├── dashboard/            # Web Dashboard
│   ├── admin/                # Admin Panel
│   ├── desktop/              # Wails Desktop UI
│   └── mobile/               # React Native (iOS + Android)
├── config/                   # Go configuration
├── storage/                  # Logs, cache, local SQLite
├── tests/                    # Additional test files
├── bridge/                   # Native widget bridge (per-platform)
│   ├── bridge.go             # WidgetBridge interface + WidgetData
│   ├── macos/                # macOS: CGo + Swift WidgetKit
│   ├── windows/              # Windows: C# Adaptive Cards
│   └── linux/                # Linux: GNOME Extension + KDE Plasmoid
├── deploy/                   # Docker, k8s, CI/CD
├── docs/adr/                 # Architecture Decision Records
├── old-ref/                  # Old Laravel codebase (reference only)
├── Makefile                  # Central command runner
├── docker-compose.yml        # Local dev (PostgreSQL + Redis)
└── .env                      # Environment config
```

## Architecture

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
