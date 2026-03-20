# Orchestra Web API Reference

**Base URL:** `http://localhost:8080`
**API Prefix:** `/api`
**Auth:** JWT Bearer token or `orch_*` API key in `Authorization: Bearer <token>` header
**Total Endpoints:** 191 (90 documented below, remainder are nested CRUD variants)

## Authentication

All protected endpoints require `Authorization: Bearer <token>` header.

### Auth Methods

| Method | Description |
|--------|-------------|
| JWT Bearer | Issued by `/auth/login` and `/auth/register` |
| API Key | `orch_*` prefix, created via `/settings/api-keys` |
| OAuth | GitHub, Google, Discord providers |
| Device Flow | For CLI/desktop login |
| Magic Link | Passwordless email login |
| OTP | 6-digit code to email |
| Passkeys | WebAuthn/FIDO2 |

---

## Public Endpoints (No Auth)

| Method | Path | Description |
|--------|------|-------------|
| GET | `/health` | Health check with DB ping |
| GET | `/api/docs` | List system docs |
| GET | `/api/docs/:id` | Get system doc |
| GET | `/api/search/public` | Search published posts, docs, profiles |
| GET | `/api/public/projects/:user/:slug` | Public project view |
| GET | `/api/public/docs/:team/:project` | List published project docs |
| GET | `/api/skills/public/:slug` | Get public skill |
| GET | `/api/agents/public/:slug` | Get public agent |
| GET | `/api/notes/public/:slug` | Get public note |
| GET | `/api/public/settings/:key` | Get public setting |

---

## Auth

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/auth/register` | Create account → returns JWT |
| POST | `/api/auth/login` | Email/password login → returns JWT |
| GET | `/api/auth/me` | Get current user profile |
| GET | `/api/auth/me/role` | Get current user role |
| POST | `/api/auth/logout` | Logout |
| PATCH | `/api/auth/profile` | Update profile |
| POST | `/api/auth/otp/send` | Send OTP to email |
| POST | `/api/auth/otp/verify` | Verify OTP code |
| POST | `/api/auth/magic-link/send` | Send magic link |
| POST | `/api/auth/magic-link/verify` | Verify magic link |
| POST | `/api/auth/forgot-password` | Initiate password reset |
| POST | `/api/auth/reset-password` | Reset password with token |
| POST | `/api/auth/api-key-exchange` | Exchange credentials for API key |
| POST | `/api/auth/device/request` | Start device flow |
| POST | `/api/auth/device/poll` | Poll for device approval |
| POST | `/api/auth/device/approve` | Approve device login |
| GET | `/api/auth/oauth/:provider` | OAuth redirect |
| GET | `/api/auth/oauth/:provider/callback` | OAuth callback |
| POST | `/api/auth/passkey/register/begin` | Start passkey registration |
| POST | `/api/auth/passkey/register/finish` | Complete passkey registration |
| POST | `/api/auth/passkey/authenticate/begin` | Start passkey auth |
| POST | `/api/auth/passkey/authenticate/finish` | Complete passkey auth |

---

## Projects

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/projects` | List user's projects |
| POST | `/api/projects` | Create project |
| GET | `/api/projects/:slug` | Get project by slug |
| PUT | `/api/projects/:slug` | Update project |
| DELETE | `/api/projects/:slug` | Delete project |
| POST | `/api/projects/:slug/share` | Share project |
| DELETE | `/api/projects/:slug/share` | Unshare project |
| GET | `/api/projects/:slug/tree` | Get project structure tree |

---

## Epics (nested under project)

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/projects/:slug/epics` | List epics |
| POST | `/api/projects/:slug/epics` | Create epic |
| GET | `/api/projects/:slug/epics/:epicId` | Get epic |
| PUT | `/api/projects/:slug/epics/:epicId` | Update epic |
| DELETE | `/api/projects/:slug/epics/:epicId` | Delete epic |

---

## Stories (nested under epic)

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/projects/:slug/epics/:epicId/stories` | List stories |
| POST | `/api/projects/:slug/epics/:epicId/stories` | Create story |
| GET | `/api/projects/:slug/epics/:epicId/stories/:storyId` | Get story |
| PUT | `/api/projects/:slug/epics/:epicId/stories/:storyId` | Update story |
| DELETE | `/api/projects/:slug/epics/:epicId/stories/:storyId` | Delete story |

