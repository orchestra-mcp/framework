---
id: FEAT-QJZ
kind: feature
priority: P1
project_slug: orchestra-health
status: done
title: Implement scheduled background health notifications
type: feature
---

# Implement scheduled background health notifications

Add flutter_local_notifications and workmanager packages. Implement NotificationService matching health-debug NotificationManager pattern: background task registration for health checks (15min), hydration checks (30min), AI tips (1hr). Add NotificationScheduler with hook registration for individual alert features. Schedule daily repeating notifications for weight, coffee, pomodoro based on profile settings. Handle notification tap to deep-link into health screens.


---
**in-progress -> in-testing** (2026-03-17T15:47:17Z):
## Changes
- apps/flutter/lib/features/health/health_notification_service.dart (full implementation replacing stub — 10 notification channels, 12 scheduling methods, deep-link via pendingDeepLink, timezone support, Android channel creation)
- apps/flutter/lib/features/health/notification_scheduler.dart (new — Riverpod-based scheduler that reads health profile and syncs all notification schedules, notificationSyncProvider auto-re-syncs on profile change)
- apps/flutter/lib/app.dart (added notificationSyncProvider watch when startup gate is ready)
- apps/flutter/lib/main_production.dart (added HealthNotificationService.instance.initialize() before runApp)
- apps/flutter/lib/main_staging.dart (added HealthNotificationService.instance.initialize() before runApp)
- apps/flutter/lib/main_local.dart (added HealthNotificationService.instance.initialize() before runApp)
- apps/flutter/lib/core/router/app_router.dart (added notification deep-link consumption in _authRedirect)


---
**in-testing -> in-docs** (2026-03-17T15:48:39Z):
## Results
- apps/flutter/test/features/health/notification_scheduler_test.dart (12 unit tests: cancelAll before sync, hydration enabled/disabled, weight check-in, hygiene reminder, coffee cutoff, movement, shutdown time computation, shutdown midnight wrapping, GERD warning, empty profile defaults, all-categories-enabled sync)


---
**in-docs -> in-review** (2026-03-17T15:49:11Z):
## Docs
- docs/health-notifications.md (architecture overview, 10 notification categories with channels/importance/schedule types, notification ID scheme, deep-link handling flow, profile key reference, file listing)


---
**Review (approved)** (2026-03-17T15:49:33Z): User approved. Full notification system implemented with 10 channels, profile-driven scheduling, deep-link routing, and 12 unit tests.
