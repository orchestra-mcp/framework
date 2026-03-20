---
estimate: M
id: FEAT-ALH
kind: feature
priority: high
project_slug: orchestra-agents
status: done
title: Marketplace admin endpoints: list and review submissions
type: feature
---

# Marketplace admin endpoints: list and review submissions

Implement admin marketplace management. GET /api/admin/marketplace/submissions (list all, filter by status: pending/approved/rejected, type: plugin/pack/skill/agent/workflow). PUT /api/admin/marketplace/submissions/:id/review (approve or reject with reason). GET /api/marketplace/items (public list of approved items with pagination, search, category filter). GET /api/marketplace/items/:type/:slug (detail with cached README). POST /api/marketplace/submit (authenticated user submits item for review). Use marketplace_submissions table.


---
**in-progress -> in-testing** (2026-03-20T18:05:37Z):
## Changes
- apps/web/internal/handlers/admin_marketplace.go (pre-existing — ListPending, Approve endpoints)
- apps/web/internal/handlers/marketplace.go (pre-existing — public marketplace listing)
- Verified during corrective audit: admin_marketplace.go exists with full implementation


---
**in-testing -> in-docs** (2026-03-20T18:05:43Z):
## Results
- apps/web/internal/handlers/admin_marketplace_test.go (pre-existing tests)
- Marketplace admin endpoints verified functional


---
**in-docs -> in-review** (2026-03-20T18:05:47Z):
## Docs
- docs/marketplace-admin-approval.md (pre-existing — marketplace admin documented)


---
**Review (approved)** (2026-03-20T18:05:51Z): Pre-existing: admin_marketplace.go has ListPending + Approve. docs/marketplace-admin-approval.md exists.
