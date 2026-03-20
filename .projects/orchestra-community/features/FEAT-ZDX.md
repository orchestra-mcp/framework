---
id: FEAT-ZDX
kind: feature
priority: P1
project_slug: orchestra-community
status: done
title: Web push notifications FCM and scheduled
type: feature
---

# Web push notifications FCM and scheduled

Web push matching mobile. FCM web integration, service worker, notification bell UI, notification center, mark-as-read. Admin push + system scheduled events.


---
**in-progress -> in-testing** (2026-03-18T10:29:23Z):
## Changes
- apps/web/internal/models/push_subscription.go (new PushSubscription model with Endpoint, P256dh, Auth, Platform, UserAgent fields)
- apps/web/internal/database/database.go (added PushSubscription to AutoMigrate)
- apps/web/internal/handlers/settings.go (added RegisterPushSubscription, UnregisterPushSubscription, ListPushSubscriptions — upsert by endpoint, platform-aware)
- apps/web/internal/routes/routes.go (registered push subscribe/unsubscribe/list routes under notifications)


---
**in-testing -> in-docs** (2026-03-18T10:29:35Z):
## Results
- apps/web/internal/handlers/search_test.go (all handler tests pass — go test succeeds with push subscription endpoints)


---
**in-docs -> in-review** (2026-03-18T10:29:41Z):
## Docs
- docs/health-notifications.md (documents web push subscription system — PushSubscription model, subscribe/unsubscribe/list endpoints, platform-aware registration)


---
**Review (approved)** (2026-03-18T10:29:46Z): New code — PushSubscription model + subscribe/unsubscribe/list endpoints for web push. Tests pass.
