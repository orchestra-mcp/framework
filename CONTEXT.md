# CONTEXT.md

Full architectural context for Orchestra MCP — the AI-agentic IDE.

## Vision

A cross-platform IDE that works on Desktop, Chrome Extension, Mobile (iOS + Android), and Web, with offline support, real-time sync, AI agents, and a plugin system. Built for developers who want their IDE everywhere.

## Tech Stack (92 Technologies)

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Go Backend** | Fiber v3, GORM, golang-jwt, validator | REST API, WebSocket sync, auth |
| **Go Services** | asynq, gocron, go-mail, zerolog, godotenv | Jobs, scheduler, email, logging, config |
| **Go Billing** | stripe-go | Payments and subscriptions |
| **Go Storage** | gocloud.dev/blob, gorilla/websocket | Cloud storage, WebSocket server |
| **Go AI** | Anthropic SDK, OpenAI SDK, langchaingo | LLM integration, agent orchestration |
| **Go Testing** | testify | Test framework |
| **Rust Engine** | Tonic gRPC, tokio | Code parsing, indexing, search, diffing |
| **Rust Parsing** | Tree-sitter (5 languages) | AST generation |
| **Rust Search** | Tantivy | Full-text code search index |
| **Rust LSP** | tower-lsp | Language server protocol |
| **Rust Text** | ropey | Efficient text manipulation |
| **Rust Concurrent** | dashmap | Lock-free concurrent maps |
| **Rust Storage** | rusqlite | Local SQLite database |
| **Rust Crypto** | ring, zstd | AES-256-GCM encryption, compression |
| **Contracts** | Protobuf + Buf | Go ↔ Rust service definitions |
| **Cloud DB** | PostgreSQL + pgvector | Source of truth, vector search, JSONB, FTS |
| **Local DB** | SQLite (rusqlite / WatermelonDB) | Offline support on desktop + mobile |
| **Vectors** | pgvector + chromem-go | Cloud + local vector stores |
| **Real-time** | Redis (go-redis) | Pub/sub sync, session cache, rate limiting |
| **Desktop** | Wails v3 + systray | Go + React native webview app |
| **Chrome** | Manifest V3 | Browser sidebar IDE |
| **Mobile** | React Native + WatermelonDB + React Navigation | iOS + Android offline-first |
| **Mobile Share** | react-native-web | Cross-platform component sharing |
| **Web** | React + Vite + React Router | Dashboard + Admin panel |
| **Data Fetching** | React Query + Axios | Server state + HTTP client |
| **Editor** | Monaco Editor | Code editor component |
| **Terminal** | xterm.js | Terminal emulator component |
| **UI** | shadcn/ui + Tailwind CSS v4 + Lucide | Shared component library |
| **State** | Zustand | Cross-platform state management |
| **Monorepo** | pnpm + Turborepo | Frontend workspace orchestration |
| **Extensions** | Node.js sandbox, LSP, DAP | Native + Raycast (~95%) + VS Code (~85%) |
| **Widgets** | Swift/WidgetKit, C#/Adaptive Cards, JS/QML | Platform-native OS widgets |
| **macOS** | CGo + Objective-C | Spotlight, Keychain, iCloud, Notifications |
| **Infra** | GCP Cloud Run, Cloud SQL, Memorystore | Production compute + databases |
| **CDN** | GCP Cloud CDN + Cloud Storage | Frontend hosting |
| **CI/CD** | GCP Cloud Build + Artifact Registry | Build pipeline + Docker registry |
| **Secrets** | GCP Secret Manager + Pub/Sub | Key management + event messaging |
| **Container** | Docker + nginx + Certbot | Containers, proxy, SSL |
| **Monitor** | GCP Cloud Monitoring + Logging | Server monitoring, centralized logs |
| **Errors** | Sentry | Error tracking + performance |
| **Analytics** | PostHog | Product analytics |
| **Lint** | golangci-lint, cargo clippy, ESLint, Prettier | Code quality |
| **Build** | Makefile + protobuf | CLI commands + gRPC schemas |

## System Architecture

