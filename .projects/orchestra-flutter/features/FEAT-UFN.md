---
id: FEAT-UFN
kind: feature
priority: P2
project_slug: orchestra-flutter
status: todo
title: Health notifications, home screen widgets, CarPlay and Siri shortcuts
type: feature
---

# Health notifications, home screen widgets, CarPlay and Siri shortcuts

Create lib/features/health/notification_scheduler.dart using flutter_local_notifications. 13 notification categories: weight daily 8am reminder, hygiene 30min after meal, pomodoroStart when work phase begins, pomodoroEnd with sound on completion, sleep 1h before bedtime, heartRate if no reading in 6h, meal reminder if no log in 4h during work window, coffee morning reminder, hydration scheduled by HydrationManager smart distribution, movement if no steps in 2h, shutdown GERD alert 30min before shutdown time, aiTip daily morning, system for app updates. AndroidNotificationDetails per channel, DarwinNotificationDetails for iOS. Create lib/features/health/widget_data_store.dart using home_widget package. updateWidgets() called after every manager state change and on AppLifecycleState.paused. HomeWidget.saveWidgetData for 20+ fields: stepsToday, stepsGoal, energyKcal, heartRateBpm, sleepHours, sleepGoal, hydrationMl, hydrationGoal, pomodoroPhase, pomodoroTimeRemaining, nutritionSafetyPercent, caffeineCount, caffeineCleanPercent, shutdownStatus, shutdownTimeUntil, weightKg, weightTarget, dailyFlowScore, healthScore. iOS: HomeWidget.updateWidget(name OrchestraWidget iOSUrl orchestra://health-widget). Android broadcast. Create lib/features/health/carplay_extension.dart using flutter_carplay: 4 CPListTemplate sections Hydration quick-log plus 250ml button, Pomodoro focus toggle, Caffeine quick-log, Status read-out with daily score. Create lib/features/health/siri_shortcuts.dart using app_shortcuts package: 4 App Intents iOS 16+: log water 250ml calling hydration manager, open meal log sheet, open caffeine log, read health summary via TTS.
