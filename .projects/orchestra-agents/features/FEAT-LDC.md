---
id: FEAT-LDC
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Add weight, sleep, and live-refresh to Vitals tab
type: feature
---

# Add weight, sleep, and live-refresh to Vitals tab

Expand Vitals tab to fetch and display: weight (from HealthKit, pre-fill Zepp Scale), sleep hours, and add a periodic timer (30s) for live heart rate and energy updates. Currently only steps/HR/calories/HR-range are fetched once on load.


---
**in-progress -> in-testing** (2026-03-18T11:54:15Z):
## Changes

- apps/flutter/lib/core/health/health_service.dart (added getBloodOxygen() and getRespiratoryRate() to abstract interface and HealthServiceImpl; added BLOOD_OXYGEN and RESPIRATORY_RATE to _allTypes for permission requests)
- apps/flutter/lib/screens/health/tabs/vitals_tab.dart (added sleep, weight, blood oxygen, respiratory rate cards; added 30s periodic Timer for live refresh of HR/energy/SpO2/breathing/steps; Zepp Scale weight field pre-fills from HealthKit data; _loadData() fetches all 8 vitals via Future.wait; _loadLiveData() fetches 5 fast-changing metrics silently)


---
**in-testing -> in-docs** (2026-03-18T11:54:27Z):
## Results

- test/screens/health/tabs/vitals_tab_test.dart (6 tests, all passing)
  - shows empty state when no permissions
  - shows all vitals data after permissions granted (steps, HR, calories, sleep, weight, blood O2, breathing — verifies no old mock values)
  - shows dash when data is null
  - persists permission state in SharedPreferences
  - loads from cached permission on restart
  - Zepp Scale weight pre-fills from HealthKit
- test/core/health/health_service_test.dart (10 tests, all passing — no regressions)


---
**in-docs -> in-review** (2026-03-18T11:54:44Z):
## Docs

- docs/vitals-tab-live-data.md (documents all 8 health metrics, live refresh architecture, permission persistence, and file locations)


---
**Review (approved)** (2026-03-18T11:55:10Z): User approved. Vitals tab now shows all 8 health metrics with 30s live refresh for rapidly-changing data.
