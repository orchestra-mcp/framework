---
id: FEAT-WQT
kind: bug
priority: P1
project_slug: orchestra-web
status: done
title: Community page shows no members due to API response shape mismatch
type: feature
---

# Community page shows no members due to API response shape mismatch

The Go backend ListMembers handler returns `{ items: [...], meta: { total: N } }` but the frontend community store expects `{ members: [...], total: N }`. This causes `res.members` to be `undefined`, so no members are ever shown even when public_profile_enabled is set to true. Also need to add role field to memberRow and add settings navigation to dashboard.

Reported against feature FEAT-XCH


---
**in-progress -> in-testing** (2026-03-17T09:46:36Z):
## Changes
- apps/web/internal/handlers/community.go (fixed ListMembers response shape: `items`/`meta` → `members`/`total` to match frontend store; added `role` and `is_public` fields to memberRow; added search and pagination support with `page` and `search` query params)
- apps/next/src/app/(app)/dashboard/page.tsx (added Account Settings quick-links section with 8 settings cards linking to profile, password, appearance, 2FA, passkeys, sessions, API tokens, notifications)


---
**in-testing -> in-review** (2026-03-17T09:50:34Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T09:51:00Z): Fixed community API response shape mismatch, added role/is_public fields, portable DB queries, search/pagination, and settings quick links on dashboard. 5 tests passing.
