# AGENTS.md

Specialized agents for Orchestra MCP development. Each agent auto-delegates based on task context.

## Agent Overview

```
scrum-master (PM/Coordinator)
├── go-architect         → Go backend (Fiber v3 + GORM + asynq + stripe-go)
├── rust-engineer        → Rust engine (gRPC + Tree-sitter + Tantivy + tower-lsp)
├── frontend-dev         → React/TypeScript (5 platforms + React Query + Monaco)
├── ui-ux-designer       → Design system + Tailwind + shadcn
├── dba                  → PostgreSQL + SQLite + Redis + Sync
├── mobile-dev           → React Native + WatermelonDB
├── widget-engineer      → Native OS widgets (macOS/Windows/Linux)
├── platform-engineer    → macOS CGo, Spotlight, Keychain, iCloud, Notifications
├── extension-architect  → Extension system (native, Raycast, VS Code, marketplace)
├── ai-engineer          → AI/LLM (Anthropic, OpenAI, langchaingo, RAG, vectors)
└── devops               → Docker + GCP + CI/CD + Monitoring
```

## Agent Details

### `go-architect`
**Scope:** `cmd/`, `app/`, `config/`
**Stack:** Go, Fiber v3, GORM, PostgreSQL, JWT
**Owns:** Handlers, models, services, repositories, routes, middleware, Go tests
**Pattern:** Handler → Service → Repository. All mutations via SyncService.

### `rust-engineer`
**Scope:** `engine/`, `proto/engine/`
**Stack:** Rust, Tonic, Tree-sitter, Tantivy, rusqlite, zstd, AES-GCM
**Owns:** gRPC handlers, parser, indexer, searcher, differ, hasher, local SQLite, Rust tests
**Pattern:** Handler → Service. Proto via `tonic-build` in `build.rs`.

### `frontend-dev`
**Scope:** `resources/`
**Stack:** React, TypeScript, Zustand, Vitest, pnpm, Turborepo
**Owns:** Shared types, stores, hooks, API client, components across all 5 apps
**Pattern:** `@orchestra/shared` for logic, `@orchestra/ui` for components, platform-specific in app dirs.

### `ui-ux-designer`
**Scope:** `resources/ui/`
**Stack:** shadcn/ui, Tailwind CSS v4, Lucide icons
**Owns:** Theme system, component library, layouts, accessibility, responsive design
**Pattern:** All colors via tokens, shadcn primitives untouched, wrap for custom behavior.

### `dba`
**Scope:** `database/`, `app/models/`, `app/services/sync_service.go`
**Stack:** PostgreSQL (pgvector, JSONB, tsvector), SQLite, Redis
**Owns:** Migrations, schema design, sync protocol, conflict resolution, indexes, queries
**Pattern:** UUID PKs, version vectors, sync_log append-only, partitioned by month.

### `mobile-dev`
**Scope:** `resources/mobile/`
**Stack:** React Native, WatermelonDB, React Navigation
**Owns:** Screens, WatermelonDB models/schemas, offline sync, navigation, platform-specific code
**Pattern:** WatermelonDB for local data, `@orchestra/shared` stores for auth, sync on foreground.

### `scrum-master`
**Scope:** Project-wide coordination
**Owns:** Sprint planning, feature breakdown, ADRs, prioritization, cross-team dependencies
**Pattern:** Decompose features into: Proto → DB → Backend → Engine → Sync → Frontend → Tests.

### `widget-engineer`
**Scope:** `bridge/`
**Stack:** Go (build tags), Swift/WidgetKit, C#/Adaptive Cards, JavaScript (GNOME), QML (KDE)
**Owns:** `WidgetBridge` interface, `WidgetData` contract, all platform widget renderers, widget builds
**Pattern:** Go writes JSON → native widget reads. One-way data flow. Build tags for platform routing.

### `platform-engineer`
**Scope:** `bridge/macos/`, `bridge/windows/`, `bridge/linux/`
**Stack:** Go CGo + Objective-C (macOS), go-keychain, CoreSpotlight, UserNotifications, iCloud
**Owns:** Spotlight indexing, Keychain access, iCloud sync, native notifications, file associations, URL schemes
**Pattern:** CGo bridges with `//go:build darwin` tags. Graceful degradation on unsupported platforms.

