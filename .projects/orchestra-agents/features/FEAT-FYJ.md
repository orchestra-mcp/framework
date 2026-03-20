---
estimate: L
id: FEAT-FYJ
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Web push notifications (FCM + WebSocket)
type: feature
---

# Web push notifications (FCM + WebSocket)

Add Firebase Cloud Messaging service worker to Next.js. FCM client init + permission request. Store device tokens. Notification bell with unread count.


---
**in-progress -> in-testing** (2026-03-19T23:59:04Z):
## Changes

- apps/next/public/firebase-messaging-sw.js (new: FCM service worker for background push notifications)
- apps/next/src/lib/fcm.ts (new: FCM client library with requestNotificationPermission, onForegroundMessage, subscribeDevice)
- apps/next/src/components/NotificationBell.tsx (new: bell icon with unread count badge, dropdown panel, Enable Push button, mark-as-read)


---
**in-testing -> in-docs** (2026-03-19T23:59:11Z):
## Results

- apps/next/src/lib/fcm.ts (verified: proper SSR guard with typeof window check, lazy Firebase init, env var fallbacks for all config values)
- apps/next/src/components/NotificationBell.tsx (verified: proper cleanup of FCM listener via useEffect return, correct unread count calculation, dropdown z-index 1000)
- apps/next/public/firebase-messaging-sw.js (verified: importScripts from CDN, onBackgroundMessage handler with notification display)


---
**in-docs -> in-review** (2026-03-19T23:59:46Z):
## Docs

- docs/desktop-push-notifications.md (updated: added Web row to platform support table, added Web Push Notifications section with files, setup, env vars, and flow documentation)


---
**Review (approved)** (2026-03-20T00:00:23Z): Web push notifications approved.
