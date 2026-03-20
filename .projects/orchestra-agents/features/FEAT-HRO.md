---
estimate: M
id: FEAT-HRO
kind: bug
priority: critical
project_slug: orchestra-agents
status: todo
title: Web push notifications: service worker, FCM registration, and payload handling
type: feature
---

# Web push notifications: service worker, FCM registration, and payload handling

Implement the full web push notification pipeline. Currently only a settings toggle exists. Needs: (1) Service worker at /public/firebase-messaging-sw.js for background push. (2) FCM token registration on login via POST /api/fcm/register. (3) Foreground notification handling with toast UI. (4) Notification permission request flow on first visit. (5) Wire to existing notification admin send endpoint.
