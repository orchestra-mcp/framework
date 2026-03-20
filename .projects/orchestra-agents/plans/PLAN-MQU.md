---
id: PLAN-MQU
project_slug: orchestra-agents
status: in-progress
title: Plan 6: Go Backend Missing Endpoints — Features API, Marketplace Admin, Search, Notification History
type: plan
---

# Plan 6: Go Backend Missing Endpoints — Features API, Marketplace Admin, Search, Notification History

## Problem
Go backend has 97 endpoints but is missing ~48 endpoints that Flutter and Next.js frontends expect. Key gaps: (1) Feature workflow CRUD + state transitions + gate validation — ~25 endpoints. (2) Marketplace admin submission review — ~5 endpoints. (3) Full-text search API — ~3 endpoints. (4) Notification history + mark-read + WebSocket — ~3 endpoints. (5) Sync recovery endpoints — ~2 endpoints.

## Scope
- Feature CRUD: list/create/update/delete features per project
- Feature workflow: transition status, gate validation with evidence
- Marketplace admin: list/approve/reject submissions
- Search API: full-text search across notes/features/docs/skills/agents
- Notification history: list, mark-read, preferences
- Sync recovery: reset, status per device

## Priority: HIGH — Frontend calls these endpoints but gets 404
