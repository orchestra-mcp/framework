---
id: FEAT-QVB
kind: feature
priority: P0
project_slug: orchestra-sync
status: done
title: Backend Sync API Client
type: feature
---

# Backend Sync API Client

HTTP client for sync REST endpoints:
- **POST /api/sync/push**: Upload entity with metadata to server
- **POST /api/sync/pull**: Download updates for specific entities or all
- **GET /api/sync/status**: Check for available updates (returns count + entity list)
- **POST /api/sync/share**: Share entity with team/selected members
- **GET /api/sync/history/:entityId**: Get version history for an entity

Handles: auth tokens (Bearer), pagination, error responses, request/response models, timeout configuration.

Depends on: FEAT-UFV (Sync Data Models)


---
**in-progress -> in-testing** (2026-03-17T15:11:41Z):
## Changes
- apps/flutter/lib/core/sync/sync_api_client.dart (extended — added 7 new team sharing API methods: shareEntity POST /api/sync/share, getTeamUpdates GET /api/sync/team-updates, getEntityHistory GET /api/sync/history/:type/:id, getTeams GET /api/teams, getTeamMembers GET /api/teams/:id/members, getEntityShares GET /api/sync/share/:type/:id, revokeShare DELETE /api/sync/share/:id; imported team_share_models.dart)


---
**in-testing -> in-docs** (2026-03-17T15:21:13Z):
## Results
- apps/flutter/test/core/sync/sync_api_client_test.dart (93 tests — all passing)
  - Team sharing API: shareEntity, getTeamUpdates, getEntityHistory
  - Teams API: getTeams, getTeamMembers
  - Entity shares API: getEntityShares, revokeShare
  - Error handling for all endpoints
  - Request/response serialization validation


---
**in-docs -> in-review** (2026-03-17T15:21:39Z):
## Docs
- docs/sync-api-client.md (API client reference — endpoints table, usage examples, dependencies)


---
**Review (approved)** (2026-03-17T15:22:25Z): API client with 7 team sync endpoints, 93 tests passing. Approved.
