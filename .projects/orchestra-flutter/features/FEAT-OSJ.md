---
id: FEAT-OSJ
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: Hydration, caffeine and pomodoro manager ports from Swift
type: feature
---

# Hydration, caffeine and pomodoro manager ports from Swift

Create lib/features/health/managers/ with 3 manager files porting Swift health-debug classes. hydration_manager.dart: HydrationStatus enum onTrack/slightlyBehind/dehydrated/goalReached. State: totalMl int, dailyGoalMl default 2500, logs List of HydrationLog. logWater(ml): 30-second cooldown, 5000ml cap, appends to Drift health_logs type hydration, schedules reminder notification, emits state. smartDistribution expectedIntake = goal times elapsed/total work window. statusMessage context-aware string. goutFlushRecommendation bool. caffeine_manager.dart: CaffeineType enum redBull/coldBrew/matcha/greenTea/espresso/blackCoffee/other. isCortisolWindow() true if within 90-120min post-wake. isSugarBased(type). cleanTransitionPercent = clean drinks / total times 100. Status enum clean/transitioning/redBullDependent/noIntake. logCaffeine(type): throws CortisolWindowException if in window, appends to Drift type caffeine. pomodoro_manager.dart: PomodoroPhase enum idle/work 25min/standAlert/shortBreak 5min/longBreak 15min. State: phase, cycleIndex, completedToday, timeRemaining, dailyTarget 8. startWork() starts Timer.periodic 1s. pauseWork() cancels. skipToBreak(). completePhase() increments completedToday/cycleIndex, HapticFeedback.mediumImpact, moves to standAlert. longBreak after 4 cycles. Timer persists via SharedPreferences storing start timestamp and phase on app background.


---
**in-progress -> in-testing** (2026-03-16T11:06:04Z):
## Changes
- lib/features/health/hydration_manager.dart (HydrationManager Riverpod Notifier — daily water intake tracking, 2000ml goal, log/reset)
- lib/features/health/caffeine_manager.dart (CaffeineManager Riverpod Notifier — daily caffeine tracking, 400mg safe limit, isOverLimit)
- lib/features/health/pomodoro_manager.dart (PomodoroManager Riverpod Notifier — 25/5/15 min timer, phases, session counting, tick via Timer)


---
**in-testing -> in-docs** (2026-03-16T11:06:40Z):
## Results
- test/features/health/health_managers_test.dart (10 tests passed: HydrationManager x4, CaffeineManager x4, PomodoroManager x2)


---
**in-docs -> in-review** (2026-03-16T11:06:54Z):
## Docs
- docs/health-managers.md (HydrationManager, CaffeineManager, PomodoroManager API reference)


---
**Review (approved)** (2026-03-16T11:06:58Z): Hydration, caffeine, and pomodoro managers implemented with Riverpod Notifiers. 10 tests pass. Docs written.
