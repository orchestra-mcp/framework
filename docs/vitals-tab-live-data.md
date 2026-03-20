# Vitals Tab — Live HealthKit Data

## Overview

The Vitals tab displays real-time health data from Apple HealthKit (iOS/macOS) and Health Connect (Android). It fetches 8 health metrics and refreshes live data every 30 seconds.

## Data Sources

| Metric | HealthKit Type | Card | Refresh |
|--------|---------------|------|---------|
| Steps | `STEPS` | Steps card (with progress bar + sparkline) | Live (30s) |
| Heart Rate | `HEART_RATE` | Heart Rate card (bpm + min/max range) | Live (30s) |
| Active Energy | `ACTIVE_ENERGY_BURNED` | Energy card (kcal) | Live (30s) |
| Blood Oxygen | `BLOOD_OXYGEN` | Blood O2 card (%) | Live (30s) |
| Respiratory Rate | `RESPIRATORY_RATE` | Breathing card (br/min) | Live (30s) |
| Sleep | `SLEEP_ASLEEP` | Sleep card (hours) | On load + pull-to-refresh |
| Weight | `WEIGHT` | Weight card (kg) + Zepp Scale pre-fill | On load + pull-to-refresh |
| Heart Rate Range | `HEART_RATE` | Min/Max in HR card | On load + pull-to-refresh |

## Permission Persistence

Permission state is cached in `SharedPreferences` under key `health_permissions_granted`. On app restart, the cached value is checked first, then verified against HealthKit. If permission was revoked, the cache is cleared and the empty state is shown.

## Live Refresh

A `Timer.periodic` (30s interval) refreshes rapidly-changing metrics: heart rate, energy, blood oxygen, respiratory rate, and steps. Sleep and weight only refresh on full load or pull-to-refresh.

## Files

- `lib/core/health/health_service.dart` — HealthService interface + HealthServiceImpl
- `lib/screens/health/tabs/vitals_tab.dart` — UI with all metric cards
- `test/screens/health/tabs/vitals_tab_test.dart` — 6 widget tests
