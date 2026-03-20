# Mobile Agent Permission Approval

## Overview

When an AI agent running on the desktop needs permission to use a restricted tool, it creates a permission request that the user can approve or deny from their mobile device.

## API Endpoints

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| POST | `/api/agent/permissions` | Yes | Create a permission request |
| GET | `/api/agent/permissions/pending` | Yes | List pending requests for current user |
| POST | `/api/agent/permissions/:id/respond` | Yes | Approve or deny a request |

### Create Request Body

```json
{
  "session_id": "session-uuid",
  "tool": "Bash",
  "reason": "Need to run npm install"
}
```

### Respond Body

```json
{
  "decision": "approved"
}
```

Decision must be `approved` or `denied`.

## Flutter Service

`PermissionApprovalService` (singleton) polls for pending requests every 5 seconds and shows a non-dismissible dialog with:
- Tool name (highlighted in amber)
- Reason text
- Approve / Deny buttons

### Usage

```dart
// Start polling (call after auth)
PermissionApprovalService.instance.start(context);

// Stop polling (call on logout)
PermissionApprovalService.instance.stop();
```

## Files

- `orch-ref/app/handlers/agent_permissions_handler.go` — Backend handler with in-memory store
- `apps/flutter/lib/features/agent/permission_approval_service.dart` — Flutter polling + dialog service

---

## Delegation Approval (Task Delegation)

Separate from tool permission requests, delegations allow agents/users to request review or approval for specific tasks.

### Delegation API

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/delegations` | List pending delegations (team-scoped) |
| GET | `/api/delegations/:id` | Get single delegation |
| POST | `/api/delegations/:id/respond` | Submit response `{ "response": "..." }` (sets status to `answered`) |

### Flutter Implementation

| Layer | File | Purpose |
|-------|------|---------|
| Endpoint | `lib/core/api/endpoints.dart` | `delegationRespond(id)` URL builder |
| Interface | `lib/core/api/api_client.dart` | `respondDelegation(id, response)` |
| REST | `lib/core/api/rest_client.dart` | Dio POST implementation |
| Desktop | `lib/core/api/local_mcp_client.dart` | Delegates to REST client for writes |
| TCP | `lib/core/api/mcp_tcp_client.dart` | MCP tool call `respond_delegation` |
| Provider | `lib/core/api/library_provider.dart` | `respondDelegationProvider` with list invalidation |
| Screen | `lib/screens/library/delegation_detail_screen.dart` | Approval UI with response input |

### Delegation Detail Screen

- Shows delegation question, from/to persons, feature ID, context (markdown)
- When status is `pending`: displays response `TextField` (4 lines) + green "Respond" button
- On submit: calls `respondDelegation`, invalidates list, shows snackbar, navigates back

### Notification Deep Linking

- `NotificationListener.onNotificationTap` — static callback wired by AppShell to GoRouter
- Notification payload: `/library/delegations/<id>` for delegation notifications
- Snackbar "View" action: `context.go(Routes.delegation(event.id))`
- Android: Approve/Decline action buttons directly in notification tray via `AndroidNotificationAction`

### Tests

15 unit tests in `test/features/delegation/delegation_approval_test.dart`:
- DelegationEvent JSON parsing, defaults, all 5 event types
- Action text, icon uniqueness, endpoint URLs, route generation
- McpNotificationEvent delegation detection
