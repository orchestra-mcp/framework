---
estimate: M
id: FEAT-IZG
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Go handlers — Presentations CRUD + public + export
type: feature
---

# Go handlers — Presentations CRUD + public + export

PresentationHandler with List/Create/Show/Update/Delete + slide CRUD + ReorderSlides + PublicList/PublicShow + Export. Route registration. Files: handlers/presentations.go, routes/routes.go


---
**in-progress -> in-testing** (2026-03-20T17:44:29Z):
## Changes
- apps/web/internal/handlers/presentations.go (new — 417 lines: PresentationHandler with List/Create/Show/Update/Delete, slide CRUD (Create/Update/Delete/Reorder), PublicList/PublicShow, Export with 3 formats via ExportService)
- apps/web/internal/routes/routes.go (modified — registered 10 authenticated routes under /presentations and 2 public routes under /public/presentations)


---
**in-testing -> in-docs** (2026-03-20T17:44:53Z):
## Results
- apps/web/internal/handlers/presentations_test.go (new — 2 tests: TestNewPresentationHandler, TestPresentationAllowedTablesIncludesNewTables)
- All 2 tests PASS (go test ./internal/handlers/)
- Verified: handler constructor wires ExportService, PowerSync allowlist includes presentations/presentation_slides


---
**in-docs -> in-review** (2026-03-20T17:45:08Z):
## Docs
- docs/presentations-endpoints.md (new — documents all 12 REST endpoints: 5 presentation CRUD, 4 slide CRUD, 3 export formats, 2 public)


---
**Review (approved)** (2026-03-20T17:45:53Z): Presentations handlers approved. 12 endpoints with export and public sharing.
