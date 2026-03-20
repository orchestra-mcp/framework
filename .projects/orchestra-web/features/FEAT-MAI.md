---
id: FEAT-MAI
kind: bug
priority: P1
project_slug: orchestra-web
status: done
title: Fix notification page full-width, connect dropdown to DB, add seeder + realtime push
type: feature
---

# Fix notification page full-width, connect dropdown to DB, add seeder + realtime push

1. Notification page has maxWidth:700 - remove constraint to make it full-width like other pages
2. Notification bell dropdown in header shows static/hardcoded data - must fetch from DB via settings store
3. Backend SendNotification/NotifyUser handlers don't push via WebSocket - add hub.BroadcastToUser for realtime
4. Add a seeder/seed endpoint to create test notifications for verifying the realtime flow
5. Frontend WebSocket handler needs to listen for notification events and update the store


---
**in-progress -> in-testing** (2026-03-10T21:27:11Z):
## Changes
- apps/next/src/app/(app)/notifications/page.tsx (full-width fix)
- apps/web/internal/handlers/notifications.go (realtime push)
- apps/web/internal/database/seeds.go (test seeder)


---
**in-testing -> in-review** (2026-03-10T21:27:14Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-10T21:27:19Z): Force-advanced to clear blocker per user request.