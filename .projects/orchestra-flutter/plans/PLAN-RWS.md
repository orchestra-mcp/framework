---
id: PLAN-RWS
project_slug: orchestra-flutter
status: approved
title: Plan 4: Health Screen (Full health-debug Parity)
type: plan
---

# Plan 4: Health Screen (Full health-debug Parity)

## Overview
Complete port of the health-debug iOS app to Flutter. This is the most complex plan — it ports 6 Swift manager classes, an analytics engine, an AI insight engine, 10 health tabs, HealthKit + Health Connect integration, 13 notification categories, home screen widgets, CarPlay/Android Auto, and Siri Shortcuts. Must exactly match behavior of `~/Sites/health-debug`.

## Scope

### 1. HealthKit / Health Connect Service (`lib/features/health/health_kit_service.dart`)
- Uses `health` Flutter package (v12.2.0)
- iOS/macOS: reads Apple HealthKit
- Android: reads Google Health Connect
- Quantities read: STEPS, ACTIVE_ENERGY_BURNED, HEART_RATE, BODY_MASS, BODY_FAT_PERCENTAGE
- Category: SLEEP_ASLEEP (filter to asleepCore + asleepDeep + asleepREM + asleepUnspecified only)
- Permission request flow: requestAuthorization() on first health tab open
- Methods: getTodaySteps(), getTodayEnergy(), getLatestHeartRate(), getLatestWeight(), getSleepHours(date)
- Fallback: if HealthKit unavailable (Android <14 or web) → returns null, UI shows "Not available"

### 2. Health Managers (ports of Swift classes)

**`hydration_manager.dart`** (port of HydrationManager.swift):
- State: totalMl (int), dailyGoalMl (int, default 2500), logs: List<HydrationLog>
- HydrationStatus enum: onTrack / slightlyBehind (≤250ml deficit) / dehydrated (>500ml deficit) / goalReached
- logWater(int ml): adds log, 30-sec cooldown enforced, 5000ml safety cap
- Smart distribution: expectedIntake = goal × (elapsed work window / total work window)
- statusMessage: context-aware text ("On Track +150ml cushion", "Dehydrated! Drink now")
- goutFlushRecommendation: bool — true when behind target
- Persists logs to Drift health_logs_table (type: 'hydration')
- Notification: schedules next reminder for next expected intake time

**`caffeine_manager.dart`** (port of CaffeineManager.swift):
- CaffeineType enum: redBull / coldBrew / matcha / greenTea / espresso / blackCoffee / other
- State: logs: List<CaffeineLog>, cleanTransitionPercent: double
- Cortisol window block: 90–120 min post-wake → cannot log during this window (shows warning)
- Status: clean / transitioning / redBullDependent / noIntake
- cleanPercent = (clean drinks count / total) × 100
- Sugar alert: if sugarBased drink logged → liver health warning banner
- logCaffeine(type): appends log, enforces cortisol block
- Persists to Drift health_logs_table (type: 'caffeine')

**`nutrition_manager.dart`** + **`food_registry.dart`** (ports of NutritionManager.swift + FoodRegistry.swift):
- FoodCategory enum: protein / carb / fat / drink / snack
- FoodRegistry: named food items with category + triggerConditions
  - IBS/GERD triggers: WholeEgg, Falafel, DeepFried, RawOnion, RawGarlic, CheddarCheese, YellowCheese
  - Gout triggers: RedMeat, Liver, Duck, Beans, Lentils, Legumes
  - FattyLiver triggers: RefinedSugar, Honey, Nutella, Jam, WhiteFlour, MixedCarbs
  - Safe: GrilledChicken, WhiteFish, CottageCheese, GreekYogurt, Oats, WholeWheat, Rice, OliveOil, Avocado
- NutritionStatus: allSafe / warning (>25% unsafe meals) / critical (>50% unsafe)
- safetyScore = (safe meals / total meals) × 100
- maxRiceRule: alert if rice portion > 5 spoons in a meal
- hygieneAlert: triggered after every meal log (30-min reminder)
- logMeal(food, portion, category): appends to Drift health_logs_table (type: 'nutrition')

**`pomodoro_manager.dart`** (port of PomodoroManager.swift):
- PomodoroPhase enum: idle / work(25min) / standAlert / shortBreak(5min) / longBreak(15min)
- longBreak triggered after 4 completed work sessions
- State: phase, cycleIndex, completedToday, timeRemaining, dailyTarget (8)
- startWork(), pauseWork(), skipToBreak(), completePhase()
- standAlert: after work phase ends → user chooses "Continue Working" or "Take Break"
- Sound + haptic on phase transitions (HapticFeedback.mediumImpact)
- Timer persists across app backgrounding (stores start time + phase in SharedPreferences)

