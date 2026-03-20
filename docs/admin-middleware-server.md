# Admin Middleware & Server Entry Point

## RequireAdmin Middleware

**File:** `orch-ref/app/middleware/admin.go`

`RequireAdminWith(db)` is a Fiber middleware that enforces admin-only access. It must run **after** `RequireAuth` (which sets `userID` in Locals).

### Behavior

1. Reads `userID` from `c.Locals("userID")`
2. Queries `SELECT role FROM users WHERE id = ? AND deleted_at IS NULL`
3. If `role != "admin"` → returns **403 Forbidden** with `{"error":"forbidden","message":"admin access required"}`
4. Soft-deleted users are excluded by the `deleted_at IS NULL` clause

### Roles that get 403

- `user` (default role)
- `team_owner`
- `team_manager`
- Any non-`admin` value

### Usage

```go
admin := app.Group("/api/admin", middleware.RequireAuth, middleware.RequireAdminWith(db))
admin.Get("/users", listUsers(db))
```

## Admin Route Table

**File:** `orch-ref/app/handlers/admin_routes.go`

`RegisterAdminRoutes(app, db)` mounts all `/api/admin/*` endpoints with both `RequireAuth` and `RequireAdminWith` as group middleware.

| Method | Path | Handler |
|--------|------|---------|
| GET | /api/admin/stats | adminStats |
| GET | /api/admin/users | listUsers |
| GET | /api/admin/users/:id | getUser |
| PUT | /api/admin/users/:id | updateUser |
| DELETE | /api/admin/users/:id | deleteUser |
| PUT | /api/admin/users/:id/role | updateUserRole |
| PUT | /api/admin/users/:id/status | updateUserStatus |
| GET | /api/admin/teams | listTeams |
| GET | /api/admin/teams/:id | getTeam |
| POST | /api/admin/teams | createTeam |
| PUT | /api/admin/teams/:id | updateTeam |
| DELETE | /api/admin/teams/:id | deleteTeam |
| GET | /api/admin/teams/:id/members | listTeamMembers |
| POST | /api/admin/teams/:id/members | addTeamMember |
| DELETE | /api/admin/teams/:id/members/:userId | removeTeamMember |
| GET | /api/admin/settings | listSettings |
| PUT | /api/admin/settings | upsertSetting |
| DELETE | /api/admin/settings/:key | deleteSetting |
| GET | /api/admin/pages | listPages |
| GET | /api/admin/pages/:id | getPage |
| POST | /api/admin/pages | createPage |
| PUT | /api/admin/pages/:id | updatePage |
| DELETE | /api/admin/pages/:id | deletePage |
| GET | /api/admin/categories | listCategories |
| POST | /api/admin/categories | createCategory |
| PUT | /api/admin/categories/:id | updateCategory |
| DELETE | /api/admin/categories/:id | deleteCategory |
| GET | /api/admin/contact | listContactMessages |
| PUT | /api/admin/contact/:id/status | updateContactStatus |
| DELETE | /api/admin/contact/:id | deleteContactMessage |
| GET | /api/admin/issues | listIssues |
| PUT | /api/admin/issues/:id/status | updateIssueStatus |
| GET | /api/admin/notifications | listNotifications |
| POST | /api/admin/notifications | createNotification |
| GET | /api/admin/sponsors | listSponsors |
| POST | /api/admin/sponsors | createSponsor |
| PUT | /api/admin/sponsors/:id | updateSponsor |
| DELETE | /api/admin/sponsors/:id | deleteSponsor |
| GET | /api/admin/community | listCommunityPosts |
| PUT | /api/admin/community/:id/status | updateCommunityStatus |
| DELETE | /api/admin/community/:id | deleteCommunityPost |
| GET | /api/admin/github/issues | listGitHubIssues |
| POST | /api/admin/github/sync | syncGitHubIssues |
| DELETE | /api/admin/github/issues/:id | deleteGitHubIssue |

All handlers currently return **501 Not Implemented** and will be replaced with full DB-backed implementations in subsequent features.

## Server Entry Point

**File:** `orch-ref/cmd/server/main.go`

Standalone HTTP server that wires GORM, repositories, services, and handlers.

### Startup sequence

1. Load `.env` via godotenv (optional)
2. Connect to PostgreSQL via `DATABASE_URL`
3. Auto-migrate core tables (users, devices, refresh_tokens) and admin tables
4. Wire DI: repos → services → handlers
5. Create Fiber app with error handler
6. Register `/api/ping` (health), auth routes, admin routes
7. Listen on `PORT` (default 8080)

### Environment variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| DATABASE_URL | Yes | — | PostgreSQL connection string |
| JWT_SECRET | Yes | — | HMAC key for JWT signing |
| PORT | No | 8080 | HTTP listen port |
