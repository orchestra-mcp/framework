---
id: FEAT-NGQ
kind: bug
priority: P1
project_slug: orchestra-agents
status: done
title: Weight tab: show HealthKit weight data with manual entry fallback
type: feature
---

# Weight tab: show HealthKit weight data with manual entry fallback

Weight tab should fetch weight from HealthKit and display it. If health data is not connected, user can enter weight manually. Same pattern as Vitals tab.

Converted from request REQ-OAW


---
**in-progress -> in-testing** (2026-03-18T12:10:57Z):
## Changes

- apps/flutter/lib/screens/health/tabs/weight_tab.dart (added HealthKit weight and body fat fetching via _loadHealthKitData(); added _HealthKitWeightCard showing latest weight from HealthKit with body fat badge; shows 'Health Not Connected' message with manual entry fallback when permissions not granted; shows 'No weight data in HealthKit' when connected but no data; pull-to-refresh reloads both HealthKit and manual data)


---
**in-testing -> in-review** (2026-03-18T12:11:16Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T12:11:54Z): User approved. Weight tab now shows HealthKit weight + body fat with manual entry fallback.
