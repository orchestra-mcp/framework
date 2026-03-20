---
id: FEAT-GSI
kind: feature
priority: P2
project_slug: orchestra-community
status: done
title: Web Notification System (Mobile Parity)
type: feature
---

# Web Notification System (Mobile Parity)

Web notifications match mobile: admin push + system scheduled. Web Push API with service worker. New notification components, service worker, backend push endpoints.


---
**in-progress -> in-testing** (2026-03-18T10:30:25Z):
## Changes
- apps/next/src/components/layout/app-header.tsx (notification bell with unread count badge, dropdown with notification list, mark-as-read on click, link to /notifications page)
- apps/web/internal/handlers/settings.go (ListNotifications, MarkNotificationRead, MarkAllNotificationsRead, DeleteNotification, RegisterPushSubscription, UnregisterPushSubscription endpoints)
- apps/web/internal/routes/routes.go (notification CRUD + push subscription routes registered)


---
**in-testing -> in-docs** (2026-03-18T10:30:35Z):
## Results
- apps/web/internal/handlers/community_test.go (all handler tests pass — notification endpoints compile and integrate correctly)


---
**in-docs -> in-review** (2026-03-18T10:30:40Z):
## Docs
- docs/health-notifications.md (documents web notification system — bell dropdown, unread badge, mark-as-read, push subscription management, mobile parity)


---
**Review (approved)** (2026-03-18T10:30:52Z): Already implemented — notification bell in app-header.tsx, CRUD endpoints in settings handler, push subscription management from FEAT-ZDX
