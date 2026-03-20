---
id: note-1371cf
title: Fady Mondy
type: note
---

# Fady Mondy

## Profile

- **Role**: Lead (orchestra-agents project)
- **Status**: Active
- **Email**: engfadymondy@gmail.com (MCP), info@3x1.io (public)
- **Username**: fadymondy
- **Person ID**: PERS-BDM
- **Platform**: macOS (darwin 25.4.0), zsh

## What They're Building

**Orchestra MCP** — An AI-agentic IDE targeting 5 platforms with a unified plugin architecture:

### Architecture
- **Go Backend** (Fiber v3, GORM, quic-go) — 36 in-process plugins, MCP protocol stdio transport
- **Rust Engine** (quinn, tantivy, tree-sitter, rusqlite) — RAG service for embeddings & code indexing
- **Frontend Apps** (React/TypeScript via pnpm Turborepo, Zustand, shadcn/ui)
  - macOS/iOS/visionOS: Swift universal app (SwiftUI, tray-only mode, QUIC client)
  - Windows: C#/.NET 8 + WinUI 3 (System.Net.Quic, PasswordVault)
  - Linux: Vala + GTK4/libadwaita (ngtcp2, Flatpak)
  - Flutter: Multi-platform desktop app
  - Chrome: Extension (Manifest V3)

### Plugin System
- **290 MCP tools + 5 prompts** across 36 plugins
- 4 core bundled plugins (storage.markdown, transport.stdio, tools.features, tools.marketplace)
- 32 optional installable plugins via `orchestra plugin install`
- Protocol: length-delimited Protobuf over QUIC + mTLS (ed25519 certs)
- Selective plugin loading (in-process for Go, QUIC for Rust/external)

### Tech Stack
- Go modules: quic-go, grandcat/zeroconf, Fiber, GORM
- Rust crates: quinn, tantivy, tree-sitter, rusqlite, tower-lsp, prost
- Protobuf: buf (Go), prost-build (Rust)
- Frontend: TypeScript, React, Zustand, @orchestra/* shared packages
- Distribution: Single shell script installer (`scripts/install.sh`)

## Working Preferences

### Git & Commits
- **No Co-Authored-By lines** — Claude should not appear as a GitHub contributor
- Always use git config identity from `~/.orchestra/me.json` (person profile)
- Push dependencies in order: core libs first, then downstream
- Script everything; automate release pipelines (`scripts/ship.sh`)

### Design System
- **No gradients** — use solid colors only (easier on eyes)
- **Flat dark theme** — matches Orchestra's iOS, Android, macOS design
- **Color palette**: Use `colors.accent` (#00e5ff solid), `colors.cardBorder` for borders
- **Typography**: IBM Plex Sans Arabic (globally available, NOT Syne or decorative fonts)
- **Avatars**: Rounded-square (`rounded-[14px]`), not circular
- **No atmospheric effects** — no orbital glows, blur effects, or gradient blobs

### Workflow
- Batch implementation sessions: **auto-approve features** without stopping for review each time (keeps flow smooth)
- Use MCP tools for:
  - API testing (`api_request`, `api_list_collections`) — NOT curl
  - Database inspection (`db_connect`, `db_query`) — NOT raw psql/sqlite3
  - Background commands (`log_run`, `log_tail`) — NOT bash &
  - Always verify DB changes with `db_query` after mutations

### Development Gate
- Must run `orchestra serve` before any frontend work (MCP gate at `ws://localhost:9201`)
- Flutter desktop: `flutter run -d macos -t lib/main_local.dart --dart-define-from-file=env/desktop.json`

## Key Decisions

### Architectural
- **Plugin host**: Star topology with QUIC + mTLS + Protobuf (replaces older QUIC mesh)
- **In-process router**: Direct Go function calls for IDE use; TCP bridge for desktop apps
- **Feature-driven workflow**: Doc-first, cyclical delivery (not Scrum sprints)
- **go.mod versioning**: All refs must be Go-proxy-resolvable (go.work for local overrides)

### Distribution
- Shell script only (`scripts/install.sh`) — no Homebrew, no npm package managers
- GitHub Actions release builds (4-platform tarballs)
- Optional plugins built separately via plugin-repo CI workflows

## Current Projects

- **Orchestra Swift App**: macOS/iOS universal app, tray-only mode with menu bar + floating bubble
- **Orchestra Windows App**: WinUI 3, system tray icon, CompactOverlay floating window
- **Orchestra Linux App**: Vala + GTK4, Flatpak primary packaging
- **Flutter Desktop**: Multi-platform app via Flutter (macOS, Windows, Linux, web)
- **Multi-Agent Orchestrator**: Bridge plugins for Claude, OpenAI, Gemini, Ollama, Firecrawl
- **Engine RAG**: Rust plugin with Tree-sitter parsing, Tantivy search, SQLite memory
- **Agent Orchestrator**: 20 MCP tools for agent CRUD, workflows, execution, testing

## Repos & Modules

- **Main**: github.com/orchestra-mcp/framework (root)
- **Libs**: cli, gen-go, sdk-go, orchestrator, plugin-* (35 optional plugins)
- **Org**: github.com/orchestra-mcp/* (9 lib repos + 17 pack repos)
- **Binaries**: All in `bin/` directory (17MB orchestrator + plugin binaries)

## Notes & Learnings

- **Never skip gates** in Orchestra workflow — gates enforce code quality (tests must pass before advance)
- **Kill conditions matter** — discovery briefs require pre-committed kill conditions to avoid sunk-cost decisions
- **WIP limits discipline** — enforces capacity before accepting new work
- **Spine trace** — all work must trace back to vision/strategy/bet/cycle (FLOW ambient rules)
- **Tempo matters** — cycle duration depends on team's build speed; agentic tooling shifts bottleneck to observation & decision capacity

---

*Profile created 2026-03-20 · Fady Mondy leads Orchestra MCP from macOS*