```
┌─────────┐ ┌─────────┐ ┌──────────┐ ┌────────┐ ┌────────────┐
│ Desktop │ │ Chrome  │ │ Mobile   │ │ Mobile │ │ Web        │
│ (Wails) │ │ Ext     │ │ iOS      │ │Android │ │ Dashboard  │
└────┬────┘ └────┬────┘ └────┬─────┘ └───┬────┘ └─────┬──────┘
     │           │           │            │            │
     └───────────┴───────────┴─────┬──────┴────────────┘
                                   │
                              WebSocket + REST
                                   │
                        ┌──────────▼──────────┐
                        │    Go Backend        │
                        │  (Fiber v3 + GORM)   │
                        └──────────┬──────────┘
                                   │
                    ┌──────────────┼──────────────┐
                    │              │              │
              ┌─────▼─────┐ ┌─────▼─────┐ ┌─────▼─────┐
              │ PostgreSQL│ │   Redis   │ │Rust Engine│
              │  (cloud)  │ │  (pubsub) │ │  (gRPC)   │
              └───────────┘ └───────────┘ └─────┬─────┘
                                                │
                                          ┌─────▼─────┐
                                          │  SQLite   │
                                          │  (local)  │
                                          └───────────┘
```

## Data Flow

### Write Path
```
Client writes data locally (SQLite/IndexedDB)
  → Sends change via WebSocket to Go backend
    → Go validates + writes to PostgreSQL + appends sync_log
      → Go publishes to Redis channel sync:{user_id}
        → All other connected clients receive the change
          → Each client applies to local storage
```

### Read Path
```
Client reads from local SQLite (instant, offline-capable)
  → On reconnect: pulls changes since last_sync_version
    → Applies remote changes to local SQLite
```

### Conflict Resolution
```
Last-write-wins with version vectors:
1. Server assigns monotonically increasing version per user
2. On conflict (same entity, same version): latest timestamp wins
3. Tie: higher device_id wins (deterministic)
4. Server is always authoritative — client rebases
```

## Platform Details

### Desktop (Wails v3)
- Go backend + React frontend in native webview (not Chromium)
- Direct function calls from React to Go (Wails bindings)
- System tray for background operation
- Local Rust engine via gRPC (localhost)
- Offline-capable via local SQLite
- Native OS widgets via bridge (`bridge/`) — macOS WidgetKit, Windows Adaptive Cards, Linux GNOME/KDE
- macOS integrations via CGo: Spotlight indexing, Keychain, iCloud sync, native notifications

### Chrome Extension
- Manifest V3 with side panel (400px max width)
- Service worker for background tasks
- Content scripts for GitHub/GitLab integration
- chrome.storage for persistence
- Always-online (no offline mode needed)

### Mobile (React Native)
- WatermelonDB for local SQLite with observable queries
- Sync with backend via `synchronize()` API
- Bottom tab navigation
- 44px minimum touch targets
- Sync on foreground + pull-to-refresh

### Web Dashboard
- Standard React SPA
- Project management, settings, billing
- No offline support (stateless)

### Admin Panel
- Data tables, analytics, user management
- Internal tool (no public access)

## Database Schema (Core Tables)

| Table | Purpose | Key Columns |
|-------|---------|-------------|
| `users` | Authentication | uuid, email, name, plan, settings (JSONB) |
| `projects` | User projects | uuid, user_id, name, path, settings (JSONB) |
| `files` | File metadata | uuid, project_id, path, content_hash, embedding (vector), search_vector (tsvector) |
| `sync_log` | Change tracking | entity_type, entity_id, action, version, device_id, data (JSONB) — partitioned by month |
| `subscriptions` | Billing | stripe_customer_id, plan, status |
| `ai_conversations` | AI chat history | user_id, project_id, messages (JSONB), model, token_count |

## Rust Engine Services

| Service | Technology | Purpose |
|---------|-----------|---------|
| Parser | Tree-sitter | AST generation for 5+ languages |
| LSP Server | tower-lsp | Language intelligence (completions, hover, definitions) |
| Indexer | Tantivy | Full-text code search index |
| Searcher | Tantivy | Query the search index |
| Differ | Myers algorithm | File diff computation |
| DocBuffer | ropey | Efficient text manipulation for large files |
| Sessions | dashmap | Concurrent editor session management |
| Hasher | SHA-256 | Content-addressable storage |
| Compressor | zstd | Data compression for sync |
| Crypto | ring (AES-256-GCM) | Local vault encryption |

