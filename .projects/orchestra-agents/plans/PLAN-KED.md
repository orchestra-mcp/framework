---
id: PLAN-KED
project_slug: orchestra-agents
status: in-progress
title: Plan 2: Sync Engine Fixes — Delta Application, Backend APIs, Settings Sync
type: plan
---

# Plan 2: Sync Engine Fixes — Delta Application, Backend APIs, Settings Sync

## Problem
SyncEngine._applyDeltas() only handles 3 of 25 tables (feature, project, note). 22 other entity types sync to local SQLite via PowerSync but UI never updates. Go backend sync endpoints (/api/{entity}/share, /api/team/updates, /api/team/pull) called by Flutter but handlers don't exist. CONTEXT.md generation, agent instructions panel, and settings sync provider are missing.

## Scope
- Fix SyncEngine delta application for all 25 entity types
- Implement Go backend sync API handlers (share, team updates, team pull)
- Implement user settings sync provider
- CONTEXT.md generation from project metadata
- Agent instructions panel (CLAUDE.md section editor)

## Priority: CRITICAL — Core sync is broken for most entities