**`shutdown_manager.dart`** (port of ShutdownManager.swift):
- shutdownTime = targetSleepTime − shutdownWindowHours (default 4 hrs)
- ShutdownState: inactive / active / violated
- FlareRisk: none / moderate / high
- flareRisk detection: spicy, fried, dairy, chocolate, citrus, tomato, coffee, soda, alcohol, mint
- Allowed during shutdown: Water / Chamomile Tea / Anise Tea ONLY
- 1-second countdown: shows "Xh Ym to shutdown" + "Xh Ym to sleep"
- GERD alert scheduled N minutes before shutdown cutoff
- Logs violations to Drift health_logs_table (type: 'shutdown_violation')

### 3. Analytics & AI Engines

**`analytics_engine.dart`** (port of AnalyticsEngine.swift):
- 72-hour context window
- Aggregates: totalHydration, caffeineCount, mealCount, pomodoroCompleted, shutdownCompliance (bool), sleepHours
- Generates HealthContext struct for AI prompt
- score: 0–100 derived from weighted components (hydration 25%, pomodoro 25%, nutrition 20%, sleep 20%, shutdown 10%)

**`ai_insight_engine.dart`** (port of AIInsightEngine.swift):
- Uses SmartActionService (Foundation Models on iOS/macOS, tunnel bridge on all platforms)
- Generates: top3Wins (List<String>), top3Concerns (List<String>), recommendations (List<String>)
- Trigger analysis: GERD flare impact score
- 5-minute cooldown per domain refresh (stored in SharedPreferences)
- Streaming support: shows insights as they stream in

### 4. 10-Tab Health Screen (`lib/features/health/`)

**`health_screen.dart`** — Sub-tab navigator with horizontal scrollable tab bar:
- Tabs: Health Score | Vitals | Daily Flow | Hydration | Caffeine | Nutrition | Pomodoro | Shutdown | Weight | Sleep

**`health_score_tab.dart`**:
- Large score ring (0–100, colored: <40 red, 40-70 orange, >70 green)
- AI-generated: 3 Win chips (green), 3 Concern chips (orange)
- Recommendations list (expandable GlassCard)
- Trigger analysis section (GERD flare risk bar)
- Refresh button (respects 5-min cooldown, shows remaining time if cooling down)
- Empty state: "Analyzing 72hr data..." shimmer

**`vitals_tab.dart`**:
- Steps card: today count + progress bar vs 10,000 goal + sparkline chart (7 days)
- Active Energy card: kcal + trend arrow
- Heart Rate card: latest bpm + min/max today
- Zepp Scale section (manual input if Zepp not available):
  - Weight (kg), Body Fat %, Metabolic Age, Visceral Fat level (1–12), Body Water %
  - Each vs target values (shown in muted secondary text)
  - Metabolic age target: <35, color coded

**`daily_flow_tab.dart`**:
- Daily score (0–100) aggregated from: completed pomodoros ÷ 8 target (40%), hydration goal % (25%), nutrition safety % (20%), shutdown compliance (15%)
- Week view: 7 day bar chart of daily scores
- Today breakdown: component scores listed with colored bars

**`hydration_tab.dart`**:
- Large circular progress ring: consumed ml / daily goal (e.g. 1850 / 2500ml)
- Status badge (color-coded: green=onTrack, yellow=slightlyBehind, red=dehydrated, blue=goalReached)
- Status message text (contextual)
- Quick-log buttons: +150ml / +250ml / +500ml (glass pill buttons)
- Log history: last 5 logs with timestamp
- Gout flush recommendation banner (conditional)
- 30-sec cooldown: buttons disabled + countdown shown

**`caffeine_tab.dart`**:
- CaffeineType picker: horizontal scroll row of glass pill buttons
- Cortisol window banner: "Cortisol Window Active — No caffeine until HH:MM" (orange warning)
- Clean transition %: ring with percentage + status label
- Today's log: type icons + timestamps
- Sugar alert banner (if sugar-based drink logged)

**`nutrition_tab.dart`**:
- Safety score ring (safetyScore %)
- Status banner: allSafe (green) / warning (orange) / critical (red)
- Meal log list: food name + category icon + safe/trigger badge
- Add meal button → food picker sheet (FoodRegistry list with search, grouped by category)
- Max rice rule alert banner (conditional)
- Hygiene alert modal (30-min after meal)

