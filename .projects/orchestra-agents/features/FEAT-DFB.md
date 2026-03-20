---
id: FEAT-DFB
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Translate Health Score placeholder insights and shutdown violated strings
type: feature
---

# Translate Health Score placeholder insights and shutdown violated strings

Translate hardcoded English strings in:\n1. ai_insight_engine.dart — AiInsights.placeholder() static strings (10 items + trigger analysis)\n2. ai_insight_engine.dart — _buildPlaceholderInsights() dynamic strings with parameters (~12 strings)\n3. shutdown_tab.dart — "Shutdown violated" title and description text


---
**in-progress -> in-testing** (2026-03-18T18:06:47Z):
## Changes
- apps/flutter/lib/l10n/app_en.arb (added 25 new translation keys: 10 static placeholder insight strings, 12 dynamic parameterized insight strings with ICU placeholders, 2 shutdown violated strings, 1 trigger analysis string)
- apps/flutter/lib/l10n/app_ar.arb (added all 25 Arabic translations with proper RTL text)
- apps/flutter/lib/core/health/ai_insight_engine.dart (AiInsights.placeholder() now accepts AppLocalizations; generateInsights() accepts AppLocalizations; _buildPlaceholderInsights() uses parameterized l10n strings for all dynamic content)
- apps/flutter/lib/screens/health/tabs/health_score_tab.dart (pass l10n to AiInsights.placeholder() and generateInsights() calls)
- apps/flutter/lib/screens/health/tabs/shutdown_tab.dart (replaced hardcoded 'Shutdown violated' title and description with l10n.shutdownViolated and l10n.shutdownViolatedDescription)
- apps/flutter/lib/l10n/app_localizations.dart (auto-generated)
- apps/flutter/lib/l10n/app_localizations_en.dart (auto-generated)
- apps/flutter/lib/l10n/app_localizations_ar.dart (auto-generated)


---
**in-testing -> in-docs** (2026-03-18T18:07:15Z):
## Results
- flutter analyze: 0 errors, 0 warnings on all modified source files and generated l10n files
- All 25 new translation keys confirmed present in app_localizations_ar.dart with Arabic text
- Parameterized keys (insightHydrationAtPercent, insightDrinkMoreMl, insightPomodorosCompleted, insightOnlyFocusSessions, insightNutritionSafetyScore, insightNutritionBelowThreshold, insightStartShutdownHours, insightTriggerFoodsDetected) correctly generated with method signatures
- ICU quote escaping verified (You''ve in en.arb)


---
**in-docs -> in-review** (2026-03-18T18:07:39Z):
## Docs
- docs/health-score-translations.md (documents all 25 translation keys, parameterized ICU format, files modified, and note about older features/health/ implementation)


---
**Review (needs-edits)** (2026-03-18T18:10:40Z): Missing "Health Score" title translation at the top of the page.


---
**in-progress -> in-testing** (2026-03-18T18:13:22Z):
## Changes
- apps/flutter/lib/screens/health/health_page_wrapper.dart (changed title:String to titleResolver:Function(AppLocalizations), resolves title from l10n at build time; also flipped back chevron for RTL via RtlUtils.dirIcon)
- apps/flutter/lib/core/router/app_router.dart (all 10 health route builders updated: title:'Health Score' → titleResolver:(l10n)=>l10n.healthScore, etc. for vitals, dailyFlow, hydration, caffeine, nutrition, pomodoro, shutdown, weight, sleep)


---
**in-testing -> in-docs** (2026-03-18T18:13:57Z):
## Results
- flutter analyze: 0 errors on all 5 modified source files
- All 10 health page titles now resolve from AppLocalizations at build time
- HealthPageWrapper back chevron flips for RTL
- Pre-existing info-level lints only (unnecessary_underscores in app_router.dart)


---
**in-docs -> in-review** (2026-03-18T18:14:13Z):
## Docs
- docs/health-score-translations.md (updated with health page titles section documenting HealthPageWrapper titleResolver pattern and RTL chevron flip)


---
**Review (approved)** (2026-03-18T18:14:45Z): All health score page titles, insight strings, and shutdown banner translated to Arabic.
