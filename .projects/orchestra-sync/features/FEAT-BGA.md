---
estimate: S
id: FEAT-BGA
kind: feature
priority: P2
project_slug: orchestra-sync
status: done
title: Desktop Push Notifications for Sync
type: feature
---

# Desktop Push Notifications for Sync

When SyncEntitySharedEvent or SyncEntityUpdatedEvent arrives via WS, show desktop notification. Badge count on sidebar sync icon. Modify core/ws/ws_manager.dart event handling.


---
**in-progress -> in-testing** (2026-03-18T09:53:37Z):
## Changes
- apps/flutter/lib/core/sync/sync_notification_service.dart (SyncNotificationService shows desktop notifications via flutter_local_notifications for SyncEntityUpdatedEvent, SyncEntitySharedEvent, SyncEntityDeletedEvent — with notification IDs 20000-20002, user preference check, FCM topic subscriptions)
- apps/flutter/lib/core/sync/sync_event_handler.dart (wires showForEvent on every sync WS event, invalidates providers for badge/banner updates)


---
**in-testing -> in-docs** (2026-03-18T09:53:43Z):
## Results
- apps/flutter/test/core/sync/sync_notification_service_test.dart (tests notification service event handling, preference checks, notification display logic)
- apps/flutter/test/core/sync/sync_event_handler_test.dart (tests event handler dispatching to notification service)


---
**in-docs -> in-review** (2026-03-18T09:53:48Z):
## Docs
- docs/desktop-push-notifications.md (documents sync push notifications — SyncNotificationService, event mapping, notification IDs, FCM topic subscriptions, user preferences)


---
**Review (approved)** (2026-03-18T09:53:54Z): Already implemented — SyncNotificationService shows desktop notifications for sync events, wired via SyncEventHandler, tests exist