**`pomodoro_tab.dart`**:
- Large phase timer: circular ring countdown, phase label, time remaining
- Phase indicator: work → standAlert → shortBreak/longBreak cycle
- Control buttons: Start / Pause / Skip Phase
- Progress: X of 8 sessions today
- Session dots: 8 circles, filled for completed
- Stand alert state: overlay with "Continue" / "Take Break" choice

**`shutdown_tab.dart`**:
- Status: inactive (gray) / active (orange countdown) / violated (red)
- Countdown: "3h 24m to shutdown" + "7h 24m to sleep"
- Flare risk: none (green) / moderate (yellow) / high (red) — with matched items listed
- Allowed foods banner (shows Water/Chamomile/Anise when active)
- Violation log: last 3 violations with timestamps

**`weight_tab.dart`**:
- Latest weight: large number (kg) + trend arrow (vs yesterday)
- Target line: 90kg reference
- 30-day trend chart: line chart with target line overlay
- Log weight button → number input + confirm
- Zepp scale metrics row: Body Fat, Visceral Fat, Body Water

**`sleep_tab.dart`**:
- Sleep hours: large number + duration bar (colored green/>7h, yellow/6–7h, red/<6h)
- Bedtime target vs actual (from HealthKit last SLEEP_ASLEEP window)
- Sleep goal: 7.5 hours (configurable in health settings)
- 7-day trend chart

### 5. Health Provider (`lib/features/health/health_provider.dart`)
- Riverpod: holds all 5 managers + analytics engine + AI engine
- Exposes derived state: SummaryHealthData (for health_summary_card in Plan 3)

### 6. Notification Scheduler (`lib/features/health/notification_scheduler.dart`)
13 notification categories (mirrors NotificationItem in health-debug):
- weight, hygiene, pomodoroStart, pomodoroEnd, sleep, heartRate, meal, coffee, hydration, movement, shutdown, aiTip, system
- Uses `flutter_local_notifications` package
- Schedules: hydration reminder, GERD shutdown alert, sleep reminder, pomodoro end sound

### 7. Home Screen Widget Data (`lib/features/health/widget_data_store.dart`)
- Uses `home_widget` package
- Pushes 20+ fields: steps/goal, energy, heart rate, sleep, hydration ml/goal, pomodoro status, nutrition safety %, caffeine counts, shutdown status, weight, daily flow score
- Called on every manager state change + app background event
- iOS: updates WidgetKit timeline, Android: sends broadcast

### 8. CarPlay + Android Auto (`lib/features/health/carplay_extension.dart`)
- Uses `flutter_carplay` package
- 4 CPListTemplate sections (mirrors health-debug CarPlay):
  1. Hydration: status + quick-log (+250ml button)
  2. Pomodoro: focus status + toggle
  3. Caffeine: last logged + quick-log
  4. Status: daily score read-out
- Android Auto: `AndroidAutoExtension` equivalent via flutter_carplay

### 9. Siri Shortcuts / App Intents (`lib/features/health/siri_shortcuts.dart`)
Port of HealthIntents.swift — 4 App Intents (iOS 16+):
1. "Log water" → logWater(250ml) via HydrationManager
2. "I ate something" → opens meal log sheet
3. "I had coffee" → opens caffeine quick-log
4. "Health summary" → triggers AI insight engine + reads aloud via TTS

## Dependencies
- Plans 1+3: Drift health_logs_table, theme system, glass components, SyncEngine
- Plan 5: SmartActionService (for AI Insight Engine calls)

## Verification Criteria
1. iOS: HealthKit permissions requested on first health tab open
2. Android: Health Connect permissions requested correctly
3. Hydration: +250ml log appears in ring within 100ms, 30-sec cooldown enforced
4. Caffeine: cortisol window blocks log during wake+90min period
5. Nutrition: IBS/GERD trigger foods flagged red in meal log
6. Pomodoro: 25-min timer counts down, sound plays on completion, longBreak after 4 cycles
7. Shutdown: countdown updates every second, flare risk computed from recent nutrition logs
8. Health score: AI insights generated within 30s, 5-min cooldown enforced
9. Weight: log persists across app restart (Drift)
10. Home widget: iOS home screen widget updates within 5s of logging
11. Siri: "Log water" shortcut increments hydration by 250ml
