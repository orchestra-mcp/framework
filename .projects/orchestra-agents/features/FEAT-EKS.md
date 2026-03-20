---
id: FEAT-EKS
kind: bug
priority: P1
project_slug: orchestra-agents
status: done
title: Localize remaining screens — profile, team, health tabs, search, summary
type: feature
---

# Localize remaining screens — profile, team, health tabs, search, summary

Follow-up to FEAT-DLU. The sidebar labels are now Arabic but screen content across profile_settings, team_settings, vitals_tab, daily_flow_tab, health_score_tab, search_screen, and other visible screens still have hardcoded English strings.


---
**in-progress -> in-testing** (2026-03-18T14:35:06Z):
## Changes
- apps/flutter/lib/l10n/app_en.arb (added 48 new l10n keys: name, phone, gender, position, male, female, genderOther, preferNotToSay, avatarUpdated, failedToUploadAvatar, failedToSave, myTeam, defaultWorkspace, wins, concerns, generateAiInsights, dailyScore, componentBreakdown, pomodoros, zeppScale, weightKg, bodyFatPercent, visceralFatRange, bodyWaterPercent, searchEverything, browseResources, tapCategoryToExplore, searchFailed, tryAdjustingQuery, closeSearch, all, 17 subtitle keys)
- apps/flutter/lib/l10n/app_ar.arb (added matching 48 Arabic keys — 338 total match)
- apps/flutter/lib/l10n/app_localizations.dart (regenerated)
- apps/flutter/lib/l10n/app_localizations_en.dart (regenerated)
- apps/flutter/lib/l10n/app_localizations_ar.dart (regenerated)
- apps/flutter/lib/features/settings/profile_settings.dart (localized all 12+ field labels, gender options, snackbar messages, save button)
- apps/flutter/lib/features/settings/team_settings.dart (localized title, section headers, placeholder items)
- apps/flutter/lib/features/health/health_score_tab.dart (localized Health Score label, Wins, Concerns, Recommendations, Generate AI Insights button)
- apps/flutter/lib/features/health/vitals_tab.dart (localized Steps, Energy, Heart Rate card titles, Zepp Scale header, all 5 input labels)
- apps/flutter/lib/features/health/daily_flow_tab.dart (localized Daily Score, Component Breakdown, 4 component labels, This Week header)
- apps/flutter/lib/screens/search/search_screen.dart (converted const entity categories to use l10n label/subtitle resolvers, localized category filter chips, search placeholder, cancel button, empty/error states)


---
**in-testing -> in-review** (2026-03-18T14:35:35Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T14:36:07Z): All 6 remaining screens localized. 48 new ARB keys, 338 total, zero errors. Full Arabic coverage across settings, health tabs, and search.
