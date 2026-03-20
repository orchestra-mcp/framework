---
id: FEAT-JBJ
kind: feature
priority: P1
project_slug: orchestra-pro
status: done
title: Enforce Context Timeout in Storage and Transport
type: feature
---

# Enforce Context Timeout in Storage and Transport

Add ctx.Err() checks and select { case <-ctx.Done() } in all storage operations (Read, Write, Delete, List), external plugin QUIC calls, and long-running loops. A hung operation should respect cancellation instead of blocking forever. Files: libs/plugin-storage-markdown/internal/storage.go, libs/cli/internal/inprocess/router.go, external.go.


---
**in-progress -> in-testing** (2026-03-14T18:58:25Z):
## Changes
- libs/plugin-storage-markdown/internal/storage.go (added ctx.Err() checks at entry of Read, Write, Delete, List; added ctx.Err() abort inside filepath.Walk callback for List)
- libs/cli/internal/inprocess/router.go (added ctx.Err() check at top of Send before dispatching)


---
**in-testing -> in-docs** (2026-03-14T18:59:34Z):
## Results
- libs/plugin-storage-markdown/internal/storage_test.go (4 new tests: TestReadRespectsContextCancellation, TestWriteRespectsContextCancellation, TestDeleteRespectsContextCancellation, TestListRespectsContextCancellation — all PASS)
- libs/cli/internal/inprocess/router_recovery_test.go (1 new test: TestRouterSend_CancelledContext — PASS)
- Full suites: 17/17 storage-markdown, all inprocess tests pass, 23/23 transport-stdio


---
**in-docs -> in-review** (2026-03-14T18:59:54Z):
## Docs
- docs/context-timeout-enforcement.md (new — documents context cancellation enforcement in storage and router)


---
**Review (approved)** (2026-03-14T19:00:06Z): Context timeout enforcement across storage and router. 5 new tests pass.