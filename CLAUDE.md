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
│   └── mcp/                  # MCP Plugin — first plugin (85 tools)
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
│       │   ├── tools/        # All 85 MCP tools
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

### MCP Plugin (Pure Go, 85 tools)

The first plugin at `plugins/mcp/`. Provides project management tools via MCP protocol:
- **Build**: `cd plugins/mcp && go build -o orchestra-mcp ./src/cmd/`
- **Run**: `orchestra-mcp --workspace .` (stdio JSON-RPC)
- **Init**: `orchestra-mcp init --workspace .` (creates .mcp.json, .projects/, .claude/, CLAUDE.md, AGENTS.md, CONTEXT.md)
- **Packages**: `types/`, `toon/`, `workflow/`, `helpers/`, `transport/`, `tools/`, `engine/`, `bootstrap/`
- **Workflow**: 7-state lifecycle (todo → in-progress → in-testing → in-docs → in-review → done) with session-scoped locking
- **Multi-Audience PRD**: 4 audience types (business/product/technical/qa) with conditional follow-up questions, validation, agent briefings, auto-backlog generation, and reusable templates
- **Sprint Management**: Create/start/end sprints with auto task promotion (backlog→todo), velocity tracking, burndown charts, standup summaries, retrospectives
- **Parallel Agents**: `get_next_task` supports `epic_id`, `story_id`, `assignee`, `label` filters for scoped agent work
- **WIP Limits**: Configurable max in-progress tasks (global + per-assignee), enforced on `set_current_task`
- **Dependencies**: Task dependency graph with blocker/blocked-by relationships
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
| `/plugin-generator` | Plugin scaffolding | new-plugin.sh, tools/storage/transport templates, SDK patterns |

## Agents

Specialized agents in `.claude/agents/` auto-delegate based on task context. See [AGENTS.md](AGENTS.md) for full details.

