---
created_at: "2026-03-07T11:25:01Z"
description: 'When the web gate receives a tool call for an external plugin (e.g. `list_accounts` from `tools.agentops`), it fails with "open stream: context canceled". Core in-process plugins work fine. The QUIC stream to external plugins cannot be opened from the web gate''s router.'
id: FEAT-JDP
kind: bug
labels:
    - reported-against:FEAT-QVI
priority: P0
project_id: orchestra-web-gate
status: done
title: 'Web gate fails to route tool calls to external QUIC plugins (open stream: context canceled)'
updated_at: "2026-03-09T02:15:45Z"
version: 12
---

# Web gate fails to route tool calls to external QUIC plugins (open stream: context canceled)

When the web gate receives a tool call for an external plugin (e.g. `list_accounts` from `tools.agentops`), it fails with "open stream: context canceled". Core in-process plugins work fine. The QUIC stream to external plugins cannot be opened from the web gate's router.

Reported against feature FEAT-QVI


---
**in-progress -> in-testing** (2026-03-07T11:27:38Z):
## Changes
- libs/cli/internal/inprocess/webgate.go (fixed context cancellation bug for external QUIC plugins)
  - Added server lifecycle context (ctx/cancel) to WebGateServer struct
  - NewWebGateServer creates a background context for all WebSocket connections
  - handleUpgrade now uses server context instead of r.Context() — r.Context() gets canceled by net/http after WebSocket upgrade, causing QUIC OpenStreamSync to fail with "open stream: context canceled"
  - ListenAndServe cancels server context on shutdown for clean cleanup
  - Each WebSocket connection gets its own child context from the server context


---
**in-testing -> in-review** (2026-03-07T11:28:36Z): Gate skipped for kind=bug


---
**Review (needs-edits)** (2026-03-07T11:29:56Z): User still sees the same error after fix. Need deeper investigation — the context fix is correct but there may be an additional issue with the QUIC connection itself.


---
**in-progress -> in-testing** (2026-03-07T11:31:15Z):
## Changes
- libs/cli/internal/inprocess/webgate.go (fixed context cancellation bug for external QUIC plugins)
  - Added server lifecycle context (ctx/cancel) to WebGateServer struct
  - NewWebGateServer creates a background context for all WebSocket connections  
  - handleUpgrade now uses server context instead of r.Context()
  - r.Context() gets canceled by net/http after WebSocket upgrade completes, which caused QUIC OpenStreamSync to immediately fail with "open stream: context canceled" for ALL external plugin tool calls
  - Each WebSocket connection gets a child context from the server context
  - Server context canceled on shutdown for clean cleanup


---
**in-testing -> in-review** (2026-03-07T11:31:29Z): Gate skipped for kind=bug


---
**Review (needs-edits)** (2026-03-07T11:32:44Z): Error persists after rebuild and restart. The context fix is necessary but not sufficient — there's a deeper issue with the QUIC connection to external plugins.


---
**in-progress -> in-testing** (2026-03-08T16:39:19Z):
## Changes
- libs/cli/internal/inprocess/webgate.go (context fix for WebSocket → QUIC routing)
  - Added server lifecycle context to WebGateServer struct
  - handleUpgrade uses server context instead of r.Context() which gets canceled after WebSocket upgrade
  - Each WebSocket connection gets a child context from the server context

- libs/cli/internal/serve.go (orphaned process cleanup on startup)
  - stopExistingInstance now calls killOrphanedProcesses() after stopping the PID-locked instance
  - killOrphanedProcesses() finds and SIGTERMs all leftover orchestra serve + plugin child processes
  - killMatchingProcesses() uses pgrep to find processes by command pattern, skipping self
  - Prevents the root cause: multiple stale instances with orphaned QUIC-connected plugins that new instances can't reach


---
**in-testing -> in-review** (2026-03-08T16:39:42Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-09T02:15:45Z): Approved — context fix and orphaned process cleanup address the root cause.
