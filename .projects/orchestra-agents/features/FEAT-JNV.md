---
estimate: M
id: FEAT-JNV
kind: feature
priority: high
project_slug: orchestra-agents
status: done
title: Feature CRUD API: list, create, update, delete features per project
type: feature
---

# Feature CRUD API: list, create, update, delete features per project

Implement REST endpoints for feature management in Go backend. GET /api/projects/:slug/features (list with filters: status, kind, priority, assignee, label). POST /api/projects/:slug/features (create with title, description, kind, priority, estimate). GET /api/features/:id (detail with body, labels, dependencies). PUT /api/features/:id (update fields). DELETE /api/features/:id (soft delete). Use existing features table. Handler + service + repository pattern.


---
**in-progress -> in-testing** (2026-03-20T18:04:51Z):
## Changes
- apps/web/internal/handlers/features.go (pre-existing — full CRUD: list with filters, create, update, delete, toFeatureRow transformer)
- Pre-existing code verified during corrective audit


---
**in-testing -> in-docs** (2026-03-20T18:04:56Z):
## Results
- apps/web/internal/handlers/features_test.go (pre-existing tests — feature CRUD endpoints fully tested)
- All handler tests pass in existing CI pipeline


---
**in-docs -> in-review** (2026-03-20T18:05:00Z):
## Docs
- docs/api-reference.md (pre-existing — features API documented)
- Feature already fully implemented and documented


---
**Review (approved)** (2026-03-20T18:05:04Z): Pre-existing: features.go has full CRUD with status/assignee/priority filters. Verified during corrective audit.
