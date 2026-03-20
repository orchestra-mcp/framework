# Admin Users & Teams API

All endpoints require `Authorization: Bearer <jwt>` with `role == "admin"`. Non-admin users receive **403 Forbidden**.

## Dashboard Stats

### GET /api/admin/stats

Returns aggregate counts for the admin dashboard overview.

```json
{
  "users": { "total": 8, "active": 5, "invited": 1, "suspended": 2 },
  "teams": { "total": 3 }
}
```

## Users

### GET /api/admin/users

List all users with optional filters and pagination.

| Param | Type | Description |
|-------|------|-------------|
| search | string | ILIKE filter on name or email |
| status | string | Filter by status (active, invited, suspended, banned) |
| role | string | Filter by role (user, admin, moderator, editor) |
| limit | int | Max results (default 50, max 200) |
| offset | int | Skip N results |

Response: `{ "users": [{ id, name, email, role, status, plan, avatar_url, joined_at }] }`

### GET /api/admin/users/:id

Single user with related entity counts.

Response: `{ "user": { ...fields, project_count, note_count, session_count, team_count, issue_count } }`

### PUT /api/admin/users/:id

Update user name and/or email. Validates email uniqueness.

Body: `{ "name": "New Name", "email": "new@email.com" }`

### DELETE /api/admin/users/:id

Soft-deletes the user. Returns **204 No Content**.

### PUT /api/admin/users/:id/role

Body: `{ "role": "admin" }` — valid values: user, admin, moderator, editor.

### PUT /api/admin/users/:id/status

Body: `{ "status": "suspended" }` — valid values: active, suspended, invited, banned.

## Teams

### GET /api/admin/teams

List teams with optional `?search=` and `?limit=`/`?offset=` pagination.

Response: `{ "teams": [{ id, name, slug, description, avatar_url, plan, owner_id, member_count, created_at, updated_at }] }`

### GET /api/admin/teams/:id

Single team by ID.

### POST /api/admin/teams

Create a team. Auto-generates slug from name if not provided. Auto-adds owner as admin member.

Body: `{ "name": "Team Name", "owner_id": "uuid", "plan": "free", "description": "...", "slug": "..." }`

Returns **201** with `{ "team": {...} }`.

### PUT /api/admin/teams/:id

Partial update — all fields optional: name, slug, description, plan, owner_id, avatar_url.

### DELETE /api/admin/teams/:id

Removes all team members, then soft-deletes the team. Returns **204**.

### GET /api/admin/teams/:id/members

List members with user data (name, email, avatar_url) via JOIN.

Response: `{ "members": [{ team_id, user_id, role, joined_at, name, email, avatar_url }] }`

### POST /api/admin/teams/:id/members

Add a user to the team. Validates user exists and is not already a member. Increments `member_count`.

Body: `{ "user_id": "uuid", "role": "user" }`

Returns **201** with `{ "ok": true }`.

### DELETE /api/admin/teams/:id/members/:userId

Remove a member. Decrements `member_count`. Returns **204**.
