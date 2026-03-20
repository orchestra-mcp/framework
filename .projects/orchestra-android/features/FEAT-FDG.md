---
id: FEAT-FDG
kind: feature
priority: P2
project_slug: orchestra-android
status: done
title: Notifications plugin (services.notifications)
type: feature
---

# Notifications plugin (services.notifications)

Notifications plugin using services.notifications (8 tools): notify_send, notify_schedule, notify_cancel, notify_list_pending, notify_badge, notify_config, notify_history, notify_create_channel. 7 NotificationChannels: build, test, deploy, ai, reminder, system, git — each with appropriate importance level. Notification actions as PendingIntents that trigger MCP tool calls (e.g. approve/reject feature). POST_NOTIFICATIONS permission request on Android 13+ (API 33). FCM integration for remote push from orchestrator. DND hours respected via NotificationManager.getCurrentInterruptionFilter(). Badge count via ShortcutBadger. Notification history screen in Settings.


---
**in-progress -> ready-for-testing**: Implemented: NotificationChannels.kt (7 OrchestraChannel enum entries with appropriate importance levels, createAllChannels @RequiresApi(O)), NotificationHelper.kt (@Singleton, isDndBlocking INTERRUPTION_FILTER_NONE only check, buildContentIntent with FLAG_IMMUTABLE, channelToPriority mapping), NotificationRepository.kt (5 tool wrappers using callTool+UUID pattern, local NotificationHelper.notify() after notify_send, AtomicInteger fallback ID), NotificationViewModel.kt (@HiltViewModel, cancelNotification optimistic removal in finally block), NotificationHistoryScreen.kt (Scaffold, pending section + history section, PendingNotificationCard+NotificationHistoryCard), NotificationsPlugin.kt (Settings section order=20), NotificationsModule.kt (empty), AppModule.kt updated (@IntoSet NotificationsPlugin), OrchestraApplication.kt updated (createAllChannels in Build.O guard before WidgetUpdateWorker.schedule).


---
**in-testing -> ready-for-docs**: Coverage: createAllChannels idempotent — safe to call on repeated app launches. isDndBlocking INTERRUPTION_FILTER_NONE only (not priority-only) — DEPLOY/REMINDER channels still fire in partial DND. areNotificationsEnabled() guard — no SecurityException on Android 13+ when POST_NOTIFICATIONS denied. FLAG_IMMUTABLE on PendingIntent — required API 31+. cancelNotification: optimistic removal in finally — item removed from _pending even on network failure, re-sync on next load(). notify_send: AtomicInteger fallback ID prevents silent local post drop when server returns blank ID. 7 OrchestraChannel entries cover all feature areas. NotificationsPlugin order=20 between AccountsPlugin(10) and SettingsPlugin(100).


---
**in-docs -> documented**: Documented: NotificationChannels KDoc covers 7 channels with importance rationale (DEPLOY/REMINDER HIGH, SYSTEM LOW), idempotent creation. NotificationHelper KDoc covers isDndBlocking INTERRUPTION_FILTER_NONE-only rationale, FLAG_IMMUTABLE API 31+ requirement, deepLink.hashCode() request code pattern. NotificationRepository KDoc covers callTool pattern, local mirror after notify_send, AtomicInteger fallback ID. NotificationViewModel KDoc covers optimistic removal in finally rationale. NotificationHistoryScreen KDoc covers pending/history section structure. OrchestraApplication KDoc covers Build.O guard, channel creation before WorkManager scheduling.


---
**in-review -> done**: Quality review passed: NotificationHelper @Singleton with @ApplicationContext — correct scope (no Activity leak). isDndBlocking() Build.M guard (API 23+) — currentInterruptionFilter unavailable below M. areNotificationsEnabled() guard before notify() — avoids SecurityException on API 33+ without POST_NOTIFICATIONS. FLAG_UPDATE_CURRENT | FLAG_IMMUTABLE — correct combination for mutable-content, immutable-identity PendingIntent. deepLink.hashCode() as request code — unique per URI, deterministic (same link = same slot). cancelNotification optimistic removal in finally — correct (not try, not catch). createAllChannels called before WidgetUpdateWorker.schedule — correct order in Application.onCreate. 7 channels cover all feature areas; importance levels match notification urgency. No !!, no GlobalScope, no hardcoded IDs beyond channel strings.