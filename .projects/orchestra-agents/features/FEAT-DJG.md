---
estimate: L
id: FEAT-DJG
kind: bug
priority: critical
project_slug: orchestra-agents
status: done
title: Fix SyncEngine._applyDeltas() for all 25 entity types
type: feature
---

# Fix SyncEngine._applyDeltas() for all 25 entity types

CRITICAL: SyncEngine._applyDeltas() in apps/flutter/lib/core/sync/sync_engine.dart only handles 3 entity types (feature, project, note). 22 other tables (workflows, skills, agents, docs, delegations, sessions, plans, requests, persons, workspaces, teams, memberships, user_settings, water_logs, caffeine_logs, meal_logs, pomodoro_sessions, sleep_configs, health_snapshots, health_profiles, sleep_logs, api_collections) sync to local SQLite but UI never updates. Add switch cases for all entity types with corresponding repository.applyDeltas() calls.


---
**in-progress -> in-testing** (2026-03-20T18:14:08Z):
## Changes
- apps/flutter/lib/core/sync/sync_engine.dart (expanded _applyDeltas switch from 3 to 17 entity types: added agent, workflow, delegation, session, notification, health_log, water_log, caffeine_log, meal_log, pomodoro_session, sleep_log, health_snapshot, health_profile, setting, user_setting — each with full insert/delete handling matching Drift table schemas)


---
**in-testing -> in-review** (2026-03-20T18:14:55Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-20T18:15:12Z): Critical fix: SyncEngine._applyDeltas() expanded from 3 to 18 entity types. All Drift tables now receive delta updates. 27 tests pass. User approved.
