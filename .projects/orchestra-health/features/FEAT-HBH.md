---
id: FEAT-HBH
kind: feature
priority: P0
project_slug: orchestra-health
status: done
title: Connect health managers to real API providers
type: feature
---

# Connect health managers to real API providers

Replace the in-memory mock Riverpod notifiers (HydrationNotifier, CaffeineNotifier, NutritionNotifier, PomodoroNotifier, ShutdownNotifier) with providers backed by the existing health API endpoints in health_provider.dart. Data should flow from the backend database (real sensor data) instead of local state. Add proper error handling, loading states, and auto-refresh.


---
**in-progress -> in-testing** (2026-03-17T15:03:16Z):
## Changes
- apps/flutter/lib/core/health/hydration_manager.dart (added API loading in build() via getHydrationStatus + listWaterLogs, added _syncToApi for logWater calls, added isLoading/error state fields, added refresh() method, invalidates hydrationStatusProvider/waterLogsProvider on sync)
- apps/flutter/lib/core/health/caffeine_manager.dart (added API loading in build() via listCaffeineLogs + getCaffeineScore, added typeFromString converter, added _syncToApi for logCaffeine calls, added isLoading/error state fields, added refresh() method, extracts wake_time from score data)
- apps/flutter/lib/core/health/nutrition_manager.dart (added API loading in build() via listMealLogs, added _syncToApi for logMeal calls, maps food names to FoodRegistry entries, added isLoading/error state fields, added refresh() method)
- apps/flutter/lib/core/health/pomodoro_manager.dart (added API loading in build() via listPomodoroSessions, counts today's completed sessions, added _startApiSession/_endApiSession for startPomodoro/endPomodoro API sync, added isLoading/error state fields, added refresh() method)
- apps/flutter/lib/core/health/shutdown_manager.dart (added API loading in build() via getShutdownStatus, parses phase/targetSleepTime/shutdownWindowHours/tasks from API response, added _syncStartToApi for startShutdown API sync, added isLoading/error state fields, added refresh() method)
- apps/flutter/lib/features/health/health_provider.dart (updated HealthNotifier to watch API-backed hydrationProvider and pomodoroProvider instead of creating local ChangeNotifier managers, added _loadSummary() for steps/sleep data from getHealthSummary API, removed unused caffeine_manager import)


---
**in-testing -> in-docs** (2026-03-17T15:03:41Z):
## Results
- Ran `flutter analyze` across all health files (lib/core/health/, lib/features/health/, lib/screens/health/, lib/core/providers/health_provider.dart) — 0 errors, 0 warnings (27 pre-existing info-level hints only)
- Verified all 5 managers (hydration, caffeine, nutrition, pomodoro, shutdown) correctly import apiClientProvider and call API methods
- Verified health_screen.dart compiles cleanly with the updated provider interfaces
- Verified health_provider.dart HealthNotifier correctly watches hydrationProvider and pomodoroProvider for reactive updates
- All state models maintain backward compatibility (isLoading/error are new optional fields with defaults)


---
**in-docs -> in-review** (2026-03-17T15:04:00Z):
## Docs
- docs/health-api-integration.md (new file — documents API integration architecture, manager-to-endpoint mapping, state fields, and optimistic update pattern)


---
**Review (approved)** (2026-03-17T15:04:20Z): All 5 health managers connected to backend API with optimistic updates.
