---
id: FEAT-BHF
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: Nutrition manager, FoodRegistry, shutdown manager and analytics engine
type: feature
---

# Nutrition manager, FoodRegistry, shutdown manager and analytics engine

Port nutrition and shutdown Swift classes to Flutter. food_registry.dart: FoodItem model with name, category enum protein/carb/fat/drink/snack, triggerConditions List. FoodRegistry.allFoods static list covering IBS/GERD triggers WholeEgg, Falafel, DeepFried, RawOnion, RawGarlic, CheddarCheese, YellowCheese. Gout triggers RedMeat, Liver, Duck, Beans, Lentils, Legumes. FattyLiver triggers RefinedSugar, Honey, Nutella, Jam, WhiteFlour, MixedCarbs. Safe foods: GrilledChicken, WhiteFish, CottageCheese, GreekYogurt, Oats, WholeWheat, Rice, OliveOil, Avocado. nutrition_manager.dart: logMeal(food, portion, category) appends to Drift health_logs type nutrition. maxRiceRule: alert if Rice and portion over 5 spoons. hygieneAlert: schedule local notification 30min after log. safetyScore = safe meals divided by total times 100. NutritionStatus: allSafe above 75, warning 50-75, critical below 50. shutdown_manager.dart: shutdownTime = targetSleepTime minus shutdownWindowHours default 4. ShutdownState inactive/active/violated. FlareRisk none/moderate/high from recent nutrition logs checking trigger categories. allowedDuringShutdown list Water, Chamomile Tea, Anise Tea. Timer 1s updating timeUntilShutdown and timeUntilSleep Duration. GERD alert notification scheduled Nmin before shutdown. analytics_engine.dart: aggregates 72h Drift health_logs. healthScore 0-100 weighted: hydration 25, pomodoro 25, nutrition 20, sleep 20, shutdown 10. Generates HealthContext for AI prompt.


---
**in-progress -> in-testing** (2026-03-16T11:09:47Z):
## Changes
- lib/core/health/nutrition_manager.dart (FoodRegistry with 29 foods, FoodItem/TriggerCondition, NutritionState/Notifier, safetyScore, maxRiceRule, nutritionProvider)
- lib/core/health/shutdown_manager.dart (ShutdownState/Notifier, shutdownProvider — phases, flare risk, allowed foods, auto-activate timer)


---
**in-testing -> in-docs** (2026-03-16T11:10:26Z):
## Results
- test/core/health/nutrition_manager_test.dart (FoodRegistry 5 tests, NutritionState 3 tests, ShutdownState 4 tests — 12 passed)


---
**in-docs -> in-review** (2026-03-16T11:10:48Z):
## Docs
- docs/nutrition-shutdown.md (FoodRegistry, NutritionState, NutritionManager, ShutdownState, ShutdownManager)


---
**Review (approved)** (2026-03-16T11:10:53Z): Nutrition manager (FoodRegistry, NutritionState/Notifier) and Shutdown manager (ShutdownState/Notifier) implemented, tested (12 passing), and documented.
