# Health Score Translations

> **i18n Audit**: Run `bash scripts/i18n-audit.sh` to compare EN/AR translation files. Reports missing keys and untranslated values across Flutter ARB and Next.js message files.

## Overview

Translated all hardcoded English strings in the Health Score screen and shutdown banner to support Arabic (RTL) locale.

## Files Modified

| File | Changes |
|------|---------|
| `lib/core/health/ai_insight_engine.dart` | `AiInsights.placeholder()` and `_buildPlaceholderInsights()` now accept `AppLocalizations` for localized output |
| `lib/screens/health/tabs/health_score_tab.dart` | Passes `l10n` to placeholder and generateInsights calls |
| `lib/screens/health/tabs/shutdown_tab.dart` | Replaced hardcoded "Shutdown violated" title and description with l10n keys |
| `lib/l10n/app_en.arb` | 25 new keys (10 static, 12 parameterized, 2 shutdown, 1 trigger analysis) |
| `lib/l10n/app_ar.arb` | All 25 Arabic translations |

## Translation Keys Added

### Static Insight Strings
- `insightConsistentHydration`, `insightPomodoroStreaks`, `insightCleanCaffeine`
- `insightCortisolCaffeine`, `insightSleepBelow7h`, `insightShutdownViolatedNights`
- `insightDrinkWaterPomodoro`, `insightMoveCaffeine`, `insightStartShutdownRitual`
- `insightNoTriggersDetected`

### Parameterized Strings (ICU format)
- `insightHydrationAtPercent({percent})`, `insightDrinkMoreMl({ml})`
- `insightPomodorosCompleted({count})`, `insightOnlyFocusSessions({count})`
- `insightNutritionSafetyScore({score})`, `insightNutritionBelowThreshold({score})`
- `insightStartShutdownHours({hours})`, `insightTriggerFoodsDetected({foods})`

### Shutdown Banner
- `shutdownViolated`, `shutdownViolatedDescription`

### Dynamic Context Strings
- `insightDailyHydrationGoalReached`, `insightAimForPomodoros`
- `insightShutdownCompleted`, `insightShutdownViolatedLastNight`
- `insightNoTriggerFoods72h`

## Health Page Titles (via HealthPageWrapper)

All 10 health sub-page titles are now localized via `titleResolver: (l10n) => l10n.xxx`:
- Health Score, Vitals, Daily Flow, Hydration, Caffeine, Nutrition, Pomodoro, Shutdown, Weight, Sleep

The `HealthPageWrapper` changed from `title: String` to `titleResolver: String Function(AppLocalizations)` to resolve at build time. Back chevron also flips for RTL via `RtlUtils.dirIcon`.

## Note

The older `lib/features/health/ai_insight_engine.dart` has its own set of hardcoded strings from a previous implementation. Those are not modified in this change. The `health_screen.dart` hub card titles and `summary_screen.dart` dashboard labels are also still hardcoded (top-level data without BuildContext access — requires a different approach).
