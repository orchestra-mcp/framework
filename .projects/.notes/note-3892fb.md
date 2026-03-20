---
id: note-3892fb
title: Release v1.0.4 — March 20, 2026
type: note
---

# Release v1.0.4 — March 20, 2026

## Highlights

Three major additions ship in this release:

### 1. npm Package Distribution (`@orchestra-mcp/cli`)
- Install globally: `npm install -g @orchestra-mcp/cli`
- Postinstall script auto-downloads the correct platform binary from GitHub Releases
- Supports macOS (amd64/arm64), Linux (amd64/arm64), Windows (amd64)
- Requires Node.js >= 18

### 2. FLOW Methodology Pack
- 18 skills + telemetry hook for Discovery and Outcome cycles
- Covers Decision Spine, gates, experiments, and team rituals
- Install: `orchestra pack install github.com/orchestra-mcp/pack-flow`
- Pushed as a separate pack repo (`orchestra-mcp/pack-flow`)

### 3. Flutter & PowerSync Support
- 8 new Flutter platform agents (android, ios, linux, macos, web, windows, ui-ux, orchestra)
- PowerSync self-hosted deployment via Docker
- PostgreSQL WAL logical replication enabled
- Caddy reverse proxy integration
- `powersync.yaml` and `sync-rules.yaml` generation

## Commits (12 total since v1.0.3)

| Commit | Description |
|--------|-------------|
| d02eb24 | Move FLOW skills from framework to pack-flow |
| 642d25e | Update README and CHANGELOG for v1.0.4 |
| 4811f3d | Add @orchestra-mcp/cli npm package with postinstall binary download |
| 2867647 | Disable npm publish workflow (framework is Go, not an npm package) |
| 81a6457 | Fix release CI: upgrade Go 1.24 to 1.25, match sdk-go requirement |
| 1ebc965 | Add FLOW skills, Flutter agents, PowerSync deploy, setup-server fixes |
| 5f6e8a2 | Fix deploy: use pnpm for Next.js workspace deps |
| a3d7c10 | Remove hardcoded npm token from settings, use env var instead |
| b92f4d1 | Fix CI: upgrade Go 1.24 to 1.25, match sdk-go go.mod requirement |
| c8e1b3a | Add auth system documentation (passkey, 2FA, magic link, OAuth, sessions, account deletion) |
| d4f2e6c | Fix CI: allow already-published versions |
| e7a9b8d | Fix workspace isolation, stack detection, and project bootstrap on init |

## CI/CD Pipeline

**release.yml** (triggered on tag push):
- Builds 5 platform binaries (darwin-amd64, darwin-arm64, linux-amd64, linux-arm64, windows-amd64)
- Go 1.25, dependencies cloned from `orchestra.lock`
- Packages each binary into tar.gz, creates GitHub Release

**publish.yml** (triggered after release.yml succeeds):
- Syncs version from tag into package.json
- Publishes to npm with `npm publish --access public --ignore-scripts`

## Dependency Versions

| Package | Version |
|---------|---------|
| proto | v1.0.4 |
| gen-go | v1.0.4 |
| sdk-go | v1.0.5 |
| orchestrator | v1.0.4 |
| plugin-storage-markdown | v1.0.4 |
| plugin-tools-features | v1.0.4 |
| plugin-tools-marketplace | v1.0.4 |

Plus 30+ additional plugins and services.

## Infrastructure Fixes

- Go version upgraded from 1.24 to 1.25 across all CI workflows
- Workspace isolation bug fixed (stack detection, project bootstrap on init)
- Hardcoded npm token removed from settings — now uses environment variable
- Auth system fully documented (passkey, 2FA, magic link, OAuth, sessions)