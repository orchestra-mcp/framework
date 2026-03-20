---
estimate: M
id: FEAT-SGN
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: PowerSync sync rules + CRUD allowlist + Flutter schema
type: feature
---

# PowerSync sync rules + CRUD allowlist + Flutter schema

Add user_api_collections and user_presentations buckets to sync-rules.yaml, add 5 tables to allowedTables in powersync_crud.go, add matching Flutter PowerSync schema tables. Files: sync-rules.yaml, powersync_crud.go, schema.dart


---
**in-progress -> in-testing** (2026-03-20T17:47:13Z):
## Changes
- scripts/deploy/powersync/sync-rules.yaml (modified — added user_api_collections bucket with 3 table queries and user_presentations bucket with 2 table queries)
- apps/web/internal/handlers/powersync_crud.go (modified — added api_collections, api_endpoints, api_environments, presentations, presentation_slides to allowedTables)
- apps/flutter/lib/core/powersync/schema.dart (modified — added 5 PowerSync table definitions: api_collections, api_endpoints, api_environments, presentations, presentation_slides)


---
**in-testing -> in-docs** (2026-03-20T17:47:52Z):
## Results
- apps/web/internal/handlers/powersync_crud_test.go (modified — added 5 new tables to TestAllowedTablesContainsRequiredTables: api_collections, api_endpoints, api_environments, presentations, presentation_slides)
- All handler tests PASS (go test ./internal/handlers/ -run TestAllowedTables)
- apps/flutter/lib/core/powersync/schema.dart — dart analyze: No issues found!


---
**in-docs -> in-review** (2026-03-20T17:48:11Z):
## Docs
- docs/powersync-preview-sync.md (new — documents 2 new sync buckets, 5 tables in CRUD allowlist, Flutter schema additions)


---
**Review (approved)** (2026-03-20T17:48:27Z): PowerSync sync rules and Flutter schema approved. Full offline sync for API collections and presentations.
