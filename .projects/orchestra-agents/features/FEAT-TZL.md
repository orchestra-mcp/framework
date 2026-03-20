---
id: FEAT-TZL
kind: bug
priority: P1
project_slug: orchestra-agents
status: done
title: Sleep tab not showing real HealthKit sleep data
type: feature
---

# Sleep tab not showing real HealthKit sleep data

The sleep tab still shows mock/empty data instead of real HealthKit sleep data. Needs the same treatment as the Vitals tab — wire to HealthService.getSleepHours().

Converted from request REQ-JLU


---
**in-progress -> in-testing** (2026-03-18T12:08:35Z):
## Changes

- apps/flutter/lib/screens/health/tabs/sleep_tab.dart (converted SleepTab from ConsumerWidget to ConsumerStatefulWidget; added _loadHealthKitSleep() that reads cached permission from SharedPreferences and fetches getSleepHours() from HealthService; added _HealthKitSleepCard widget showing last night's sleep hours with progress bar, color-coded label, and target; wrapped ListView in RefreshIndicator for pull-to-refresh; shows 'No sleep data recorded' when HealthKit returns null)


---
**in-testing -> in-review** (2026-03-18T12:08:55Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T12:09:29Z): User approved. Sleep tab now shows HealthKit sleep data with manual logging below.