| Agent | Role |
|-------|------|
| `quic-protocol` | QUIC transport, mTLS, Protobuf framing, wire protocol |
| `go-architect` | Go orchestrator, plugin SDK, Go plugins (quic-go) |
| `rust-engineer` | Rust plugins (quinn, Tree-sitter, Tantivy, rusqlite) |
| `swift-plugin` | Swift/macOS/iOS plugins (Network.framework, SwiftUI, WidgetKit) |
| `kotlin-plugin` | Kotlin/Android plugins (Netty QUIC, Jetpack Compose) |
| `csharp-plugin` | C#/Windows plugins (System.Net.Quic, WinUI 3) |
| `frontend-dev` | React/TypeScript across all 5 platforms |
| `ui-ux-designer` | shadcn/ui, Tailwind, accessibility, responsive |
| `dba` | Cross-database coordination, sync protocol |
| `postgres-dba` | PostgreSQL (pgvector, JSONB, tsvector, partitioning) |
| `sqlite-engineer` | SQLite (rusqlite, go-sqlite3, WatermelonDB) |
| `redis-engineer` | Redis (pub/sub, Streams, caching, rate limiting) |
| `clickhouse-engineer` | ClickHouse (analytics, metrics, OLAP) |
| `lancedb-engineer` | LanceDB (vector search, embeddings, AI memory) |
| `gtk-plugin` | Linux desktop (GTK4, libadwaita, Flatpak) |
| `mobile-dev` | React Native, WatermelonDB, offline sync |
| `scrum-master` | Feature planning, cyclical delivery, WIP limits, ADRs, coordination |
| `widget-engineer` | Native OS widgets (Swift/C#/JS/QML) |
| `platform-engineer` | macOS CGo, Spotlight, Keychain, iCloud |
| `extension-architect` | Extension system (native, Raycast, VS Code, marketplace) |
| `ai-engineer` | AI chat, RAG, agents, embeddings, vector search |
| `devops` | Docker, GCP, CI/CD, monitoring, deployment |
| `qa-go` | Go testing (go test, testify, httptest, plugin tests) |
| `qa-rust` | Rust testing (cargo test, tokio::test, tempfile) |
| `qa-node` | Node/React testing (vitest, @testing-library, component/store tests) |
| `qa-playwright` | E2E browser testing (Playwright, page objects, visual regression) |

## User Interaction Rule (MANDATORY)

**ALWAYS use the `AskUserQuestion` tool when you need user input.** Never print questions as plain text and wait for a response. The scrum-master agent and project-manager skill must use `AskUserQuestion` for:
- PRD session questions (present MCP question via `AskUserQuestion`, then pass answer to `answer_prd_question`)
- Sprint planning decisions (sprint goal, dates, scope)
- Architecture and design choices
- Priority and scope decisions
- Review approval (Gate 4 requires human approval via `AskUserQuestion`)
- Any clarification or confirmation needed from the user

## Mandatory Workflow Rule

**ALL work MUST go through Orchestra MCP tools.** When the user asks you to do ANY task — build, fix, test, refactor, document, investigate, or change anything:

1. `search_features` / `list_features` — check for existing feature
2. `create_feature` — create one if needed (with `kind`: feature/bug/hotfix/chore)
3. `set_current_feature` — start work (moves to in-progress, acquires session lock)
4. Do the work (each status = ONE activity only, see Strict Phase Rules below)
5. `advance_feature` — pass gates with structured evidence to move to next phase
6. At `in-review`: use `AskUserQuestion` to get user approval
7. `submit_review` — complete

**Never do any work without an active feature.** This includes running tests, writing docs, investigating bugs, and refactoring. The MCP enforces gated transitions — you cannot advance without evidence.

### Feature Kinds

Every feature has a `kind` field: `feature` (default), `bug`, `hotfix`, or `chore`.

- **feature** — New functionality or enhancement
- **bug** — Defect report (Gate 3/docs skipped automatically)
- **hotfix** — Urgent fix (Gate 3/docs skipped automatically)
- **chore** — Maintenance, refactoring, CI work

Use `create_bug_report` as a shortcut for bugs — it sets kind=bug, default priority=P1, and optionally links to the feature that caused the regression via `related_feature`.

### Plan-First for Large Tasks (MANDATORY)

When a user request would result in **3 or more features**, you MUST create a plan before implementation:

1. `create_plan` — Create the plan in `draft` status with title and description
2. Present the plan to the user via `AskUserQuestion` for approval
3. `approve_plan` — Move from draft → approved
4. `breakdown_plan` — Break the plan into features with dependencies (pass a JSON array of feature definitions). This auto-creates all features with `plan:{plan_id}` labels and sets up dependency chains. Plan moves to `in-progress`.
5. Work each feature through the full lifecycle (in order of dependencies)
6. `complete_plan` — After all linked features are `done`, mark the plan as completed

**Do NOT skip the plan step for large tasks.** The plan is stored via MCP and provides traceability.

### User Request Queue

When the user sends a new request while you are busy working on a feature:

1. `create_request` — Save it to the queue with kind (feature/hotfix/bug) and priority
2. Continue working on the current feature
3. After the current feature reaches `done`, call `get_next_request` to pick up the next queued request
4. `convert_request` — Convert it into a feature (auto-creates with correct kind/priority)
5. Work the new feature through the full lifecycle

Use `list_requests` to see the queue and `dismiss_request` to discard irrelevant requests.

### Bug Reporting

When a completed feature causes a regression or breakage:

1. `create_bug_report` — Creates a feature with kind=bug, links to the original feature via `related_feature` param
2. The bug follows the same workflow but **docs gate is auto-skipped** for bugs, hotfixes, and testcases (in-testing → in-review directly)
3. Work the bug through: todo → in-progress → in-testing → in-review → done

### Strict Phase Rules (Each Status = ONE Activity)

**Status moves BEFORE the work, not after.** Call `advance_feature` to move to the next phase — the evidence proves the PREVIOUS phase is complete.

| Status | ALLOWED | FORBIDDEN |
|--------|---------|-----------|
| `in-progress` | Write/edit source code files ONLY | Running tests, writing docs, asking for review |
| `in-testing` | Write test files and run tests ONLY | Writing source code, writing docs, asking for review |
| `in-docs` | Write/edit `.md` files in `/docs` folder ONLY | Writing source code, writing tests, asking for review |
| `in-review` | Call `AskUserQuestion` for user approval ONLY | Writing code, running tests, writing docs |

### Enforced Gates (3 Gates)

The MCP **rejects** `advance_feature` if evidence is missing or malformed. Evidence must be markdown with a `## Section` header and at least 10 characters of content. **File-type validation** checks that referenced files match expected patterns.

| Gate | Transition | Required Section | File-Type Check | Skippable |
|------|-----------|-----------------|-----------------|-----------|
| Code Complete | in-progress → in-testing | `## Changes` **(files)** | Any source files | No |
| Test Complete | in-testing → in-docs | `## Results` **(files)** | Must match test patterns (`*_test.go`, `*.test.ts`, `*.spec.ts`, etc.) | No |
| Docs Complete | in-docs → in-review | `## Docs` **(files)** | Must be `.md` files inside `docs/` folder | **Yes** (bug, hotfix, testcase) |

**File-type validation:** If referenced files don't match expected patterns, MCP returns `needs_approval` error. The agent must then ask the user via `AskUserQuestion` — if the user approves, retry with `force: true`.

**Gate evidence format:**
```
evidence: "## Changes\n- libs/foo/bar.go (added validation)\n- libs/baz/qux.go (new file)"
```

Call `get_gate_requirements` to see what's needed for the next transition.

### Free Transitions (no gate)

These transitions can be done without evidence:
- `todo → in-progress` (via `set_current_feature`), `needs-edits → in-progress` (via `set_current_feature`)

### Review Flow

1. Feature reaches `in-review` after passing all gates
2. Use `AskUserQuestion` to present the work to the user with options: "Approve" / "Needs Edits"
3. Call `submit_review` with the user's decision (`status: "approved"` or `status: "needs-edits"`)

**Do NOT call `submit_review` without user approval.** `advance_feature` is blocked from `in-review` — you must use `submit_review`.

### Session-Scoped Feature Locking

Features are locked to the calling MCP session when work begins. This prevents concurrent sessions from interfering with each other.

- **`set_current_feature`** acquires a session lock (auto-generated UUID per MCP connection)
- **`advance_feature`** checks the lock belongs to the current session, refreshes on success
- **`submit_review`** checks the lock, releases on `done`
- **Lock expiry**: 30 minutes of inactivity — background reaper cleans stale locks every 5 minutes
- **Disconnect cleanup**: When a session disconnects (EOF/context cancel), all its locks are released
- **`unlock_feature`**: Admin recovery tool to force-release a stale lock (no session check)
- **Backward compatible**: Old clients without session IDs are not affected (lock checks gate on `sessionID != ""`)

## Sub-Agent Orchestration Rules

Sub-agents (launched via the `Task` tool) do **NOT** have access to MCP tools. They cannot call `advance_feature`, `set_current_feature`, or any workflow tools. The main agent must own the full feature lifecycle.

### Rules

1. **Sub-agents are for code writing ONLY** — Use sub-agents only during the `in-progress` phase to write code. They return code results, nothing more.
2. **Main agent owns the lifecycle** — The main agent (you) must handle ALL gate transitions: test, document, review. Never delegate gate work to a sub-agent that can't call MCP tools.
3. **One feature at a time** — Work one feature through its FULL lifecycle (in-progress → done) before starting the next. Never batch multiple features in parallel through gates.
4. **Summarize sub-agent results** — After a sub-agent returns, summarize what it built to the user before advancing. The user must see what happened.
5. **Never mark done without gates** — After a sub-agent writes code, YOU must: run tests (Gate 1), verify coverage (Gate 2), write docs (Gate 3), get user review (Gate 4-5). Each gate needs structured evidence with `## Section` headers.

### Correct Pattern

```
1. set_current_feature(feature_id)              → in-progress (lock acquired)
   ALLOWED: write/edit source code ONLY
2. Delegate code writing to sub-agent (Task tool)
3. Sub-agent returns → summarize results to user
4. advance_feature(evidence="## Changes\n- path/to/file.go\n- path/to/other.go")
                                                 → in-testing [CODE COMPLETE gate]
   ALLOWED: write test files + run tests ONLY
5. Write tests, run tests
6. advance_feature(evidence="## Results\n- path/to_test.go\n- test output summary")
                                                 → in-docs [TEST COMPLETE gate]
   ALLOWED: write .md files in /docs folder ONLY
   (bug/hotfix/testcase: auto-skips to in-review)
7. Write documentation in docs/ folder
8. advance_feature(evidence="## Docs\n- docs/feature-x.md (new)")
                                                 → in-review [DOCS COMPLETE gate]
   ALLOWED: AskUserQuestion ONLY
9. AskUserQuestion → present review to user for approval
10. submit_review(status="approved")             → done (lock released)
11. Move to next feature
```

### Anti-Patterns (NEVER DO)

- Spawning 5 sub-agents in parallel, then batch-advancing all 5 features to done
- Letting a sub-agent "handle everything" including testing and docs
- Advancing through gates without providing structured evidence (MCP will reject it)
- Calling `advance_feature` from `in-review` (must use `submit_review`)
- Calling `submit_review` without asking the user via `AskUserQuestion` first
- Starting the next feature before the current one reaches done
- Writing source code during `in-testing` phase (ONLY test code allowed)
- Writing tests during `in-progress` phase (ONLY source code allowed)
- Writing docs outside the `docs/` folder during `in-docs` phase
- Writing fake/boilerplate evidence (e.g., "All tests passed" without actually running tests)
- Requesting review for one feature, then immediately starting work on another before the review is resolved

### Programmatic Guardrails (MCP-Enforced)

These rules are enforced at the MCP tool level — violation attempts will return errors:

1. **Session-scoped locking** — `set_current_feature` acquires a lock tied to the current MCP session (auto-generated UUID). Other sessions cannot advance, submit review, or unlock the feature. MCP returns `session_lock` error if another session holds the lock. Locks auto-expire after 30 minutes of inactivity. Use `unlock_feature` for admin recovery.

2. **Evidence with file paths** — All gates require `## Section` headers with file paths. The MCP rejects evidence that is pure prose without referencing real files.

3. **File-type validation** — The Test Complete gate validates that referenced files match test patterns (`*_test.go`, `*.test.ts`, `*.spec.ts`, etc.). The Docs Complete gate validates that files are `.md` and inside `docs/`. If validation fails, MCP returns `needs_approval` — ask the user, then retry with `force: true`.

4. **Docs gate auto-skip** — For `bug`, `hotfix`, and `testcase` kinds, the transition `in-testing → in-review` is allowed directly (skipping `in-docs`).

5. **Review requires user approval** — `advance_feature` is blocked from `in-review`. Only `submit_review` can move to `done`, and it requires `AskUserQuestion` first.

6. **Model capability check** — `set_current_feature` accepts a `model` parameter. If provided and the feature has an estimate, MCP validates the model can handle that size. Tier 1 (Haiku/Flash/GPT-3.5) → S only. Tier 2 (Sonnet/GPT-4o/Gemini Pro) → S, M. Tier 3 (Opus/GPT-4/Gemini Ultra) → S, M, L, XL. Returns `model_capability` error if the model is too small — break the feature down or use a bigger model.

7. **Timestamped audit trail** — Every transition appends an ISO-8601 timestamp to the feature body.

## Git & Sync (Natural Language Mapping)

The MCP provides 6 git tools that use the current user's person profile for author identity. **Map natural language requests to these tools automatically:**

| User says | Action |
|-----------|--------|
| "sync my changes", "push my updates", "sync to cloud", "upload my changes" | `git_quick_commit` (stage all + commit) → `git_push` |
| "get latest", "pull updates", "sync from cloud", "get project updates" | `git_pull` |
| "save my work", "commit this", "commit these changes" | `git_quick_commit` |
| "push", "push to remote" | `git_push` |
| "create a branch for X", "start working on X" | `git_create_branch` |
| "merge X", "merge branch X" | `git_merge_branch` |
| "what's the status", "git status" | `git_status_summary` |
| "pull and rebase", "rebase on latest" | `git_pull` with `rebase: true` |

### Commit Message Convention

When the user says "sync" or "push" without a specific message, generate a meaningful commit message from the staged changes. If the user provides a message, use it directly.

### Identity

All commits and merges use the current user's person profile (name + github_email from `~/.orchestra/me.json`). No `Co-Authored-By` lines — the person profile IS the author.

## Onboarding (First Interaction)

On the first interaction with a new user or project, check `get_current_user`. If not configured:

1. Use `AskUserQuestion` to collect: name, role, email, github_email, bio, timezone
2. `create_person` with the collected data
3. `set_current_user` to link them to the project
4. Confirm the setup to the user

This only happens once — the profile persists in `~/.orchestra/me.json` across sessions.

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