## Native Widget Bridge

Cross-platform OS widgets that show project status, git info, and sync state:

```
Go App (Wails)
  └── bridge.NewWidgetBridge()   ← Build tags pick the right platform
        ├── macOS:   JSON → App Group → Swift WidgetKit (~200 lines)
        ├── Windows: JSON → AppData  → C# Adaptive Cards (~200 lines)
        └── Linux:   JSON → ~/.local → GNOME Extension (~150 lines) / KDE Plasmoid (~100 lines)
```

Communication is one-way: Go writes `WidgetData` JSON, native widgets read and render it. `WidgetData` struct in `bridge/bridge.go` is the single contract — changes require updating all four native renderers.

## macOS Native Integrations (CGo)

| Feature | Implementation | Framework |
|---------|---------------|-----------|
| Spotlight search | `bridge/macos/spotlight_darwin.go` | CoreSpotlight |
| Keychain | `bridge/macos/keychain.go` | go-keychain (no CGo) |
| iCloud Drive | `bridge/macos/icloud_darwin.go` | Foundation |
| Notifications | `bridge/macos/notifications_darwin.go` | UserNotifications |
| File associations | `Info.plist` | CFBundleDocumentTypes |
| URL schemes | `Info.plist` + handler | `orchestra://` protocol |
| Apple Silicon | Native Go compile | `GOARCH=arm64` / universal binary |

All features use CGo with Objective-C bridges (`//go:build darwin`). Only WidgetKit requires Swift.

## Plugin System (Component-First Architecture)

Everything is a plugin. The runtime at `app/plugins/` (8 files) provides:

```
Plugin Interface
├── Plugin (core)         — ID, Name, Version, Dependencies, Activate, Deactivate
├── HasRoutes             — Register Fiber HTTP routes
├── HasConfig             — ConfigKey + DefaultConfig
├── HasCommands           — CLI commands
├── HasMcpTools           — MCP tool definitions
├── HasMigrations         — Database migrations
├── HasMiddleware         — HTTP middleware
├── HasJobs               — Background job definitions
├── HasSchedule           — Scheduled tasks (gocron)
├── HasServices           — Service definitions for DI
├── Contributable         — VS Code-style contributions (commands, menus, settings, keybindings)
├── HasFeatureFlag        — Feature flag gating
├── Marketable            — Marketplace metadata
├── HasDesktopViews       — Desktop resource paths
├── HasChromeViews        — Chrome extension resource paths
└── HasWebViews           — Web dashboard resource paths
```

**Plugin Manager** (`app/plugins/manager.go`):
- Topological dependency sort before boot
- Feature flag checks before activation
- `CollectRoutes()`, `CollectMcpTools()`, `CollectJobs()` aggregate across all active plugins
- Thread-safe `ServiceRegistry` for plugin-scoped DI

**Plugin folder convention** (each plugin is a standalone Go module):
```
plugins/{name}/
  go.mod                    # Standalone module (pushable as separate GitHub repo)
  config/                   # Plugin config structs
  providers/                # Plugin registration (bridges to app/plugins via replace directive)
  src/                      # All source code
  resources/                # Bundled assets (skills, agents, views)
```

## MCP Plugin (Pure Go, 40 Tools)

First plugin built on the plugin system. Standalone module at `plugins/mcp/` (`github.com/orchestra-mcp/mcp`).

```
Claude Code ←→ stdio (JSON-RPC 2.0) ←→ orchestra-mcp binary
                                              ↑ reads/writes .projects/ TOON files
```

**Build:** `cd plugins/mcp && go build -o orchestra-mcp ./src/cmd/`

**Packages:**
| Package | Purpose |
|---------|---------|
| `types/` | Protocol, tool, data, PRD, usage type definitions (5 files) |
| `toon/` | TOON (YAML) file read/write via yaml.v3 |
| `workflow/` | State machine: backlog → todo → in-progress → review → done |
| `helpers/` | Paths, strings, args, results, issues (5 files) |
| `transport/` | MCP stdio JSON-RPC server (request loop, tool dispatch) |
| `tools/` | All 40 MCP tools across 11 files |
| `bootstrap/` | Workspace init command (project detection, skill/agent injection) |

