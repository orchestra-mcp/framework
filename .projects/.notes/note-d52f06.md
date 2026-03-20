---
id: note-d52f06
title: Orchestra MCP — Release Notes: v1.0.4
type: note
---

Note saved as `note-abd05f` in the `orchestra-agents` project. Here's the full content:

---

# Orchestra MCP — Release Notes: v1.0.4

**Released**: 2026-03-20

---

## Highlights

- **npm distribution**: `npm install -g @orchestra-mcp/cli` now works — postinstall pulls the correct platform binary from GitHub Releases
- **FLOW methodology pack**: Full Discovery & Outcome cycle support via `pack-flow` (18 skills + telemetry hook)
- **8 Flutter platform agents**: Full Flutter coverage across Android, iOS, Linux, macOS, Web, Windows + UI/UX + Orchestra agent
- **PowerSync self-hosted**: One-command Docker-based PowerSync deployment with PostgreSQL WAL replication

---

## Added

### npm Package (`@orchestra-mcp/cli`)
- Published to npm as `@orchestra-mcp/cli` v1.0.4
- Postinstall script downloads the correct platform binary from GitHub Releases
- Supports: macOS (amd64/arm64), Linux (amd64/arm64), Windows (amd64)
- Install: `npm install -g @orchestra-mcp/cli`

### FLOW Methodology Pack (`pack-flow`)
- 18 skills covering Discovery & Outcome cycles, Decision Spine, gates, experiments, and team rituals
- Telemetry hook included
- Install: `orchestra pack install github.com/orchestra-mcp/pack-flow`
- Previously bundled in the framework — now a standalone installable pack

### Flutter Platform Agents (8)
New specialized agents added to the framework:
- `flutter-android` — Android-specific Flutter code, Gradle, Play Store
- `flutter-ios` — iOS-specific Flutter code, App Store, entitlements
- `flutter-linux` — Linux GTK native channels, D-Bus, Snap/Flatpak
- `flutter-macos` — macOS Swift/AppKit channels, menu bar, Keychain
- `flutter-web` — Flutter web builds, PWA, CanvasKit vs HTML renderer
- `flutter-windows` — Windows Win32/WinRT channels, MSIX packaging
- `flutter-ui-ux` — Material 3, Cupertino, adaptive layouts, animations
- `orchestra` — Central coordinator for Orchestra-specific agent tasks

### Prompts Manager Skill
- New `/prompts-manager` skill for managing startup prompts and quick actions via MCP tools

### PowerSync Self-Hosted Deployment
- Docker-based self-hosted PowerSync via `setup-server.sh`
- PostgreSQL WAL logical replication enabled automatically
- Generates `powersync.yaml` and `sync-rules.yaml`
- Caddy reverse proxy route at `/api/powersync/*`
- `deploy.sh powersync` command added

### Auth System Documentation
- New docs covering: Passkey, 2FA, magic link, OAuth2, sessions, and account deletion flows

---

## Changed

### `setup-server.sh` — Idempotency Improvements
The setup script is now safe to re-run on existing servers without overwriting configuration:
- Preserves existing `DB_PASS`, `JWT_SECRET`, `CF_API_TOKEN` from `.env`
- Caddyfile not overwritten if already configured with a real domain
- PowerSync route injected into existing Caddyfile if missing
- `orchestra-next.service` uses `npx next start` instead of `npm start`
- `deploy_next()` uses `pnpm install` instead of `npm ci` (fixes `workspace:*` protocol errors)
- pnpm now installed globally for Next.js dependency resolution
- Docker installed automatically for PowerSync container management

---

## Fixed

| Area | Fix |
|------|-----|
| Release CI | Upgraded Go 1.24 → 1.25 to match `sdk-go` module requirement |
| Release CI | npm publish workflow now triggers after Release completes (`workflow_run`) |
| CI | Allow already-published npm versions without failing the workflow |
| Sudoers | Cover both `/usr/bin/systemctl` and `/bin/systemctl` paths with wildcard args (fixes "password required" error on deploy) |
| Workspace | Isolation: stack detection and project bootstrap on `init` |

---

## Installation / Upgrade

**New install (npm):**
```bash
npm install -g @orchestra-mcp/cli
```

**New install (shell script):**
```bash
curl -fsSL https://raw.githubusercontent.com/orchestra-mcp/framework/main/scripts/install.sh | bash
```

**Upgrade existing install:**
```bash
orchestra update
```

**Install FLOW pack:**
```bash
orchestra pack install github.com/orchestra-mcp/pack-flow
```

---

## Previous Releases

| Version | Date | Summary |
|---------|------|---------|
| v1.0.3 | 2026-03-10 | In-process architecture, selective plugin system, plugin CLI, 24 content packs, multi-agent orchestrator, DevTools (12 plugins), AI awareness (4 plugins) |
| v1.0.2 | 2026-03-05 | CI workflow fixes for Go proxy resolution |
| v1.0.0 | 2026-03-02 | Engine RAG (Rust), Bridge Claude, AgentOps, Sessions, Workspace plugins |
| v0.2.0 | 2026-02-28 | Marketplace plugin, content packs, stack auto-detection |
| v0.1.0 | 2026-02-27 | Plugin host architecture, orchestrator, Go SDK, CLI, core plugins |