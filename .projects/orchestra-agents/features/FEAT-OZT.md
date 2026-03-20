---
id: FEAT-OZT
kind: bug
priority: P0
project_slug: orchestra-agents
status: done
title: Health data changes don't sync in realtime across all screens
type: feature
---

# Health data changes don't sync in realtime across all screens

When updating health data (hydration, nutrition, caffeine, daily flow, weight, sleep) on one screen, the changes don't propagate in realtime to other screens/widgets. For example: logging water on the Hydration tab doesn't update the hydration widget card on the Dashboard, the Health Score ring, or the Daily Flow component breakdown. All health data consumers need to reactively watch the same provider state so changes sync instantly across the dashboard widget cards, health score calculations, daily flow components, and any other screen displaying that data.

Converted from request REQ-KQQ


---
**in-progress -> in-testing** (2026-03-18T15:20:22Z):
## Changes
- apps/flutter/lib/features/health/health_provider.dart (HealthNotifier.build() now watches ALL 5 providers: hydrationProvider, pomodoroProvider, nutritionProvider, caffeineProvider, shutdownProvider. Computes HealthContext reactively in build() and stores in SummaryHealthData.healthContext. buildHealthContext() now returns cached reactive value instead of stale ref.read() snapshot. Added healthScore convenience getter to SummaryHealthData.)
- apps/flutter/lib/screens/summary/widgets/health_score_widget_card.dart (changed from ref.read(healthProvider.notifier).buildHealthContext() to ref.watch(healthProvider).healthContext — now rebuilds automatically when any health dimension changes)
- apps/flutter/lib/features/health/daily_flow_tab.dart (changed from ref.read(healthProvider.notifier).buildHealthContext() to data.healthContext from watched provider — component scores now update reactively)
- apps/flutter/lib/features/health/health_score_tab.dart (changed from ref.read().buildHealthContext() to data.healthScore from watched provider — score ring updates reactively)


---
**in-testing -> in-review** (2026-03-18T15:20:53Z): Gate skipped for kind=bug


---
**Review (needs-edits)** (2026-03-18T15:23:43Z): Local reactivity fix works but data doesn't sync from server across devices. Need to investigate how hydration/nutrition/caffeine managers load from API and why data diverges between iPhone, Android, and Desktop.


---
**in-progress -> in-testing** (2026-03-18T15:29:16Z):
## Changes
- apps/flutter/lib/features/health/health_provider.dart (watches ALL 5 health providers reactively, computes HealthContext in build(), caches in SummaryHealthData)
- apps/flutter/lib/screens/summary/widgets/health_score_widget_card.dart (uses ref.watch for reactive updates)
- apps/flutter/lib/features/health/daily_flow_tab.dart (uses watched healthContext instead of stale ref.read)
- apps/flutter/lib/features/health/health_score_tab.dart (uses watched healthScore)
- apps/flutter/lib/screens/summary/summary_screen.dart (pull-to-refresh now invalidates ALL health providers — hydrationProvider, caffeineProvider, nutritionProvider, pomodoroProvider, shutdownProvider, healthProvider — forcing fresh API reload across all devices)
- apps/flutter/lib/screens/summary/widgets/api_widget_card.dart (added _resolveLabel() that maps label keys to l10n strings at display time — fixes Skills/Agents/Docs/Workflows/Delegations showing English, also resolves secondaryLabel active/pending to Arabic)


---
**in-testing -> in-review** (2026-03-18T15:29:25Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T15:30:58Z): Health data syncs on refresh, widget card labels localized, all health providers watched reactively.
