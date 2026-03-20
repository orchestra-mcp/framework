---
id: FEAT-XZF
kind: bug
priority: P1
project_slug: orchestra-agents
status: done
title: Fix Vitals tab: replace mock data with real HealthKit data and persist permissions
type: feature
---

# Fix Vitals tab: replace mock data with real HealthKit data and persist permissions

The Vitals tab shows hardcoded mock data (steps=6540, bpm=72, kcal=1840) instead of fetching real data from HealthService. Permission state is not persisted across rebuilds. Fix: wire cards to HealthService API, persist permission state via SharedPreferences, add loading/empty states.


---
**in-progress -> in-testing** (2026-03-18T11:28:34Z):
## Changes

- apps/flutter/lib/screens/health/tabs/vitals_tab.dart (replaced hardcoded mock data with real HealthService API calls; added _loadData() method that fetches steps, heartRate, calories, heartRateRange via Future.wait; persisted permission state via SharedPreferences; updated _StepsCard, _MetricCard, _HeartRateCard to accept real data as params with loading/empty states showing dash when null; removed static const mock values _steps=6540, bpm=72, kcal=1840)
- apps/flutter/lib/core/health/health_service.dart (verified configure() call is correct for health package v13)


---
**in-testing -> in-review** (2026-03-18T11:29:44Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T11:30:18Z): User approved. Vitals tab now uses real HealthKit data with permission persistence and proper null/loading states.
