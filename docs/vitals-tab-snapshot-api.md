# Vitals Tab — Snapshot API Integration

## Overview

The Vitals tab on desktop now reads from and writes to the health snapshot API, replacing the previous hardcoded defaults in the Zepp Scale form.

## What Changed

### Save Button (previously empty)

The Zepp Scale "Save Measurements" button now calls `POST /api/health/snapshots` (`upsertSnapshot`) with:

| Field | Source |
|-------|--------|
| `snapshot_date` | Today's date (`YYYY-MM-DD`) |
| `weight_kg` | Zepp Scale weight field |
| `body_fat_pct` | Zepp Scale body fat field |
| `visceral_fat` | Zepp Scale visceral fat field |
| `body_water_pct` | Zepp Scale body water field |
| `metabolic_age` | Zepp Scale metabolic age field |
| `steps` | HealthKit/Health Connect (if available) |
| `active_energy_cal` | HealthKit/Health Connect (if available) |
| `avg_heart_rate` | HealthKit/Health Connect (if available) |
| `sleep_hours` | HealthKit/Health Connect (if available) |

### Pre-population from Latest Snapshot

On tab load, `GET /api/health/snapshots?from=today&to=today` is called. If a snapshot exists for today, the Zepp Scale form fields are pre-populated with saved values. HealthKit weight always takes precedence over the snapshot weight when available.

### Priority Order for Weight Field

1. HealthKit / Health Connect weight (real-time)
2. Latest snapshot `weight_kg` (previously saved)
3. Hardcoded fallback `82.4`

### Loading Indicator

While saving, the button shows a spinner and is disabled to prevent double-submission. On success/failure a snackbar is shown.

## Files Modified

| File | Change |
|------|--------|
| `apps/flutter/lib/screens/health/tabs/vitals_tab.dart` | Wired save button, snapshot fetch on load, converted `_ZeppScaleSection` to `ConsumerStatefulWidget` |

## API Reference

- `upsertSnapshot(body)` — defined in `ApiClient`, implemented by `RestClient` and `McpTcpClient`
- `listSnapshots({from, to})` — returns list of snapshots for a date range
- Endpoint: `POST /api/health/snapshots` (upsert by date), `GET /api/health/snapshots`
