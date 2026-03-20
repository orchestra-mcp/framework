---
estimate: M
id: FEAT-XFZ
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Go handlers — API Collections CRUD + public endpoints
type: feature
---

# Go handlers — API Collections CRUD + public endpoints

ApiCollectionHandler with List/Create/Show/Update/Delete + endpoint CRUD + environment CRUD + PublicList/PublicShow. Route registration. Files: handlers/api_collections.go, routes/routes.go


---
**in-progress -> in-testing** (2026-03-20T17:42:52Z):
## Changes
- apps/web/internal/handlers/api_collections.go (new — 457 lines: ApiCollectionHandler with List/Create/Show/Update/Delete, endpoint CRUD (Create/Update/Delete), environment CRUD (Create/Update/Delete), PublicList/PublicShow)
- apps/web/internal/routes/routes.go (modified — registered 12 authenticated routes under /api-collections and 2 public routes under /public/api-collections)


---
**in-testing -> in-docs** (2026-03-20T17:43:20Z):
## Results
- apps/web/internal/handlers/api_collections_test.go (new — 2 tests: TestNewApiCollectionHandler, TestApiCollectionAllowedTablesIncludesNewTables)
- All 2 tests PASS (go test ./internal/handlers/ -run TestApiCollection and -run TestNewApiCollectionHandler)
- Verified: handler constructor works, PowerSync CRUD allowlist includes api_collections/api_endpoints/api_environments


---
**in-docs -> in-review** (2026-03-20T17:43:39Z):
## Docs
- docs/api-collections-endpoints.md (new — documents all 14 REST endpoints: 5 collection CRUD, 3 endpoint CRUD, 3 environment CRUD, 2 public)


---
**Review (approved)** (2026-03-20T17:44:08Z): API Collections handlers approved. 14 endpoints, clean handler pattern.
