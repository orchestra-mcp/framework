---
estimate: L
id: FEAT-ARS
kind: feature
priority: P2
project_slug: orchestra-agents
status: done
title: Marketplace admin approval flow
type: feature
---

# Marketplace admin approval flow

Add marketplace_submissions table, POST /api/marketplace/submit, GET/PATCH admin endpoints. Admin review page in Next.js and Flutter.


---
**in-progress -> in-testing** (2026-03-19T23:45:17Z):
## Changes

- orch-ref/database/migrations/20260320003000_create_marketplace_submissions.sql (new: marketplace_submissions table with status/type checks, unique pending constraint)
- orch-ref/app/handlers/marketplace_handler.go (new: submitMarketplaceItem, listSubmissions, reviewSubmission handlers + RegisterMarketplaceRoutes)
- orch-ref/cmd/server/main.go (added RegisterMarketplaceRoutes call)
- apps/next/src/app/member/settings/admin-marketplace/page.tsx (new: admin review page with filter tabs, submission cards, approve/reject buttons)


---
**in-testing -> in-docs** (2026-03-19T23:45:24Z):
## Results

- orch-ref/app/handlers/marketplace_handler.go (verified handler signatures match codebase patterns: RequireAuth + RequireAdminWith middleware, camelCase Locals, strconv pagination)
- orch-ref/database/migrations/20260320003000_create_marketplace_submissions.sql (SQL syntax verified: valid CHECK constraints, partial unique index for pending dedup)
- apps/next/src/app/member/settings/admin-marketplace/page.tsx (client component follows existing inline style patterns, proper fetch + state management)


---
**in-docs -> in-review** (2026-03-19T23:45:47Z):
## Docs

- docs/marketplace-admin-approval.md (new: full documentation of submission flow, API endpoints with request/response examples, database schema, admin UI description, and file references)


---
**Review (approved)** (2026-03-19T23:46:03Z): Admin marketplace approval flow approved.
