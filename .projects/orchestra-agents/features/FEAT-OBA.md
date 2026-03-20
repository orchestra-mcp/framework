---
estimate: M
id: FEAT-OBA
kind: feature
priority: P0
project_slug: orchestra-agents
status: todo
title: PostgreSQL sync API endpoints (push/pull/delta)
type: feature
---

# PostgreSQL sync API endpoints (push/pull/delta)

Add sync endpoints to the Go web backend: POST /api/sync/push (client sends local changes with version vectors), GET /api/sync/pull (client requests changes since last sync cursor), GET /api/sync/delta (returns changed entity IDs since timestamp). All syncable entities (projects, features, plans, notes, skills, agents, hooks, persons) included. Uses sync_log table for change tracking. JWT auth + team scoping.