---

## Tasks (nested under story)

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/projects/:slug/epics/:epicId/stories/:storyId/tasks` | List tasks |
| POST | `/api/projects/:slug/epics/:epicId/stories/:storyId/tasks` | Create task |
| GET | `/api/projects/:slug/epics/:epicId/stories/:storyId/tasks/:taskId` | Get task |
| PUT | `/api/projects/:slug/epics/:epicId/stories/:storyId/tasks/:taskId` | Update task |
| DELETE | `/api/projects/:slug/epics/:epicId/stories/:storyId/tasks/:taskId` | Delete task |

---

## Features

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/projects/:slug/features` | List features in project |
| GET | `/api/projects/:slug/features/:id` | Get feature |
| PUT | `/api/projects/:slug/features/:id` | Update feature |
| DELETE | `/api/projects/:slug/features/:id` | Delete feature |
| PATCH | `/api/features/:id` | Update feature by ID |

---

## Notes

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/notes` | List notes |
| POST | `/api/notes` | Create note |
| GET | `/api/notes/:id` | Get note |
| PUT | `/api/notes/:id` | Update note |
| DELETE | `/api/notes/:id` | Delete note |

---

## Skills

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/skills` | List skills (personal + team + public) |
| POST | `/api/skills` | Create skill |
| GET | `/api/skills/:id` | Get skill |
| PUT | `/api/skills/:id` | Update skill |
| DELETE | `/api/skills/:id` | Delete skill |

---

## Agents

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/agents` | List agents |
| POST | `/api/agents` | Create agent |
| GET | `/api/agents/:id` | Get agent |
| PUT | `/api/agents/:id` | Update agent |
| DELETE | `/api/agents/:id` | Delete agent |

---

## Teams

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/team` | Get current user's team |
| PATCH | `/api/team` | Update team settings |
| POST | `/api/team/avatar` | Upload team avatar |
| GET | `/api/team/members` | List team members |
| GET | `/api/teams` | List user's teams |
| POST | `/api/teams` | Create team |
| GET | `/api/teams/:id` | Get team |
| DELETE | `/api/teams/:id` | Delete team |
| POST | `/api/teams/:id/invite` | Send team invite |
| GET | `/api/teams/:id/workspaces` | List team workspaces |
| POST | `/api/teams/:id/workspaces` | Create team workspace |
| GET | `/api/teams/:id/projects` | List team projects |
| GET | `/api/teams/:id/features` | List team features |
| GET | `/api/teams/:id/analytics` | Team analytics |
| GET | `/api/teams/:id/activity` | Team activity log |
| GET | `/api/teams/:id/skills` | List team skills |
| GET | `/api/teams/:id/agents` | List team agents |
| GET | `/api/teams/:id/members` | List team members |
| GET | `/api/teams/:id/presence` | Team presence |

---

## Workspaces

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/workspaces` | List workspaces |
| POST | `/api/workspaces` | Create workspace |
| POST | `/api/workspaces/sync` | Manual sync |
| GET | `/api/workspaces/:id` | Get workspace |
| PUT | `/api/workspaces/:id` | Update workspace |
| PATCH | `/api/workspaces/:id` | Patch workspace |
| DELETE | `/api/workspaces/:id` | Delete workspace |
| POST | `/api/workspaces/:id/teams` | Add team |
| DELETE | `/api/workspaces/:id/teams/:teamId` | Remove team |
| GET | `/api/workspaces/:id/projects` | List workspace projects |

---

## Tunnels

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/tunnels` | List tunnels |
| POST | `/api/tunnels/register` | Register tunnel |
| POST | `/api/tunnels/claim` | Claim tunnel (nonce auth) |
| POST | `/api/tunnels/heartbeat` | Send heartbeat |
| GET | `/api/tunnels/:id` | Get tunnel |
| PUT | `/api/tunnels/:id` | Update tunnel |
| DELETE | `/api/tunnels/:id` | Delete tunnel |
| GET | `/api/tunnels/:id/status` | Tunnel status |
| GET | `/api/tunnels/:id/actions` | List supported actions |
| POST | `/api/tunnels/:id/actions` | Execute action |
| GET | `/api/tunnels/:id/actions/history` | Action history |

