# Admin External API (Sponsors, Community, GitHub)

All endpoints require `Authorization: Bearer <jwt>` with `role == "admin"`. Non-admin users receive **403 Forbidden**.

## Sponsors

### GET /api/admin/sponsors

List sponsors with optional filters and pagination. Ordered by `sort_order ASC`.

| Param | Type | Description |
|-------|------|-------------|
| search | string | ILIKE filter on name |
| tier | string | Filter by tier (platinum, gold, silver, bronze) |
| status | string | Filter by status (active, inactive) |
| limit | int | Max results (default 50, max 200) |
| offset | int | Skip N results |

Response: `{ "sponsors": [{ id, name, slug, logo_url, website_url, tier, description, order, status, created_at, updated_at }] }`

### POST /api/admin/sponsors

Create a sponsor. Name is required. Auto-generates slug from name if not provided. Tier defaults to `"bronze"`, status defaults to `"active"`.

Body: `{ "name": "Acme Corp", "logo_url": "...", "website_url": "...", "tier": "gold", "description": "...", "order": 1, "status": "active" }`

Returns **201** with `{ "sponsor": { ... } }`. Returns **409** if slug already exists.

### PUT /api/admin/sponsors/:id

Partial update — all fields optional: name, slug, logo_url, website_url, tier, description, order, status. Validates slug uniqueness on change.

Response: `{ "sponsor": { ... } }`

### DELETE /api/admin/sponsors/:id

Hard-deletes the sponsor. Returns **204 No Content**.

## Community Posts

Community post endpoints include author information via a LEFT JOIN with the users table.

### GET /api/admin/community/posts

List community posts with author data and optional filters.

| Param | Type | Description |
|-------|------|-------------|
| search | string | ILIKE filter on title |
| status | string | Filter by status (published, draft, flagged, removed) |
| limit | int | Max results (default 50, max 200) |
| offset | int | Skip N results |

Response: `{ "posts": [{ id, user_id, title, content, status, likes_count, comments_count, author_name, author_handle, author_avatar, created_at, updated_at }] }`

### PATCH /api/admin/community/posts/:id

Update post status, content, and/or title. All fields optional.

Body: `{ "status": "published" }` — valid statuses: published, draft, flagged, removed.

Response: `{ "post": { ... } }`

### DELETE /api/admin/community/posts/:id

Hard-deletes the community post. Returns **204 No Content**.

## GitHub Issues (Cache)

These endpoints manage a local cache of GitHub issues. The sync endpoint is a placeholder for future GitHub API integration.

### GET /api/admin/github/issues

List cached GitHub issues with optional filters.

| Param | Type | Description |
|-------|------|-------------|
| repo | string | Filter by repository (e.g. `org/repo`) |
| state | string | Filter by state (open, closed, merged, draft) |
| type | string | Filter by type (issue, pr) |
| limit | int | Max results (default 50, max 200) |
| offset | int | Skip N results |

Response: `{ "issues": [{ id, github_id, repo, title, body, state, type, author, author_avatar, labels, created_at, updated_at }] }`

### POST /api/admin/github/sync

Trigger a GitHub issue sync. Currently returns a placeholder response — real GitHub API integration requires configuring a token in Settings.

Body (optional): `{ "repo": "org/repo" }`

Response: `{ "ok": true, "message": "GitHub sync is not yet configured..." }`

### DELETE /api/admin/github/issues/:id

Remove a cached GitHub issue. Returns **204 No Content**.

### GET /api/admin/github/repos

List distinct repositories from the cache. Parses `owner` and `name` from the stored `repo` field.

Response: `{ "repos": [{ "owner": "org", "name": "repo", "full_name": "org/repo" }] }`
