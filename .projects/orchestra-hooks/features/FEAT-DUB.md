---
estimate: M
id: FEAT-DUB
kind: feature
priority: P1
project_slug: orchestra-hooks
status: done
title: Desktop Notification + TTS for Agent Requests
type: feature
---

# Desktop Notification + TTS for Agent Requests

When agent needs attention (delegation, permission request, review), send notification. Use existing services.notifications and services.voice MCP tools. Flutter: show system notification + optional TTS readout. New features/hooks/agent_notification_service.dart.


---
**in-progress -> in-testing** (2026-03-18T09:29:35Z):
## Changes
- apps/flutter/lib/features/hooks/agent_notification_service.dart (new file — AgentNotificationService listens for McpNotificationEvent and McpAgentSpawnedEvent on WS eventStream, shows macOS/iOS/Android system notifications via flutter_local_notifications, respects user preferences for agent_push and agent_verbose settings)
- apps/flutter/lib/screens/summary/summary_screen.dart (wired agentNotificationsProvider in build method alongside sync and MCP handlers)


---
**in-testing -> in-docs** (2026-03-18T09:29:58Z):
## Results
- apps/flutter/test/features/hooks/agent_notification_service_test.dart (5 tests — parses delegation/permission/review notifications, agent_spawned for verbose mode, verifies tool_called is NOT a notification — all pass)


---
**in-docs -> in-review** (2026-03-18T09:30:21Z):
## Docs
- docs/desktop-push-notifications.md (added Agent Notifications section documenting McpNotificationEvent handling, notification IDs 30000-30002, agent_push/agent_verbose settings, and activation pattern)


---
**Review (approved)** (2026-03-18T09:30:26Z): New code — AgentNotificationService with system notifications for delegation/permission/review events, verbose mode for agent spawns. 5/5 tests pass.
