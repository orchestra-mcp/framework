---
estimate: M
id: FEAT-DGX
kind: feature
priority: P0
project_slug: orchestra-agents
status: done
title: PostgreSQL sync rules — define tables and columns to sync
type: feature
---

# PostgreSQL sync rules — define tables and columns to sync

Create PowerSync sync-rules.yaml defining which PostgreSQL tables sync to clients: health_hydration, health_caffeine, health_nutrition, health_pomodoro, health_shutdown, notes, projects, features, agents, skills, workflows, delegations, sessions, user_settings. Define column-level sync rules, row-level security (user_id filter), and sync bucket partitioning.


---
**in-progress -> in-testing** (2026-03-18T17:23:15Z):
## Changes
- scripts/deploy/powersync/sync-rules.yaml (13 bucket definitions with row-level security — user_health covers 9 health tables, user_notes, user_projects, user_features, user_agents, user_skills, user_workflows, user_docs, user_delegations, user_sessions, user_settings, team_data for team-shared projects/notes)
- scripts/deploy/powersync/migrations/001_powersync_tables.sql (PostgreSQL migration creating all 9 health tables with indexes, health_settings table, and powersync publication for logical replication)


---
**in-testing -> in-docs** (2026-03-18T17:24:01Z):
## Results
- Validated scripts/deploy/powersync/sync-rules.yaml references 9 health tables that all exist in scripts/deploy/powersync/migrations/001_powersync_tables.sql
- All health tables covered: health_hydration, health_caffeine, health_nutrition, health_pomodoro, health_shutdown, health_weight, health_sleep, health_vitals, health_settings
- 10 additional synced tables (notes, projects, features, agents, skills, workflows, docs, delegations, sessions, user_settings) exist in the main app schema
- SQL syntax validated — all CREATE TABLE statements use IF NOT EXISTS for idempotency
- Publication creation uses DO block with existence check


---
**in-docs -> in-review** (2026-03-18T17:24:21Z):
## Docs
- docs/powersync-self-hosted.md (updated with migration instructions for 001_powersync_tables.sql)


---
**Review (approved)** (2026-03-18T17:24:36Z): Sync rules cover ALL data — 9 health tables, 10 app tables, team-shared data. Migration SQL creates health tables with indexes and powersync publication.
