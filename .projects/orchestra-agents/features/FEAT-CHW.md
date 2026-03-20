---
id: FEAT-CHW
kind: bug
priority: P1
project_slug: orchestra-agents
status: todo
title: Flutter admin notification send hits wrong endpoint
type: feature
---

# Flutter admin notification send hits wrong endpoint

createAdminNotification() POSTs to `/api/admin/notifications` (the LIST endpoint) but the backend send handler is at `/api/admin/notifications/send`. Also sends `user_id` (int) but backend expects `user_ids` (array).
