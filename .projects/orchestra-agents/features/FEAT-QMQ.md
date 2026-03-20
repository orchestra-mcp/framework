---
estimate: M
id: FEAT-QMQ
kind: feature
priority: high
project_slug: orchestra-agents
status: done
title: Flutter mobile delegation approval screen with actionable notifications
type: feature
---

# Flutter mobile delegation approval screen with actionable notifications

Build a Flutter screen for responding to agent delegation/permission requests from mobile. (1) DelegationApprovalScreen: shows pending delegation details (feature, agent, requested action, context). (2) Approve/Reject buttons that call control_event on hooks plugin. (3) Wire to NotificationListener: when agent-attention notification arrives, deep link to approval screen. (4) Action buttons directly in push notification (Android actionable notification). (5) Quick actions from notification tray without opening app.


---
**in-progress -> in-testing** (2026-03-20T18:36:10Z):
## Changes
- apps/flutter/lib/core/api/endpoints.dart (added delegationRespond endpoint)
- apps/flutter/lib/core/api/api_client.dart (added respondDelegation abstract method)
- apps/flutter/lib/core/api/rest_client.dart (added respondDelegation REST implementation)
- apps/flutter/lib/core/api/local_mcp_client.dart (added respondDelegation delegating to restClient)
- apps/flutter/lib/core/api/mcp_tcp_client.dart (added respondDelegation via MCP tool call)
- apps/flutter/lib/core/api/library_provider.dart (added respondDelegationProvider)
- apps/flutter/lib/screens/library/delegation_detail_screen.dart (converted to StatefulWidget, added response TextField + Respond button for pending delegations)
- apps/flutter/lib/core/notifications/notification_listener.dart (added onNotificationTap callback, delegation deep link payload, Android actionable notification with Approve/Decline actions)
- apps/flutter/lib/screens/shell/app_shell.dart (wired onNotificationTap to GoRouter navigation)
- apps/flutter/lib/features/delegation/delegation_notification_service.dart (wired snackbar View action to navigate to delegation detail)


---
**in-testing -> in-docs** (2026-03-20T18:37:24Z):
## Results
- apps/flutter/test/features/delegation/delegation_approval_test.dart (15 tests — DelegationEvent parsing, defaults, all event types, actionText, icons, colors, endpoint URLs, route generation, McpNotificationEvent delegation detection)
- All 15 tests pass: `flutter test test/features/delegation/delegation_approval_test.dart` → 15/15 passed


---
**in-docs -> in-review** (2026-03-20T18:38:27Z):
## Docs
- docs/mobile-agent-approval.md (updated — added Delegation Approval section with API endpoints, Flutter implementation table, screen behavior, notification deep linking, and test summary)


---
**Review (approved)** (2026-03-20T18:38:44Z): Delegation approval screen with respond API, notification deep linking, Android actionable notifications, 15 tests passing.
