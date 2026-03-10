# Remote Repo Workspaces

## Overview

The repo workspaces feature lets users manage GitHub repositories through the Orchestra web dashboard. Users can add repos via GitHub OAuth, interact with them through AI chat (Claude Code), and auto-sync changes back to GitHub.

## Architecture

```
User (Web/Slack/Discord)
        │
        ▼
  Web Server (Fiber)
        │
        ├── REST API: /api/repos/*
        │       │
        │       ▼
        │  WorkspaceManager
        │       │
        │       ├── git clone (via OAuth token)
        │       ├── claude -p (runs in clone dir)
        │       ├── git add + commit + push (auto-sync)
        │       └── git pull --rebase
        │
        └── Bot Chat Routing
                │
                ├── Slack: !chat @workspace-id <prompt>
                └── Discord: !chat @workspace-id <prompt>
```

The server has Claude Code + Orchestra MCP installed. Running `claude -p` in a workspace directory automatically picks up `.mcp.json` and has access to all MCP tools. No separate orchestra processes needed.

## Components

### RepoWorkspace Model

| Field | Type | Description |
|-------|------|-------------|
| UserID | uint | Owner (foreign key to users) |
| TeamID | *string | Optional team scope |
| Name | string | Display name |
| RepoURL | string | Full GitHub URL |
| RepoOwner | string | GitHub owner (org or user) |
| RepoName | string | Repository name |
| Branch | string | Default: main |
| Status | string | pending / cloning / ready / error / syncing |
| CommitSHA | string | Current HEAD SHA |
| LastSyncAt | *time.Time | Last auto-sync timestamp |

### WorkspaceManager Service

- **CloneRepo**: Shallow clone (`--depth 1`) using OAuth token, runs `orchestra init` in the clone directory
- **RunPrompt**: Executes `claude -p "{prompt}" --output-format text` with cwd set to clone path
- **SyncToGitHub**: `git add -A && git commit && git push` with Orchestra Bot identity
- **PullFromGitHub**: `git pull --rebase`
- **AutoSyncLoop**: Background goroutine checks every 5 minutes for dirty workspaces, commits and pushes changes

### REST API

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/repos | List user's workspaces |
| POST | /api/repos | Add repo (triggers background clone) |
| GET | /api/repos/:id | Show workspace details |
| POST | /api/repos/:id/sync | Pull + push to GitHub |
| POST | /api/repos/:id/chat | Send prompt to workspace |
| DELETE | /api/repos/:id | Delete workspace + clone |
| GET | /api/repos/github | List user's GitHub repos |

### Bot Integration (Slack/Discord)

Chat commands support workspace targeting:

```
!chat @workspace-id what is the project status?
!chat @framework list all features
!chat hello                              # uses default_workspace or local AI
```

Bot config (`~/.orchestra/slack.json` or `~/.orchestra/discord.json`):

```json
{
  "api_url": "https://orchestra-mcp.dev",
  "api_token": "orch_xxx",
  "default_workspace": "workspace-uuid"
}
```

**Routing logic:**
1. If prompt starts with `@workspace-id` and API is configured → route through web server
2. If no workspace but `default_workspace` is set → use default
3. Fallback → local `CallTool("ai_prompt", ...)` via orchestrator

## Setup

### Prerequisites

- GitHub OAuth app configured with `user:email repo` scopes
- Claude Code CLI installed on the server
- Orchestra MCP installed on the server

### Configuration

Set `REPO_BASE_DIR` environment variable for clone storage (default: `/var/orchestra/repos`).

## Files

### New Files
- `apps/web/internal/models/repo_workspace.go` — GORM model
- `apps/web/internal/services/workspace_manager.go` — Clone/prompt/sync service
- `apps/web/internal/handlers/repo_workspaces.go` — REST handlers
- `apps/next/src/app/(app)/repos/page.tsx` — Frontend page
- `libs/plugin-bridge-slack/internal/caller.go` — Sender interface + ExtractText
- `libs/plugin-bridge-slack/internal/workspace_client.go` — HTTP client
- `libs/plugin-bridge-discord/internal/caller.go` — Sender interface + ExtractText
- `libs/plugin-bridge-discord/internal/workspace_client.go` — HTTP client

### Modified Files
- `apps/web/internal/handlers/oauth.go` — GitHub scope += repo
- `apps/web/internal/database/database.go` — AutoMigrate RepoWorkspace
- `apps/web/internal/routes/routes.go` — Register /api/repos routes
- `apps/web/cmd/main.go` — WorkspaceManager init + AutoSyncLoop
- `libs/plugin-bridge-slack/internal/bot.go` — SetCaller()
- `libs/plugin-bridge-slack/internal/config.go` — API config fields
- `libs/plugin-bridge-slack/internal/handlers/chat.go` — Workspace routing
- `libs/plugin-bridge-slack/cmd/main.go` — Lazy caller wiring
- `libs/plugin-bridge-slack/export.go` — Sender param
- `libs/plugin-bridge-discord/internal/bot.go` — SetCaller()
- `libs/plugin-bridge-discord/internal/config.go` — API config fields
- `libs/plugin-bridge-discord/internal/handlers/chat.go` — Workspace routing
- `libs/plugin-bridge-discord/cmd/main.go` — Lazy caller wiring
- `libs/plugin-bridge-discord/export.go` — Sender param
- `apps/next/src/components/layout/dashboard-sidebar.tsx` — Repos nav item
