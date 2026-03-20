---
id: FEAT-MOR
kind: feature
priority: P1
project_slug: orchestra-flutter
status: todo
title: Hydration, Caffeine and Nutrition health tabs with manager bindings
type: feature
---

# Hydration, Caffeine and Nutrition health tabs with manager bindings

Create 3 health tab screens. hydration_tab.dart: circular progress ring CustomPainter consumed/goal fraction, ring color green onTrack / yellow slightlyBehind / red dehydrated / blue goalReached. Status badge rounded Container with status text. Quick-log 3 GlassButton pills plus 150ml, plus 250ml, plus 500ml calling HydrationManager.logWater(). Cooldown: buttons disabled with remaining seconds shown. Log history last 5 entries. Gout flush recommendation Banner when manager.goutFlushRecommendation is true. caffeine_tab.dart: CaffeineType horizontal scroll row of glass pill buttons each with emoji and name, tap calls logCaffeine or shows CortisolWindowException Banner. Cortisol window Banner orange with time until window ends when isCortisolWindow. Clean transition percent ring with status label. Today log ListView type icon and timestamp. Sugar alert Banner conditional. nutrition_tab.dart: safety score ring percent. Status banner allSafe green / warning orange / critical red. Meal log ListView: food name, category icon, safe checkmark or trigger warning badges per TriggerCondition. Add meal FAB opens food picker GlassSheet with search TextField and category filter chips and FoodRegistry grouped list tapping each calls logMeal. Max rice alert Banner. Hygiene local notification scheduled on meal log. All tabs use ref.watch(healthProvider) and react to manager state changes with Riverpod rebuild.
