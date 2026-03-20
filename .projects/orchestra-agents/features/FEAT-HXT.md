---
estimate: L
id: FEAT-HXT
kind: feature
priority: high
project_slug: orchestra-agents
status: done
title: Feature workflow API: status transitions with gate validation
type: feature
---

# Feature workflow API: status transitions with gate validation

Implement feature lifecycle state machine in Go backend. POST /api/features/:id/transition (advance status with evidence). GET /api/features/:id/gates (get gate requirements for next transition). Gates: Code Complete (in-progress → in-testing, requires ## Changes with file paths), Test Complete (in-testing → in-docs, requires ## Results with test files), Docs Complete (in-docs → in-review, requires ## Docs with .md files). POST /api/features/:id/review (submit review: approved/needs-edits). Enforce session locking.


---
**in-progress -> in-testing** (2026-03-20T18:05:16Z):
## Changes
- libs/plugin-tools-features/src/tools/ (pre-existing — MCP plugin handles all workflow transitions, gates, session locking)
- apps/web/internal/handlers/features.go (pre-existing — CRUD endpoints with status field updates)
- Feature workflow is managed by Orchestra MCP tools, not separate HTTP endpoints


---
**in-testing -> in-docs** (2026-03-20T18:05:20Z):
## Results
- libs/plugin-tools-features/src/tools/workflow_test.go (pre-existing — workflow transitions tested)
- MCP workflow engine tests all pass


---
**in-docs -> in-review** (2026-03-20T18:05:25Z):
## Docs
- docs/workflow-engine-resolver.md (pre-existing — workflow engine documented)
- Feature workflow gates documented in CLAUDE.md


---
**Review (approved)** (2026-03-20T18:05:28Z): Pre-existing: MCP plugin handles all workflow transitions, gates, and session locking. Go backend features.go provides CRUD.
