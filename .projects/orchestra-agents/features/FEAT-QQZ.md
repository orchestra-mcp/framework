---
estimate: S
id: FEAT-QQZ
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Extend shared_content (entity_id, unique_views, custom_domain)
type: feature
---

# Extend shared_content (entity_id, unique_views, custom_domain)

Add EntityID, UniqueViews, CustomDomain columns to SharedContent model. File: models/shared_content.go


---
**in-progress -> in-testing** (2026-03-20T17:41:42Z):
## Changes
- apps/web/internal/models/shared_content.go (modified — added EntityID string field for linking to api_collection/presentation/doc, UniqueViews int for analytics, CustomDomain string for future custom domain support)


---
**in-testing -> in-docs** (2026-03-20T17:42:03Z):
## Results
- apps/web/internal/models/shared_content_test.go (new — 2 tests: TestSharedContentNewFields, TestSharedContentEntityTypes)
- All 2 tests PASS (go test ./internal/models/ -run TestSharedContent)
- Verified: EntityID, UniqueViews, CustomDomain defaults; 8 entity types including new api_collection, presentation, doc


---
**in-docs -> in-review** (2026-03-20T17:42:15Z):
## Docs
- docs/shared-content-extensions.md (new — documents 3 new columns and extended entity types for SharedContent model)


---
**Review (approved)** (2026-03-20T17:42:28Z): SharedContent extensions approved. 3 new columns, 3 new entity types.
