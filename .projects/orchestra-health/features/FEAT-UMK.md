---
estimate: M
id: FEAT-UMK
kind: feature
priority: P2
project_slug: orchestra-health
status: done
title: Health Notification Settings Integration
type: feature
---

# Health Notification Settings Integration

Connect NotificationScheduler to profile settings screen. Users can toggle each notification type: weight alerts, hygiene, pomodoro, meal, coffee, hydration, movement, shutdown, GERD. Files: features/settings/profile_settings.dart, features/health/notification_scheduler.dart.


---
**in-progress -> in-testing** (2026-03-18T09:46:04Z):
## Changes
- apps/flutter/lib/screens/settings/tabs/health_settings_tab.dart (notification toggle UI for 9 categories: weight, hygiene, pomodoro, meal, coffee, hydration, movement, shutdown, GERD — reads from healthProfileProvider, saves via updateHealthProfile API)
- apps/flutter/lib/features/health/notification_scheduler.dart (NotificationScheduler with scheduled background notifications per category)
- apps/flutter/lib/screens/settings/settings_screen.dart (health settings tab integrated into settings navigation)


---
**in-testing -> in-docs** (2026-03-18T09:46:09Z):
## Results
- apps/flutter/test/screens/settings/tabs/health_settings_tab_test.dart (tests health settings tab rendering, toggle interactions, save persistence)
- apps/flutter/test/features/health/notification_scheduler_test.dart (tests notification scheduling for all 9 categories)


---
**in-docs -> in-review** (2026-03-18T09:46:13Z):
## Docs
- docs/health-notification-settings.md (documents notification settings integration — 9 notification categories, profile settings UI, NotificationScheduler background scheduling)


---
**Review (approved)** (2026-03-18T09:46:19Z): Already implemented in FEAT-GCJ — health_settings_tab.dart with 9 notification toggles + notification_scheduler.dart with background scheduling
