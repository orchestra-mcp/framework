# Admin Support API (Contact, Issues, Notifications)

All endpoints require `Authorization: Bearer <jwt>` with `role == "admin"`. Non-admin users receive **403 Forbidden**.

## Contact Messages

### GET /api/admin/contact

List contact form submissions with optional filters and pagination.

| Param | Type | Description |
|-------|------|-------------|
| search | string | ILIKE filter on name, email, or subject |
| status | string | Filter by status (new, read, replied) |
| limit | int | Max results (default 50, max 200) |
| offset | int | Skip N results |

Response: `{ "messages": [{ id, name, email, subject, message, status, created_at }] }`

### PUT /api/admin/contact/:id/status

Update contact message status.

Body: `{ "status": "read" }` — valid values: new, read, replied.

Response: `{ "message": { ...fields } }`

### DELETE /api/admin/contact/:id

Hard-deletes the contact message. Returns **204 No Content**.

## Issues

### GET /api/admin/issues

List user-reported issues with optional filters and pagination.

| Param | Type | Description |
|-------|------|-------------|
| search | string | ILIKE filter on title |
| status | string | Filter by status (open, in-review, closed) |
| priority | string | Filter by priority (low, medium, high) |
| limit | int | Max results (default 50, max 200) |
| offset | int | Skip N results |

Response: `{ "issues": [{ id, user_id, title, description, status, priority, created_at, updated_at }] }`

### PUT /api/admin/issues/:id/status

Update issue status and/or priority. Both fields are optional (partial update).

Body: `{ "status": "closed", "priority": "high" }`

- Valid statuses: open, in-review, closed
- Valid priorities: low, medium, high

Response: `{ "issue": { ...fields } }`

## Notifications

### GET /api/admin/notifications

List sent notifications with pagination. Ordered by `created_at DESC`.

| Param | Type | Description |
|-------|------|-------------|
| limit | int | Max results (default 50, max 200) |
| offset | int | Skip N results |

Response: `{ "notifications": [{ id, title, message, type, target, target_user_id, created_at }] }`

### POST /api/admin/notifications

Send a new notification. Title and message are required.

Body:
```json
{
  "title": "Maintenance Window",
  "message": "System will be down 2-4am UTC",
  "type": "warning",
  "target": "all",
  "target_user_id": null
}
```

- `type` defaults to `"info"` if omitted
- `target` defaults to `"all"` if omitted
- `target_user_id` is optional (set when target is a specific user)

Returns **201** with `{ "notification": { ...fields } }`.
