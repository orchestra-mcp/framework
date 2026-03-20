---
id: FEAT-CUS
kind: feature
priority: P2
project_slug: orchestra-agents
status: done
title: Default workflow seeding on project init
type: feature
---

# Default workflow seeding on project init

When create_project runs, auto-seed the default 7-state workflow definition in the database for that project. Migrate existing projects: if no workflow record exists, create one on first workflow tool access. Plan: PLAN-ZRP


---
**in-progress -> in-testing** (2026-03-17T09:01:15Z):
## Changes
- libs/sdk-go/workflow/resolver.go (added SeedDefaultWorkflow function, auto-seeding in Resolve method)
- libs/plugin-tools-features/internal/tools/project.go (call SeedDefaultWorkflow on project create)
- libs/sdk-go/workflow/resolver_test.go (rewrote 9 tests for auto-seeding behavior)


---
**in-testing -> in-docs** (2026-03-17T09:01:33Z):
## Results
- libs/sdk-go/workflow/resolver_test.go — 9 tests all PASS:
  - TestResolver_AutoSeedsDefaultWorkflow: verifies Resolve auto-seeds default workflow in DB
  - TestResolver_ReturnsDBWorkflow: verifies custom DB workflow overrides default
  - TestResolver_CachesResult: verifies same engine pointer from cache
  - TestResolver_InvalidateForcesFetch: verifies cache invalidation picks up new DB record
  - TestResolver_InvalidateAll: verifies full cache clear
  - TestResolver_FallbackAccessor: verifies Fallback() returns fallback engine
  - TestResolver_EmptyProjectIDReturnsFallback: verifies empty projectID returns fallback
  - TestRecordToDefinition: verifies DB record to WorkflowDefinition conversion
  - TestSeedDefaultWorkflow: verifies first seed creates record, second is no-op
- libs/plugin-tools-features/internal/tools/workflow_crud_test.go — 19 tests all PASS
- libs/plugin-tools-features/internal/features_test.go — all tests PASS
- Full suite: go test ./libs/sdk-go/... ./libs/plugin-tools-features/... — all PASS


---
**in-docs -> in-review** (2026-03-17T09:01:52Z):
## Docs
- docs/default-workflow-seeding.md (new — explains auto-seeding on project create and first resolve, idempotency, default states table, API reference)


---
**Review (approved)** (2026-03-17T09:02:22Z): Default workflow seeding complete — auto-seeds on project create and first resolve, idempotent, all tests pass.
