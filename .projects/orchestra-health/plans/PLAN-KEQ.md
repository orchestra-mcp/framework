---
id: PLAN-KEQ
project_slug: orchestra-health
status: in-progress
title: Health System Integration — Desktop Sidebar, Real Data, UX Redesign, Notifications
type: plan
---

# Health System Integration — Desktop Sidebar, Real Data, UX Redesign, Notifications

Port the health-debug system into the Orchestra Flutter app with these goals:

1. **Desktop Sidebar Integration** — Add Health as a first-class icon rail entry with a full sidebar listing all health sections (Score, Vitals, Flow, Hydration, Caffeine, Nutrition, Pomodoro, Shutdown, Weight, Sleep)

2. **Replace Mock Data with Real API Data** — The current health managers (hydration, caffeine, nutrition, pomodoro, shutdown) use local Riverpod state with no persistence. Connect them to the existing health API providers (health_provider.dart) that call the backend API for real-time data from health sensors/database.

3. **Health Detail Pages UX Redesign** — Upgrade the 10 health detail tab pages with better UX: proper data visualization, progress indicators, history charts, and actionable insights matching the health-debug iOS app quality.

4. **Health Notification Settings in Profile** — Add notification settings section to the Flutter settings screen mirroring the health-debug ProfileSettingsView: weight alerts, hygiene reminders, pomodoro alerts, heart rate thresholds, meal reminders, coffee time, hydration alerts, movement alerts, GERD warnings, sleep/shutdown config.

5. **Background Notification Scheduling** — Implement scheduled background notifications for health events using flutter_local_notifications and workmanager packages, matching the health-debug NotificationManager/NotificationScheduler pattern.

6. **Bug Fix: Health sidebar not accessible** — Health exists in _SidebarType enum and has a _HealthSidebar class but is not in _railDestinations. Fix this.