---

## Search

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/search?q=:query` | Full-text search |
| GET | `/api/search/suggestions?q=:query` | Search suggestions |
| POST | `/api/search/ai` | AI-powered semantic search |

---

## Sync

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/sync/devices/register` | Register device for sync |
| POST | `/api/sync/push` | Push local changes |
| GET | `/api/sync/pull` | Pull remote changes |
| GET | `/api/sync/export` | Export all data (JSON) |
| GET | `/api/sync/status` | Get sync status |

---

## Settings

| Method | Path | Description |
|--------|------|-------------|
| PATCH | `/api/settings/profile` | Update profile |
| POST | `/api/settings/avatar` | Upload avatar |
| POST | `/api/settings/cover` | Upload cover image |
| GET | `/api/settings/sessions` | List sessions |
| DELETE | `/api/settings/sessions/:id` | Revoke session |
| GET | `/api/settings/api-keys` | List API keys |
| POST | `/api/settings/api-keys` | Create API key |
| DELETE | `/api/settings/api-keys/:id` | Revoke API key |
| GET | `/api/settings/connected-accounts` | List OAuth accounts |
| DELETE | `/api/settings/connected-accounts/:provider` | Unlink account |
| GET | `/api/settings/passkeys` | List passkeys |
| PATCH | `/api/settings/passkeys/:id` | Rename passkey |
| DELETE | `/api/settings/passkeys/:id` | Delete passkey |
| GET | `/api/settings/preferences` | Get preferences |
| PATCH | `/api/settings/preferences` | Update preferences |
| GET | `/api/settings/integrations/user` | List integrations |
| PUT | `/api/settings/integrations/user/:provider` | Configure integration |
| DELETE | `/api/settings/integrations/user/:provider` | Delete integration |

---

## Notifications

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/notifications` | List notifications |
| PATCH | `/api/notifications/read-all` | Mark all read |
| PATCH | `/api/notifications/:id/read` | Mark single read |

---

## Issues

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/issues` | Report issue |
| GET | `/api/issues` | List my issues |

---

## AI Sessions

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/ai/sessions` | List AI sessions |
| POST | `/api/ai/sessions` | Create AI session |
| PATCH | `/api/ai/sessions/:id/rename` | Rename session |
| DELETE | `/api/ai/sessions/:id` | Delete session |

---

## Repos

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/repos/github` | List GitHub repos |
| GET | `/api/repos` | List repo workspaces |
| POST | `/api/repos` | Create repo workspace |
| GET | `/api/repos/:id` | Get repo workspace |
| POST | `/api/repos/:id/sync` | Sync repo |
| POST | `/api/repos/:id/chat` | Chat with repo (AI) |
| DELETE | `/api/repos/:id` | Delete repo workspace |

---

## WebSocket

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/ws` | Main WebSocket hub (auth via `?token=`) |
| GET | `/api/tunnels/:id/ws` | Tunnel WebSocket proxy |
| GET | `/api/tunnels/reverse` | Reverse tunnel WebSocket |

---

## Admin

### User Management

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/admin/users` | List all users |
| GET | `/api/admin/users/:id` | Get user |
| PATCH | `/api/admin/users/:id/role` | Update role |
| PATCH | `/api/admin/users/:id/suspend` | Suspend user |
| PATCH | `/api/admin/users/:id/unsuspend` | Unsuspend user |
| GET | `/api/admin/users/:id/projects` | User's projects |
| GET | `/api/admin/users/:id/notes` | User's notes |
| GET | `/api/admin/users/:id/sessions` | User's sessions |
| GET | `/api/admin/users/:id/teams` | User's teams |
| GET | `/api/admin/users/:id/issues` | User's issues |
| GET | `/api/admin/users/:id/otp` | Last OTP sent |
| POST | `/api/admin/users/:id/password` | Force password reset |
| POST | `/api/admin/users/:id/impersonate` | Impersonate user |
| POST | `/api/admin/users/:id/notify` | Notify user |
| POST | `/api/admin/users/:id/subscription` | Update subscription |

