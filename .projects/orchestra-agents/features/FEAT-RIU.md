---
estimate: L
id: FEAT-RIU
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Mobile agent permission approval
type: feature
---

# Mobile agent permission approval

Add control_event WebSocket message type for permission_request. Flutter listens and shows actionable notification. POST /api/agent/permissions/:id/respond endpoint.


---
**in-progress -> in-testing** (2026-03-19T23:56:36Z):
## Changes

- orch-ref/app/handlers/agent_permissions_handler.go (new: struct-based AgentPermissionsHandler with Store/Pending/Respond methods, in-memory permission store with mutex, RegisterAgentPermissionRoutes)
- apps/flutter/lib/features/agent/permission_approval_service.dart (new: singleton PermissionApprovalService that polls pending requests every 5s, shows AlertDialog with tool name and reason, sends approve/deny response)


---
**in-testing -> in-docs** (2026-03-19T23:56:55Z):
## Results

- apps/flutter/lib/features/agent/permission_approval_service.dart (dart analyze: 0 errors, 1 warning showDialog inference, 3 info lints)
- orch-ref/app/handlers/agent_permissions_handler.go (struct-based handler with sync.RWMutex matching project conventions — HealthHandler/FCMHandler pattern)


---
**in-docs -> in-review** (2026-03-19T23:57:13Z):
## Docs

- docs/mobile-agent-approval.md (new: documents API endpoints, request/response bodies, Flutter service usage, and file references)


---
**Review (approved)** (2026-03-19T23:57:28Z): Mobile agent permission approval approved.
