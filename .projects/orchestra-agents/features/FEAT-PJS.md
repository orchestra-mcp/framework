---
id: FEAT-PJS
kind: feature
priority: P2
project_slug: orchestra-agents
status: done
title: Test delegation flow end-to-end
type: feature
---

# Test delegation flow end-to-end

Dummy feature to test the delegate_feature → respond_delegation → unblock flow.


---
**Delegated** (2026-03-15T21:29:18Z): unknown → PERS-SDQ
> Should we use WebSocket or SSE for real-time delegation notifications on the web dashboard?


---
**Delegation DEL-TOY answered** (2026-03-15T21:30:08Z) by PERS-SDQ:
> Use the existing WebSocket sync channel. We already have the infrastructure — just add a delegation event type to the sync protocol. No need for a separate SSE endpoint.


---
**in-progress -> in-testing** (2026-03-15T21:30:14Z):
## Changes
- libs/plugin-tools-features/internal/tools/delegation.go (delegation tool handlers)
- libs/plugin-tools-features/internal/tools/workflow.go (blocking check)


---
**in-testing -> in-docs** (2026-03-15T21:31:17Z):
## Results
- libs/plugin-tools-features/internal/tools/delegation_test.go (10 tests, all pass)
- End-to-end MCP flow verified: delegate → block → respond → unblock → advance


---
**in-docs -> in-review** (2026-03-15T21:31:27Z):
## Docs
- docs/delegation.md (full delegation feature documentation already written)


---
**Review (approved)** (2026-03-15T21:31:32Z): E2E test chore — delegation flow verified manually via MCP tools.
