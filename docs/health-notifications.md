# Health Notifications System

Scheduled local notifications for health tracking, driven by the user's health profile settings.

## Architecture

```
main_*.dart → HealthNotificationService.initialize()
                     ↓
app.dart → notificationSyncProvider (watches healthProfileProvider)
                     ↓
NotificationScheduler.syncFromProfile(profile)
                     ↓
HealthNotificationService.*  (schedule/cancel per category)
```

- **HealthNotificationService** — singleton wrapping `flutter_local_notifications`. Manages 10 Android notification channels, scheduling, and deep-link payload storage.
- **NotificationScheduler** — stateless class that reads a profile map and calls the appropriate service methods. Cancels all before re-scheduling.
- **notificationSyncProvider** — Riverpod `FutureProvider<void>` that auto-re-syncs whenever `healthProfileProvider` emits a new value.

## Notification Categories

| Category | Channel ID | Importance | Schedule Type | Deep Link |
|----------|-----------|------------|---------------|-----------|
| Hydration | `health_hydration` | High | Periodic (gap minutes) | `/health/hydration` |
| Pomodoro | `health_pomodoro` | High | One-shot (from PomodoroManager) | `/health/pomodoro` |
| Shutdown | `health_shutdown` | Default | Daily (bedtime - window hours) | `/health/shutdown` |
| Weight | `health_weight` | Default | Daily (configured time) | `/health/weight` |
| Meal | `health_meal` | Default | Contextual (flag-based) | `/health/nutrition` |
| Coffee | `health_coffee` | Default | Daily (cutoff time) | `/health/caffeine` |
| Movement | `health_movement` | Default | Periodic (interval minutes) | `/health/movement` |
| Heart Rate | `health_heart` | Max | Immediate (threshold breach) | `/health/heart` |
| Hygiene | `health_hygiene` | Low | One-shot (delay days) | `/health/hygiene` |
| GERD | `health_gerd` | High | Daily (shutdown - lead minutes) | `/health/gerd` |

## Notification ID Scheme

Fixed IDs per type for individual cancel support:

| Type | ID |
|------|----|
| Hydration | 1000 |
| Pomodoro Break / Start | 2000 / 2001 |
| Shutdown Lead / Main | 3000 / 3001 |
| Weight | 4000 |
| Meal | 5000 |
| Coffee | 6000 |
| Movement | 7000 |
| Heart High / Low | 8000 / 8001 |
| Hygiene | 9000 |
| GERD | 10000 |

## Deep-Link Handling

1. Each notification carries a `payload` string (the route path)
2. On tap, `onDidReceiveNotificationResponse` stores it in `HealthNotificationService.pendingDeepLink`
3. The router's `_authRedirect` consumes it when the user lands on the login→summary redirect

## Profile Keys

All keys are documented in [docs/health-settings.md](health-settings.md).

## Files

| File | Purpose |
|------|---------|
| `lib/features/health/health_notification_service.dart` | Notification plugin wrapper |
| `lib/features/health/notification_scheduler.dart` | Profile → schedule bridge |
| `lib/app.dart` | Watches `notificationSyncProvider` |
| `lib/main_*.dart` | Calls `initialize()` at startup |
| `lib/core/router/app_router.dart` | Consumes `pendingDeepLink` |
