---
id: FEAT-KKG
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Per-project workflow engine resolution from DB with hot-reload
type: feature
---

# Per-project workflow engine resolution from DB with hot-reload

Change resolveWorkflowEngine to load per-project workflow from database instead of YAML. Cache engines per-project with invalidation when DB record changes. Update AdvanceFeature/SetCurrentFeature/GetGateRequirements/GetWorkflowStatus to resolve engine per feature project. Fix nextStepHint hardcoded switch to use eng.StateLabel(). Plan: PLAN-ZRP


---
**in-progress -> in-testing** (2026-03-17T08:53:14Z):
## Changes
- libs/sdk-go/workflow/resolver.go (new file - EngineResolver with per-project DB lookup, 30s TTL cache, cache invalidation, recordToDefinition converter)
- libs/plugin-tools-features/internal/tools/workflow.go (changed AdvanceFeature, RejectFeature, SetCurrentFeature, GetGateRequirements from *workflow.Engine to *workflow.EngineResolver, each resolves engine per-project)
- libs/plugin-tools-features/internal/tools/workflow_crud.go (added resolver param to CreateWorkflowCRUD, UpdateWorkflowCRUD, DeleteWorkflowCRUD with cache invalidation on mutations)
- libs/plugin-tools-features/internal/features.go (added Resolver field to FeaturesPlugin, pass resolver to all workflow tools)
- libs/plugin-tools-features/export.go (create EngineResolver wrapping the engine, pass to FeaturesPlugin)


---
**in-testing -> in-docs** (2026-03-17T08:54:08Z):
## Results
- libs/sdk-go/workflow/resolver_test.go (8 tests: fallback when no DB record, returns DB workflow with custom states, caches result, invalidate forces re-fetch, invalidate all clears cache, fallback accessor, empty project ID returns fallback, recordToDefinition conversion — ALL PASS)
- All existing tests pass: features_test.go (updated to use testResolver), delegation_test.go (updated to use resolvers), workflow_crud_test.go (updated to pass nil resolver), catalog_test.go, sdk-go packages


---
**in-docs -> in-review** (2026-03-17T08:54:32Z):
## Docs
- docs/workflow-engine-resolver.md (architecture diagram, how resolution works, cache invalidation strategy, affected tool handlers table, backwards compatibility notes)


---
**Review (approved)** (2026-03-17T08:55:49Z): Per-project engine resolution with DB lookup, caching, and auto-invalidation
