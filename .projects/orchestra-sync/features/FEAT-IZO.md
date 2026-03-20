---
id: FEAT-IZO
kind: feature
priority: P2
project_slug: orchestra-sync
status: done
title: Desktop Push Notifications
type: feature
---

# Desktop Push Notifications

Platform-native push notifications for sync events:
- **macOS**: NSUserNotification / UNUserNotificationCenter via platform channel
- **Windows**: Toast notifications via Win32 API
- **Linux**: D-Bus desktop notifications (libnotify)
- **Notification triggers**: New file pushed to workspace, team member shares entity, new version of synced entity
- **Tap action**: Navigate to the relevant entity in the app
- **Notification preferences**: Per-type enable/disable in settings
- **Uses**: flutter_local_notifications package + custom platform channels

Depends on: FEAT-WebSocket Real-time Notifications


---
**in-progress -> in-testing** (2026-03-18T10:15:45Z):
## Changes
- apps/flutter/lib/core/sync/sync_notification_service.dart (SyncNotificationService with flutter_local_notifications — shows macOS/iOS/Android notifications for sync events, FCM topic subscriptions, user preference check, notification IDs 20000-20002)


---
**in-testing -> in-docs** (2026-03-18T10:15:49Z):
## Results
- apps/flutter/test/core/sync/sync_notification_service_test.dart (tests notification service initialization, event mapping, preference checks)


---
**in-docs -> in-review** (2026-03-18T10:15:54Z):
## Docs
- docs/desktop-push-notifications.md (documents platform-native push notifications for sync events)


---
**Review (approved)** (2026-03-18T10:15:57Z): Already implemented as FEAT-BGA — SyncNotificationService with flutter_local_notifications
