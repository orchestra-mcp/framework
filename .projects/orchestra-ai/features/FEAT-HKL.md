---
id: FEAT-HKL
kind: feature
priority: P2
project_slug: orchestra-ai
status: done
title: Desktop Push Notifications for Sync Events
type: feature
---

# Desktop Push Notifications for Sync Events

Desktop push notifications when team members push changes:
- flutter_local_notifications integration for macOS/iOS/Android
- Notification on entity_shared and entity_updated events from WebSocket
- Notification content: author name, entity title, change summary
- Notification tap opens the relevant entity detail screen
- Settings toggle to enable/disable sync notifications


---
**in-progress -> in-testing** (2026-03-17T16:21:23Z):
## Changes
- apps/flutter/lib/core/sync/sync_notification_service.dart (new file — SyncNotificationService with flutter_local_notifications for desktop/mobile push, FCM topic subscriptions for background delivery, preference-aware enable/disable)
- apps/flutter/lib/core/sync/sync_event_handler.dart (wired syncNotificationServiceProvider into _onEvent to fire push notifications on every sync event)
- apps/flutter/lib/screens/settings/tabs/notifications_settings_tab.dart (added 'sync' toggle to notification settings with sync_rounded icon, updated _extractNotifications to include sync key with default-on)


---
**in-testing -> in-docs** (2026-03-17T16:23:10Z):
## Results
- apps/flutter/test/core/sync/sync_notification_service_test.dart (18 tests, all passing)
  - Event mapping: updated/shared/deleted notification title/body generation, non-sync event exclusion
  - Preference extraction: sync key default-on, explicit true/false, fallback with notification_ prefix
  - FCM topic naming: _sync suffix, uniqueness across teams
  - Notification ID allocation: unique IDs, no overlap with health IDs (20000+ vs 1000-10000)
  - Deep link payload: entity type routes for all event types


---
**in-docs -> in-review** (2026-03-17T16:23:39Z):
## Docs
- docs/desktop-push-notifications.md (new — architecture with dual-channel delivery, event-to-notification mapping table, FCM topic naming, notification ID allocation, settings toggle, platform support matrix)


---
**Review (approved)** (2026-03-17T16:24:05Z): Approved. Dual-channel push (local + FCM) with settings toggle.
