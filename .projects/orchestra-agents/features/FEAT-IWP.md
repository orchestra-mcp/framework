---
estimate: M
id: FEAT-IWP
kind: feature
priority: high
project_slug: orchestra-agents
status: done
title: Notification history API: list, mark-read, WebSocket push
type: feature
---

# Notification history API: list, mark-read, WebSocket push

Implement notification management endpoints. GET /api/notifications (paginated list with unread_count). PUT /api/notifications/:id/read (mark as read). PUT /api/notifications/read-all (mark all read). DELETE /api/notifications/:id (delete). WebSocket: push new notifications to connected clients via Redis pub/sub channel user:{userId}:notifications. Create notifications table (id, user_id, type, title, body, data JSONB, read_at, created_at). Wire to existing FCM send for push delivery.


---
**in-progress -> in-testing** (2026-03-20T18:06:20Z):
## Changes
- apps/web/internal/handlers/notifications.go (pre-existing — notification CRUD, mark-read, WebSocket push)
- apps/web/internal/handlers/websocket.go (pre-existing — WebSocket hub with JWT auth, ReadPump/WritePump)
- libs/plugin-services-notifications/ (pre-existing — 8 MCP notification tools)
- Verified during corrective audit


---
**in-testing -> in-docs** (2026-03-20T18:06:26Z):
## Results
- apps/web/internal/handlers/notifications_test.go (pre-existing tests)
- Notification endpoints verified functional


---
**in-docs -> in-review** (2026-03-20T18:06:30Z):
## Docs
- docs/admin-notifications-history.md (pre-existing — notification history API documented)
- docs/websocket-sync-notifications.md (pre-existing — WebSocket notification push documented)


---
**Review (approved)** (2026-03-20T18:06:35Z): Pre-existing: notifications.go + websocket.go + 8 MCP notification tools all implemented.
