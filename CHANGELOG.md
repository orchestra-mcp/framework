# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.6] - 2026-03-21

### Added

- **`plugin-tools-hooks`** ([`tools.hooks`](https://github.com/orchestra-mcp/plugin-tools-hooks)): New plugin for Claude Code hook event logging
  - `receive_hook_event` — Ingest hook events fired by `orchestra-mcp-hook.sh` (Notification, ToolUse, SubagentStart, TaskComplete, etc.)
  - `get_hook_events` — Query stored hook events with filters (event_type, session_id, limit)
  - Persists events to local SQLite via globaldb
  - Added to workspace (orchestra.lock + Makefile `build-tools-hooks` target)
- **Workflow CRUD tools** in `tools.features`: `create_workflow`, `get_workflow`, `update_workflow`, `delete_workflow`, `list_workflows`
  - JSON/YAML-driven custom workflow definitions (states, transitions, gates)
  - Validates structure: initial state must exist, transitions reference valid states, gates reference defined gate IDs
  - Workflow IDs use `WFL-` prefix; stored in globaldb per project
- **Delegation tools** in `tools.features`: `delegate_feature`, `respond_delegation`, `get_delegation`, `list_delegations`, `get_pending_delegations`
- **Plan tools** in `tools.features`: `create_plan`, `approve_plan`, `breakdown_plan`, `complete_plan`, `delete_plan`, `get_plan`, `list_plans`, `update_plan`
- **Person tools** in `tools.features`: `create_person`, `get_person`, `update_person`, `delete_person`, `list_persons`, `get_person_workload`
- **Request tools** in `tools.features`: `create_request`, `get_request`, `list_requests`, `dismiss_request`, `convert_request`, `get_next_request`
- **Experiment tools** in `tools.features`: `create_experiment`, `start_experiment`, `complete_experiment`, `abandon_experiment`, `update_experiment`, `get_experiment`, `list_experiments`, `spawn_feature_from_experiment`
- **Discovery tools** in `tools.features`: `create_discovery_cycle`, `get_discovery_cycle`, `update_discovery_cycle`, `complete_discovery_cycle`, `delete_discovery_cycle`, `list_discovery_cycles`, `create_discovery_review`, `get_discovery_review`, `record_review_decisions`, `get_discovery_status`
- **Gate requirements tool**: `get_gate_requirements` — returns what's needed for the next transition

### Fixed

- **Windows build** for `plugin-devtools-log-viewer`: Split `process.go` into `process_unix.go` (`//go:build !windows`) and `process_windows.go` (`//go:build windows`)
  - Windows version uses `cmd /C command` and `p.Cmd.Process.Kill()` instead of Unix `syscall.Kill` + `Setpgid`
  - All 5 platforms now build successfully in CI
- **`globaldb.Close()` thread safety** (`sdk-go`): Added `globalMu sync.Mutex` to protect concurrent `Close()` calls
  - Prevents `SQLITE_BUSY` errors when `t.Cleanup` callbacks from one test overlap with the next test's setup
- **SQLite test race** in `plugin-tools-features` workflow tests: Added `dbTestMu sync.Mutex` in `workflow_crud_test.go`
  - Mutex held for full test lifetime (acquired in `setupTestDB`, released in `t.Cleanup`) to fully serialize DB access
  - Each test gets its own isolated `HOME` directory via `t.Setenv("HOME", tmpDir)`
- **`StorageWriteResponse.NewVersion`** field name in `cli` `dual_storage_test.go` (was `Version`, renamed in gen-go v1.0.6)
- **`plugin-tools-hooks` CI build command**: Fixed `go build ./cmd/` → `go build -o /tmp/tools-hooks ./cmd/` (prevents "build output already exists" error)
- **CI**: Removed `Configure git credentials` step from test and lint jobs (plugin-health is public; credentials not needed)

### Changed

- `release.yml` test step now passes `-parallel 1` to serialize SQLite access during test runs

## [1.0.5] - 2026-03-20

### Added

- **MCP protocol `2025-06-18`**: Updated from `2024-11-05` to the latest stable MCP specification
- **Resources capability**: Project features, notes, and docs exposed as MCP resources via `orchestra://` URI scheme
  - `resources/list` — browse features, notes, and docs
  - `resources/read` — read resource content by URI
  - `resources/templates/list` — 3 URI templates for discovery
- **Logging capability**: Server-side log messages with RFC 5424 severity levels
  - `logging/setLevel` — set log threshold (debug through emergency)
  - `notifications/message` — structured log notifications above threshold
- **listChanged notifications**: Dynamic tool update notifications when plugins connect/disconnect
  - `notifications/tools/list_changed` sent automatically on plugin registration
  - `OnToolsChanged` callback system on the in-process router
- **Claude Desktop config**: `orchestra init --ide claude-desktop` configures the Claude Desktop chat app's global MCP config
  - Platform-specific paths: macOS (`~/Library/Application Support/Claude/`), Windows (`%APPDATA%/Claude/`), Linux (`~/.config/Claude/`)
  - Preserves existing servers in `claude_desktop_config.json`
- **MCPB bundle packaging**: `make mcpb` produces `dist/orchestra.mcpb` for one-click install in Claude Desktop
  - MCPB v0.3 manifest with 5 platform targets (darwin arm64/amd64, linux arm64/amd64, windows amd64)
  - Cross-compile build script with version injection
  - 26 validation tests (`scripts/mcpb/test-mcpb.sh`)

### Changed

- MCP initialize response now includes `tools` (with `listChanged: true`), `prompts`, `resources`, and `logging` capabilities
- WebGate (WebSocket :9201) mirrors all new MCP capabilities for browser clients
- README updated with MCP capabilities, protocol documentation, and MCPB packaging

## [1.0.4] - 2026-03-20

### Added

- **npm package**: `@orchestra-mcp/cli` published to npm — `npm install -g @orchestra-mcp/cli`
  - Postinstall script downloads the correct platform binary from GitHub Releases
  - Supports macOS (amd64/arm64), Linux (amd64/arm64), Windows (amd64)
- **FLOW methodology pack** ([`pack-flow`](https://github.com/orchestra-mcp/pack-flow)): 18 skills + telemetry hook — Discovery & Outcome cycles, Decision Spine, gates, experiments, team rituals. Install: `orchestra pack install github.com/orchestra-mcp/pack-flow`
- **Flutter platform agents** (8): `flutter-android`, `flutter-ios`, `flutter-linux`, `flutter-macos`, `flutter-web`, `flutter-windows`, `flutter-ui-ux`, `orchestra`
- **Prompts manager skill**: Manage startup prompts and quick actions via MCP tools
- **PowerSync deployment**: Docker-based self-hosted PowerSync in `setup-server.sh`
  - PostgreSQL WAL logical replication enabled
  - Docker + compose installed and configured
  - `powersync.yaml` and `sync-rules.yaml` generated
  - Caddy reverse proxy route at `/api/powersync/*`
  - `deploy.sh powersync` command added
- **Auth system documentation**: Passkey, 2FA, magic link, OAuth2, sessions, account deletion

### Changed

- **setup-server.sh**: Now idempotent — safe to re-run on existing servers
  - Preserves existing `DB_PASS`, `JWT_SECRET`, `CF_API_TOKEN` from `.env`
  - Caddyfile not overwritten if already configured with a real domain
  - PowerSync route injected into existing Caddyfile if missing
- **setup-server.sh**: `orchestra-next.service` uses `npx next start` instead of `npm start`
- **setup-server.sh**: `deploy_next()` uses `pnpm install` instead of `npm ci` (fixes `workspace:*` protocol)
- **setup-server.sh**: pnpm installed globally for Next.js dependency resolution
- **setup-server.sh**: Docker installed for PowerSync container management

### Fixed

- **Release CI**: Upgraded Go 1.24 to 1.25 to match sdk-go module requirement
- **Release CI**: npm publish workflow now triggers after Release completes (via `workflow_run`)
- **CI**: Allow already-published npm versions without failing
- **Sudoers**: Cover both `/usr/bin/systemctl` and `/bin/systemctl` paths with wildcard args (fixes deploy "password required" error)
- **Workspace isolation**: Stack detection and project bootstrap on init

## [1.0.3] - 2026-03-10

### Added

- **In-process architecture**: Single-process router replaces QUIC mesh for local IDE use
  - `InProcessRouter` dispatches tool calls via direct Go function calls
  - `TCPServer` on port 50101 for desktop apps (Swift/Windows/Linux)
  - `ExternalPlugin` for QUIC-connected optional plugins
- **Selective plugin system**: 4 core plugins bundled, 35 optional plugins installable from GitHub releases
- **Plugin CLI**: `orchestra plugin install/remove/list/enable/disable/search/update/info`
- **Plugin release workflows**: Each optional plugin repo has CI for 4-platform binary builds on tag push
- **Content packs system**: 24 official packs in `packs/` directory
  - Pack format: `pack.json` manifest + `skills/`, `agents/`, `hooks/` directories
  - Stack detection for 12 technology stacks
  - `tools.marketplace` plugin: 15 tools + 5 prompts for pack management
  - CLI: `orchestra pack install/remove/update/list/search/recommend`
- **Multi-agent orchestrator**: `agent.orchestrator` plugin with 20 tools
  - Agent/workflow CRUD, execution engine, testing kit
  - Provider-agnostic routing via bridge plugins
  - `compare_providers` and `evaluate_response` for LLM testing
- **AI provider bridges**: bridge.claude, bridge.openai, bridge.gemini, bridge.ollama, bridge.firecrawl
- **Chat bridges**: bridge.discord, bridge.slack
- **DevTools plugins** (12): git, docker, terminal, ssh, file-explorer, database, debugger, test-runner, log-viewer, services, devops, components
- **AI awareness plugins** (4): screenshot, vision, browser-context, screen-reader
- **Service plugins** (2): voice, notifications
- **Integration plugins**: figma
- **Ship pipeline** (`scripts/ship.sh`): Build, test, sync, tag, release across all repos

### Changed

- Binary size reduced from 35MB to 17MB (4 core plugins in-process, optional plugins separate)
- Architecture changed from QUIC mesh to single-process + optional external plugins
- Package count increased from 44 to 48

## [1.0.2] - 2026-03-05

### Fixed

- CI workflow fixes for Go proxy resolution
- `go.mod` version compatibility across sub-repos

## [1.0.0] - 2026-03-02

### Added

- **Engine RAG plugin** (Rust): 22 MCP tools — Tree-sitter parsing (14 grammars), Tantivy search indexing, SQLite memory with cosine similarity
- **Bridge Claude plugin**: 5 tools — AI prompt, session spawn/kill/status, async execution
- **Tools AgentOps plugin**: 8 tools — Account management with 4 auth methods, budget tracking
- **Tools Sessions plugin**: 6 tools — Cross-plugin AI session management
- **Tools Workspace plugin**: 8 tools — Multi-workspace management with folder tracking
- Install script (`scripts/install.sh`) for macOS, Linux, Windows
- GitHub Actions CI and Release workflows

## [0.2.0] - 2026-02-28

### Added

- `tools.marketplace` plugin — pack management and marketplace (15 tools + 5 prompts)
- Content pack format and registry system
- Stack auto-detection for 12 technology stacks
- Plugin discovery and installation from GitHub releases

## [0.1.0] - 2026-02-27

### Added

- Plugin host architecture with QUIC + mTLS + Protobuf
- Orchestrator with plugin lifecycle management and message routing
- Go Plugin SDK (`sdk-go`) with fluent builder API
- Protobuf contract definitions (`proto` + `gen-go`)
- `storage.markdown` plugin — file-based storage with YAML frontmatter
- `tools.features` plugin — 34 feature-driven workflow tools
- `transport.stdio` plugin — MCP JSON-RPC to QUIC bridge
- `orchestra` CLI with `init`, `serve`, `install`, `plugins`, `update`, `uninstall` commands
- IDE auto-detection for 9 AI coding assistants (Claude, Cursor, VS Code, Windsurf, Codex, Gemini, Zed, Continue, Cline)
- Plugin generator script (`scripts/new-plugin.sh`)
- Sync and release scripts (`scripts/sync-repos.sh`, `scripts/release.sh`)
- Cross-platform release builds (darwin/linux, amd64/arm64)
- 62 unit tests + 1 end-to-end integration test