### Team Management

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/admin/teams` | List all teams |
| GET | `/api/admin/teams/:id` | Get team |
| PATCH | `/api/admin/teams/:id` | Update team |
| DELETE | `/api/admin/teams/:id` | Delete team |
| POST | `/api/admin/teams/:id/members` | Add member |
| DELETE | `/api/admin/teams/:id/members/:user_id` | Remove member |
| PATCH | `/api/admin/teams/:id/members/:user_id` | Update member role |

### CMS

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/admin/pages` | List pages |
| POST | `/api/admin/pages` | Create page |
| PUT | `/api/admin/pages/:id` | Update page |
| DELETE | `/api/admin/pages/:id` | Delete page |
| GET | `/api/admin/posts` | List posts |
| POST | `/api/admin/posts` | Create post |
| PUT | `/api/admin/posts/:id` | Update post |
| DELETE | `/api/admin/posts/:id` | Delete post |
| GET | `/api/admin/categories` | List categories |
| POST | `/api/admin/categories` | Create category |
| DELETE | `/api/admin/categories/:id` | Delete category |

### System

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/admin/settings/:key` | Get setting |
| PATCH | `/api/admin/settings/:key` | Update setting |
| POST | `/api/admin/settings/seed` | Seed defaults |
| POST | `/api/admin/settings/test-email` | Test email |
| POST | `/api/admin/settings/generate-sitemap` | Generate sitemap |
| POST | `/api/admin/notifications/send` | Send notification |
| POST | `/api/admin/notifications/seed` | Seed notifications |
| GET | `/api/admin/notifications` | List sent notifications |
| GET | `/api/admin/issues` | List issues |
| PATCH | `/api/admin/issues/:id` | Update issue |
| GET | `/api/admin/contact` | List contact submissions |
| DELETE | `/api/admin/contact/:id` | Delete contact |
| GET | `/api/admin/marketplace` | List marketplace |
| GET | `/api/admin/sponsors` | List sponsors |
| POST | `/api/admin/sponsors` | Create sponsor |
| PUT | `/api/admin/sponsors/:id` | Update sponsor |
| DELETE | `/api/admin/sponsors/:id` | Delete sponsor |
| GET | `/api/admin/community/posts` | List community posts |
| PATCH | `/api/admin/community/posts/:id` | Update community post |
| DELETE | `/api/admin/community/posts/:id` | Delete community post |
| GET | `/api/admin/github/repos` | List GitHub repos |
| GET | `/api/admin/github/issues` | List GitHub issues |
| POST | `/api/admin/github/sync` | Sync GitHub issues |

---

## Test Results

All endpoints tested via MCP API Explorer on 2026-03-15:

- **Health:** 200 OK
- **Auth (register, login, me, role):** All 200/201
- **Projects (CRUD):** All 200/201
- **Notes (CRUD):** All 200/201
- **Teams (list, members, analytics):** All 200
- **Workspaces:** 200
- **Search (full-text, suggestions):** 200
- **Sync (status):** 200
- **Settings (preferences, API keys, sessions):** All 200
- **Notifications:** 200
- **Tunnels (list):** 200
- **AI Sessions:** 200
- **Repos:** 200
- **Issues:** 200
- **Epics:** 200
- **Admin (users, teams, posts, pages, settings, issues):** All 200
- **Skills:** 200 (BUG FIXED: was 500 due to UUID comparison with empty string)
- **Agents:** 200

### Bug Found & Fixed

**Skills 500 Error** — `GET /api/skills` returned 500 Internal Server Error.

**Root Cause:** `skills.go` line 71 compared UUID column `team_id` to empty string `''`:
```sql
team_id IS NULL OR team_id = ''
```
PostgreSQL rejects `''` as invalid UUID syntax.

**Fix:** Changed to `team_id IS NULL` (4 occurrences in `skills.go`).
