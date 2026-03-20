---
id: FEAT-ONH
kind: bug
priority: P0
project_slug: orchestra-agents
status: done
title: Fix PowerSync cross-device sync — table name mismatch + migrate widget cards
type: feature
---

# Fix PowerSync cross-device sync — table name mismatch + migrate widget cards

PowerSync sync-rules.yaml references wrong table names (health_hydration, health_caffeine, etc.) but PostgreSQL actually uses water_logs, caffeine_logs, meal_logs, pomodoro_sessions, sleep_configs, health_snapshots, health_profiles. Also migrate notes/projects widget cards from Drift to PowerSync.


---
**in-progress -> in-testing** (2026-03-20T18:55:33Z):
## Changes
- scripts/deploy/powersync/migrations/001_powersync_tables.sql (rewrote: dropped 9 legacy tables with wrong names, created 8 correct tables matching PostgreSQL schema — water_logs, caffeine_logs, meal_logs, pomodoro_sessions, sleep_configs, health_snapshots, health_profiles, sleep_logs)
- apps/web/internal/database/migrations/20260320001000_create_sleep_logs.sql (new: PostgreSQL migration for sleep_logs table referenced by sync-rules.yaml and Flutter schema but missing from PostgreSQL)
- apps/web/internal/database/migrations/20260320002000_add_health_profiles_sync_columns.sql (new: adds caffeine_limit_mg and sleep_time columns to health_profiles for sync compatibility)
- apps/web/internal/database/migrations/20260320003000_add_sleep_configs_sync_columns.sql (new: adds wake_time and sleep_time columns to sleep_configs for sync compatibility)
- apps/flutter/lib/core/powersync/schema.dart (fixed sugar_g column type from Column.integer to Column.real to match PostgreSQL REAL type)
- apps/flutter/lib/core/powersync/powersync_provider.dart (bumped _schemaVersion from 10 to 11 to force full re-sync on devices with stale tables)


---
**in-testing -> in-review** (2026-03-20T18:59:14Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-20T19:00:20Z): PowerSync migration rewritten with correct table names, missing PostgreSQL migrations added, schema type fix, version bump forces re-sync.