### `extension-architect`
**Scope:** `app/services/extension_*`, `app/handlers/extension_*`, `packages/api/`, `packages/raycast-compat/`, `packages/vscode-compat/`
**Stack:** Go (extension host, LSP/DAP manager), TypeScript (@orchestra/api, shim packages), Node.js (sandbox)
**Owns:** Extension runtime, permission system, native API, Raycast/VS Code compat layers, marketplace, LSP/DAP integration
**Pattern:** Sandbox → Permission check → API call. Three tiers: native (full), Raycast (~95%), VS Code (~85%).

### `ai-engineer`
**Scope:** `app/services/ai/`, `app/services/vector/`, `app/handlers/ai_handler.go`
**Stack:** Anthropic SDK (Claude), OpenAI SDK (GPT/embeddings), langchaingo, chromem-go, pgvector
**Owns:** AI chat, agent orchestration, RAG pipeline, embeddings, vector search, streaming, token tracking
**Pattern:** Provider interface abstracts LLMs. RAG: embed → search → augment → generate. Stream long responses.

### `devops`
**Scope:** `Makefile`, `docker-compose.yml`, `deploy/`, `turbo.json`
**Stack:** Docker, GCP (Cloud Run, Cloud SQL, CDN, Build, Artifact Registry), nginx, Sentry, PostHog
**Owns:** Build system, containers, CI/CD, deployment, monitoring, logging, Makefile commands
**Pattern:** Docker compose for local dev DBs, native Go/Rust for fast iteration. Cloud Run for production.

## When Agents Activate

| Task | Agent |
|------|-------|
| "Create a new API endpoint" | `go-architect` |
| "Add code search to the engine" | `rust-engineer` |
| "Build a project settings page" | `frontend-dev` + `ui-ux-designer` |
| "Design the sync protocol" | `dba` |
| "Add offline mode to mobile" | `mobile-dev` |
| "Set up CI pipeline" | `devops` |
| "Plan the auth feature" | `scrum-master` |
| "Write a database migration" | `dba` |
| "Add a new proto service" | `rust-engineer` + `go-architect` |
| "Style the sidebar component" | `ui-ux-designer` |
| "Add macOS widget for project status" | `widget-engineer` |
| "Index files for Spotlight search" | `platform-engineer` |
| "Store auth token in Keychain" | `platform-engineer` |
| "Build Linux GNOME extension" | `widget-engineer` |
| "Sync settings to iCloud" | `platform-engineer` |
| "Build the extension API" | `extension-architect` |
| "Add Raycast extension compat" | `extension-architect` |
| "Implement VS Code LSP bridge" | `extension-architect` + `rust-engineer` |
| "Build the extension marketplace" | `extension-architect` + `go-architect` |
| "Add AI chat to the IDE" | `ai-engineer` |
| "Build RAG pipeline for codebase" | `ai-engineer` + `dba` |
| "Set up Cloud Run deployment" | `devops` |
| "Add Sentry error tracking" | `devops` |
| "Integrate Stripe billing" | `go-architect` |

## Cross-Agent Communication

Changes in one domain often require updates in others:

```
Proto change       → go-architect + rust-engineer (regenerate code)
Schema change      → dba (migration) + go-architect (model) + mobile-dev (WatermelonDB)
API change         → go-architect (handler) + frontend-dev (API client + types)
UI component       → ui-ux-designer (design) + frontend-dev (implement across apps)
Sync protocol      → dba (schema) + go-architect (service) + all client agents
Widget data        → widget-engineer (WidgetData contract) + all native renderers (Swift/C#/JS/QML)
macOS feature      → platform-engineer (CGo bridge) + devops (build/packaging)
Extension API      → extension-architect (API design) + go-architect (host) + frontend-dev (SDK types)
AI feature         → ai-engineer (model integration) + go-architect (API endpoints) + frontend-dev (chat UI)
Infrastructure     → devops (deploy/CI/CD) + go-architect (config/secrets) + dba (Cloud SQL setup)
```
