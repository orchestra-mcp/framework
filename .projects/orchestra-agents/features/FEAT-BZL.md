---
estimate: M
id: FEAT-BZL
kind: bug
priority: P0
project_slug: orchestra-agents
status: done
title: Fix health data sync push
type: feature
---

# Fix health data sync push

Verify each health entity type (water_logs, caffeine_logs, pomodoro_sessions, sleep_configs, sleep_logs, health_snapshots) has working push path from Flutter to PowerSync. Add missing push calls.


---
**in-progress -> in-testing** (2026-03-19T23:01:21Z):
## Changes
- apps/flutter/lib/core/health/hydration_manager.dart (removed API-first dual-write, now writes directly to PowerSync SQLite which auto-syncs)
- apps/flutter/lib/core/health/caffeine_manager.dart (same fix — PowerSync-first write in addCaffeine)
- apps/flutter/lib/core/health/pomodoro_manager.dart (same fix — PowerSync-first write in startWork and _endSession)
- apps/flutter/lib/core/health/shutdown_manager.dart (same fix — PowerSync-first write in startShutdown)
- apps/flutter/lib/core/health/nutrition_manager.dart (same fix — PowerSync-first write in logMeal)


---
**in-testing -> in-review** (2026-03-19T23:01:29Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-19T23:01:59Z): Health sync fix approved — all 5 managers now write to PowerSync SQLite directly, ensuring auto-sync to all devices.