**40 tools:** project (5), epic (5), story (5), task (5), workflow (5), PRD (7), bugfix (2), usage (3), readme (1), artifacts (2)

**Issue hierarchy:** Project → Epic → Story → Task/Bug/Hotfix (stored as `.toon` YAML files in `.projects/`)

## Extension System

Three-tier extension ecosystem:

```
Extension Types
├── Native (@orchestra/api)      — Full API access, React UI, AI API, permissions
├── Raycast (@raycast/api shim)  — Quick actions, List/Detail/Form components (~95% compat)
└── VS Code (vscode shim)        — LSP, DAP, themes, snippets, grammars (~85% compat)
```

- **Extension Host** (Go): Loads manifests, enforces permissions, manages lifecycle
- **Extension Sandbox** (Node.js): Isolated runtime for extension JavaScript
- **LSP Manager** (Go): Spawns language servers as child processes (stdin/stdout JSON-RPC)
- **DAP Manager** (Go): Spawns debug adapters with same pattern
- **Marketplace**: PostgreSQL-backed registry, GCS for packages, CLI for publish/install/update

## AI System

```
User → Chat/Agent/Inline Assist
  → Go Backend (AI Layer)
    ├── Anthropic SDK (Claude — primary)
    ├── OpenAI SDK (GPT/embeddings — secondary)
    ├── langchaingo (agent orchestration with tools)
    ├── pgvector (cloud vector store for RAG)
    └── chromem-go (local vector store for offline)
```

- **RAG Pipeline**: Embed question → vector search → augment prompt → generate answer
- **Agent**: langchaingo with Orchestra tools (file search, code edit, terminal, web search)
- **Streaming**: SSE for REST, WebSocket for real-time chat
- **Token tracking**: Per-conversation for billing and rate limiting

## Infrastructure (GCP)

```
Internet → Cloud CDN (GCS bucket, static assets)
  → nginx (Cloud Run, SSL/proxy)
    ├── Go Backend (Cloud Run, auto-scale 1-10)
    ├── Rust Engine (Cloud Run)
    └── Worker (Cloud Run, asynq processor)
  → Cloud SQL (PostgreSQL + pgvector)
  → Memorystore (Redis)
  → Cloud Storage (file uploads, extension packages)
  → Secret Manager (API keys, JWT secrets)
  → Cloud Build → Artifact Registry (CI/CD → Docker images)
  → Sentry (error tracking) + PostHog (analytics)
```

## Development Phases

```
Phase 1 — Foundation
├── Scaffold (Makefile, docker-compose, turbo.json, pnpm workspace)
├── Go server (auth, projects CRUD, health check)
├── PostgreSQL schema + migrations
├── Proto definitions + code generation
├── Rust engine scaffold (gRPC server)
└── Shared TypeScript types + API client

Phase 2 — Core
├── File management + code parsing (Rust)
├── Code search (Tantivy)
├── Sync protocol (Go + Redis + SQLite)
├── Desktop app (Wails) — first frontend
└── Basic UI components (shadcn)

Phase 3 — Multi-Platform
├── Chrome extension
├── Web dashboard
├── Admin panel
├── Mobile app (React Native + WatermelonDB)
└── Offline sync across all clients

Phase 4 — Native & Polish
├── Native OS widgets (macOS WidgetKit, Windows Adaptive Cards, Linux GNOME/KDE)
├── macOS integrations (Spotlight, Keychain, iCloud, Notifications)
├── AI agent integration (MCP tools)
├── Plugin system
├── Billing (Stripe)
├── Performance + production deployment
```

## Old Codebase Reference

The previous Laravel implementation is at `old-ref/`. Key things to reference:
- Plugin contracts: `old-ref/packages/orchestra-mcp/plugins/src/`
- MCP tools pattern: `old-ref/packages/orchestra-mcp/mcp/src/Tools/`
- Chrome build pipeline: `old-ref/packages/orchestra-mcp/chrome/src/Services/ChromeService.php`
- Design system: `old-ref/packages/orchestra-mcp/design-system/resources/js/`

These demonstrate the plugin architecture and UI patterns to rebuild in the new stack.
