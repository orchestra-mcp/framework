# Sync Client (MCP → Cloud)

The `plugin-sync-cloud` package implements bidirectional sync between the local MCP SQLite/Markdown storage and the Orchestra cloud API.

## Architecture

```
orchestra serve
    └── plugin-sync-cloud registered (always in-process)
            ├── Engine.Start() — 30s background polling loop
            ├── doPush()       — local → cloud (changed files)
            └── doPull()       — cloud → local (new records since cursor)
```

## Login Flow

Handled by the `orchestra_login` MCP tool (`internal/tools/login.go`). Three auth methods:

| Method | How |
|--------|-----|
| Email + password | `POST /api/auth/login` |
| OTP (2FA) | `POST /api/auth/otp/verify` |
| Device auth | `POST /api/auth/device/request` → browser → poll `POST /api/auth/device/poll` |

On success: token + user info saved to `~/.orchestra/auth.json` (mode 0600). Engine auth set via `SetAuth()`. `FullImport()` called to bootstrap local SQLite from cloud data.

## Auth Storage

**File**: `~/.orchestra/auth.json`

```json
{
  "token": "eyJ...",
  "user_id": "42",
  "email": "user@example.com",
  "name": "Alice",
  "team_id": "team-uuid",
  "device_id": "device-uuid",
  "api_url": "https://api.orchestra.dev"
}
```

## Sync Cursor

**File**: `~/.orchestra/sync-state/{workspace-hash}.json`

Tracks per-path versions and last sync/pull timestamps. Used for incremental sync.

```json
{
  "device_id": "device-uuid",
  "versions": {
    "my-project/features/FEAT-001.md": 5,
    "my-project/plans/PLAN-XYZ.md": 2
  },
  "last_sync_at": "2026-03-20T10:00:00Z",
  "last_pull_at": "2026-03-20T10:00:00Z"
}
```

## Initial Sync (FullImport)

Called after first login. Downloads all user/team data via `GET /api/sync/export` and writes each entity to local storage. Sets the pull cursor to `now` so subsequent incremental pulls only fetch new changes.

Entity types imported: `project`, `feature`, `note`, `plan`, `person`, `doc`, `prompt`, `action`, `skill`, `agent`, `delegation`, `workflow`, `request`.

Team members are imported as `person` entries under the default project.

## Incremental Sync (doPull)

Runs every 30 seconds. Calls `GET /api/sync/pull?since=<cursor>&device_id=<id>` to fetch only records changed since the last pull. Uses LWW (Last-Write-Wins): if local version ≥ cloud version, the record is skipped.

## Delta Query

The `CloudClient.Delta()` method calls `GET /api/sync/delta` for efficient change detection — returns only entity IDs and actions (no full payloads). Useful for checking what changed before deciding whether to fetch full records.

```go
resp, err := client.Delta(token, "2026-03-20T00:00:00Z", "feature", 1000)
// resp.Changes = [{EntityType: "feature", EntityID: "FEAT-ABC", Action: "upsert", Version: 5}]
```

## Push (doPush)

Compares local storage versions against the cursor. Changed files are batched (50 per request) and sent to `POST /api/sync/push`. Results update the cursor. Idempotency keys prevent duplicate processing.

## Background Sync on Serve

`Engine.Start()` is called automatically at `orchestra serve` startup if a valid auth token exists in `~/.orchestra/auth.json`. The 30-second polling interval can be adjusted via `SetInterval()`.

## Skill/Agent Writeback

When skills or agents are pulled from the cloud, they are also written back to the `.claude/` filesystem:

- Skills → `.claude/skills/<slug>/SKILL.md`
- Agents → `.claude/agents/<slug>.md`

This keeps Claude Code slash commands and agent definitions in sync with cloud changes.

## Files

| File | Purpose |
|------|---------|
| `libs/plugin-sync-cloud/internal/auth/store.go` | Auth credentials (load/save/clear) |
| `libs/plugin-sync-cloud/internal/auth/auth.go` | Auth state helpers |
| `libs/plugin-sync-cloud/internal/sync/client.go` | HTTP client for cloud API (login, push, pull, delta, export) |
| `libs/plugin-sync-cloud/internal/sync/engine.go` | Background sync loop (push + pull) |
| `libs/plugin-sync-cloud/internal/sync/cursor.go` | Sync cursor (per-path versions, timestamps) |
| `libs/plugin-sync-cloud/internal/sync/mapper.go` | Path ↔ entity type mapping |
| `libs/plugin-sync-cloud/internal/tools/login.go` | `orchestra_login` MCP tool |
| `libs/plugin-sync-cloud/internal/tools/logout.go` | `orchestra_logout` MCP tool |
| `libs/plugin-sync-cloud/internal/tools/sync_now.go` | `orchestra_sync_now` MCP tool |
| `libs/plugin-sync-cloud/internal/tools/status.go` | `orchestra_sync_status` MCP tool |
| `libs/plugin-sync-cloud/export.go` | Plugin registration + exported function handles |
