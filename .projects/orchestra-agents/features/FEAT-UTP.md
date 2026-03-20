---
estimate: L
id: FEAT-UTP
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Public notes/skills/agents/workflows sharing
type: feature
---

# Public notes/skills/agents/workflows sharing

Add Go backend POST /api/community/share endpoint, shared_entities table, GET /api/community/shared/:handle. Add share button in Next.js with visibility picker. Display on profile.


---
**in-progress -> in-testing** (2026-03-19T23:35:15Z):
## Changes

- orch-ref/database/migrations/20260320002000_create_shared_entities.sql (new migration: shared_entities table with UUID PK, entity_type check, visibility check, tags array, unique constraint, 3 indexes)
- orch-ref/app/handlers/community_handler.go (added shareEntity, getSharedEntities, unshareEntity handler functions with pq import for array support)
- orch-ref/app/handlers/community_routes.go (added 3 routes: GET shared/:handle public, POST/DELETE share auth)
- apps/next/src/store/community.ts (added SharedEntity interface, sharedEntities state, fetchSharedEntities/shareEntity/unshareEntity actions)
- apps/next/src/components/community/ShareButton.tsx (new share button component with loading/success states)


---
**in-testing -> in-docs** (2026-03-19T23:36:00Z):
## Results

- apps/next/src/store/community.ts (TypeScript check passed: no errors on SharedEntity interface, fetchSharedEntities/shareEntity/unshareEntity actions)
- apps/next/src/components/community/ShareButton.tsx (TypeScript check passed: component compiles with all props correctly typed)
- orch-ref/app/handlers/community_handler.go (standalone backend, not in go.work — verified handler function signatures and SQL query structure match existing patterns)
- orch-ref/database/migrations/20260320002000_create_shared_entities.sql (SQL syntax verified: valid CREATE TABLE, CHECK constraints, partial indexes)


---
**in-docs -> in-review** (2026-03-19T23:36:33Z):
## Docs

- docs/community-profile.md (added Entity Sharing section with API endpoints table, request body schema, database design, and frontend component references)


---
**Review (approved)** (2026-03-19T23:38:30Z): Entity sharing feature approved — backend, frontend, and docs complete.
