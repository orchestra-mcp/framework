---
id: FEAT-GCJ
kind: feature
priority: P1
project_slug: orchestra-health
status: done
title: Add health notification settings to profile settings
type: feature
---

# Add health notification settings to profile settings

Add Health Notifications section to Flutter settings screen mirroring health-debug ProfileSettingsView. Include toggles and config for: weight check-in alert (enabled, time, delay), hygiene reminder (enabled, delay), pomodoro start/end alerts (enabled, lead time), heart rate thresholds (high/low bpm), meal logging reminder, coffee time alert (enabled, time), hydration gap alert (enabled, gap minutes), movement alert (enabled, interval), GERD shutdown warning (lead minutes), sleep bedtime and shutdown window. Store via health profile API.


---
**in-progress -> in-testing** (2026-03-17T15:36:13Z):
## Changes
- apps/flutter/lib/screens/settings/tabs/health_settings_tab.dart (new file — 13 health notification settings: weight check-in, hygiene reminder, pomodoro alerts, heart rate thresholds, meal reminder, coffee time, hydration alert, movement alert, GERD warning, bedtime, shutdown window)
- apps/flutter/lib/core/router/app_router.dart (added settingsHealth route constant and GoRoute entry)
- apps/flutter/lib/screens/settings/settings_screen.dart (added import, _titleForRoute, _tabForRoute switch case, mobile menu Health item)
- apps/flutter/lib/screens/shell/desktop_shell.dart (added Health entry to desktop settings sidebar)


---
**in-testing -> in-docs** (2026-03-17T15:38:06Z):
## Results
- apps/flutter/test/screens/settings/tabs/health_settings_tab_test.dart (11 widget tests: loading state, error state with retry, section headers, all 8 toggle labels, heart rate steppers, GERD warning stepper, conditional sub-rows shown/hidden, sleep section, switch count, empty profile defaults)


---
**in-docs -> in-review** (2026-03-17T15:38:30Z):
## Docs
- docs/health-settings.md (health settings tab documentation: route, architecture, all 13 settings with keys and defaults, row widget types, conditional row behavior)


---
**Review (approved)** (2026-03-17T15:38:53Z): User approved. Health settings tab wired into router, settings screen, desktop sidebar, and mobile menu with 11 widget tests.
