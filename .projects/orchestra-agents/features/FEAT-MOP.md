---
estimate: M
id: FEAT-MOP
kind: bug
priority: P0
project_slug: orchestra-agents
status: done
title: Switch connector to batch CRUD endpoint
type: feature
---

# Switch connector to batch CRUD endpoint

Replace per-table uploadData with single POST to /api/powersync/crud. Remove _tableEndpoints, _transformBody, _apiRequest. Add plans/requests/persons to backend allowedTables.


---
**in-progress -> in-testing** (2026-03-19T14:21:03Z):
## Changes
- apps/flutter/lib/core/powersync/connector.dart (replaced per-table uploadData with single batch POST to /api/powersync/crud; removed _tableEndpoints, _transformBody, _apiRequest; kept _staleTables and UUID filter)
- apps/web/internal/handlers/powersync_crud.go (added plans, requests, persons to allowedTables)


---
**in-testing -> in-review** (2026-03-19T14:21:50Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-19T14:22:05Z): Batch CRUD connector approved. Clean simplification.
