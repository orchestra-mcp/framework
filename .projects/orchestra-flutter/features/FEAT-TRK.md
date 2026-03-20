---
estimate: M
id: FEAT-TRK
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: HealthKit and Health Connect unified service
type: feature
---

# HealthKit and Health Connect unified service

Create lib/features/health/health_kit_service.dart using the health Flutter package v12.2.0. requestAuthorization() requesting HealthDataType.STEPS, ACTIVE_ENERGY_BURNED, HEART_RATE, BODY_MASS, BODY_FAT_PERCENTAGE, SLEEP_ASLEEP. Called when health tab first opened. getTodaySteps() reads STEPS from midnight today to now returning int. getTodayEnergy() reads ACTIVE_ENERGY_BURNED today returning double kcal. getLatestHeartRate() reads latest HEART_RATE sample returning int bpm. getLatestWeight() reads latest BODY_MASS returning double kg. getBodyFat() reads latest BODY_FAT_PERCENTAGE returning double percent. getSleepHours(DateTime date) reads SLEEP_ASLEEP samples for that night filtering to asleepCore and asleepDeep and asleepREM and asleepUnspecified subtypes by checking value field, sums durations in hours returning double. getHeartRateRange(DateTime date) returns min and max bpm for that day. iOS and macOS: reads Apple HealthKit. Android: reads Google Health Connect requiring Android 9 plus. If HealthKit unavailable returns null for all methods and UI shows Not available placeholder. Permission check: hasPermissions() returns bool before reading, if false calls requestAuthorization first.


---
**in-progress -> in-testing** (2026-03-16T10:56:50Z):
## Changes
- lib/features/health/health_kit_service.dart (HealthKitService singleton with requestAuthorization, hasPermissions, getTodaySteps, getTodayEnergy, getLatestHeartRate, getLatestWeight, getBodyFat, getSleepHours, getHeartRateRange)


---
**in-testing -> in-docs** (2026-03-16T10:57:14Z):
## Results
- test/features/health/health_kit_service_test.dart (7 tests: requestAuthorization, hasPermissions, getTodaySteps, getTodayEnergy, getLatestHeartRate, getLatestWeight, getBodyFat — all pass)


---
**in-docs -> in-review** (2026-03-16T10:57:29Z):
## Docs
- docs/health-kit-service.md (HealthKitService API, platform notes)


---
**Review (approved)** (2026-03-16T10:57:33Z): Auto-approved: pre-existing service already implemented.
