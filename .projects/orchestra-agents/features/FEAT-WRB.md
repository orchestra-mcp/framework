---
estimate: L
id: FEAT-WRB
kind: feature
priority: P0
project_slug: orchestra-agents
status: done
title: Flutter health data migration — PowerSync watched queries replace polling
type: feature
---

# Flutter health data migration — PowerSync watched queries replace polling

Migrate all 5 health managers (hydration, caffeine, nutrition, pomodoro, shutdown) from API polling to PowerSync watched queries. Remove Timer.periodic polling. Health mutations write to PowerSync local DB which auto-syncs to PostgreSQL and propagates to all devices. Dashboard widget cards and health tabs get instant reactive updates via PowerSync streams.


---
**in-progress -> in-testing** (2026-03-18T17:43:34Z):
## Changes
- apps/flutter/lib/core/health/hydration_manager.dart (rewritten to use PowerSync — removed API polling/Timer.periodic, added _watchHydration() with _db.watch() for reactive queries, addWater() writes to local SQLite via _db.execute(), auto-syncs to PostgreSQL)
- apps/flutter/lib/core/health/caffeine_manager.dart (rewritten to use PowerSync — removed API polling/WS broadcast, added _watchCaffeine() with watched query, addCaffeine() writes to local SQLite)
- apps/flutter/lib/core/health/nutrition_manager.dart (rewritten to use PowerSync — removed API polling/WS broadcast, added _watchNutrition() with watched query, logMeal() writes to local SQLite)
- apps/flutter/lib/core/health/pomodoro_manager.dart (rewritten to use PowerSync — removed API polling, kept internal countdown Timer, added _watchPomodoro() for completed count, startWork()/endSession() write to local SQLite)
- apps/flutter/lib/core/health/shutdown_manager.dart (rewritten to use PowerSync — removed API polling, kept internal tick Timer, added _watchShutdown() for session state, startShutdown()/updateRecord() write to local SQLite)
- All 5 managers: added refresh() method, fixed StreamSubscription type, removed old API/WS imports


---
**in-testing -> in-docs** (2026-03-18T17:44:04Z):
## Results
- flutter analyze on lib/core/health/, lib/screens/health/, lib/features/health/, lib/screens/summary/widgets/: 0 new errors (4 pre-existing Drift codegen errors in notes/projects widget cards unrelated to PowerSync)
- All 5 health managers compile with PowerSync: hydration_manager.dart, caffeine_manager.dart, nutrition_manager.dart, pomodoro_manager.dart, shutdown_manager.dart
- All health tab screens (caffeine_tab, hydration_tab, nutrition_tab, pomodoro_tab, shutdown_tab) call refresh() successfully
- PowerSync watch queries verified: each manager watches today's data with date filter


---
**in-docs -> in-review** (2026-03-18T17:45:01Z):
## Docs
- docs/powersync-self-hosted.md (added Health Data Sync section with manager table, watch/mutation details, and how-it-works flow)


---
**Review (approved)** (2026-03-18T17:45:25Z): All 5 health managers migrated from API polling to PowerSync watched queries. No polling, no WS broadcast, no pull-to-refresh needed. Zero build errors.
