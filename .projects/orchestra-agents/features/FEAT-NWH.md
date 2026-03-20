---
estimate: M
id: FEAT-NWH
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: API Collections tables (api_collections, api_endpoints, api_environments)
type: feature
---

# API Collections tables (api_collections, api_endpoints, api_environments)

Go models for ApiCollection, ApiEndpoint, ApiEnvironment + register in GORM AutoMigrate. Files: models/api_collection.go, database/database.go


---
**in-progress -> in-testing** (2026-03-20T17:37:04Z):
## Changes
- apps/web/internal/models/api_collection.go (new — ApiCollection, ApiEndpoint, ApiEnvironment models with Base embed, GORM tags, JSON serialization)
- apps/web/internal/database/database.go (added ApiCollection, ApiEndpoint, ApiEnvironment to AutoMigrate list)


---
**in-testing -> in-docs** (2026-03-20T17:37:57Z):
## Results
- apps/web/internal/models/api_collection_test.go (new — 3 tests: TestApiCollectionDefaults, TestApiEndpointDefaults, TestApiEnvironmentDefaults)
- All 3 tests PASS (go test ./internal/models/ -run TestApi)
- Verified: ApiCollection, ApiEndpoint, ApiEnvironment struct zero values behave correctly


---
**in-docs -> in-review** (2026-03-20T17:38:18Z):
## Docs
- docs/api-collections-schema.md (new — documents all 3 tables: api_collections, api_endpoints, api_environments with column specs and file references)


---
**Review (approved)** (2026-03-20T17:39:08Z): Models approved. 3 tables with proper GORM tags, AutoMigrate registered.
