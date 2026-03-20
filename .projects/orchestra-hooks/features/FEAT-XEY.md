---
estimate: M
id: FEAT-XEY
kind: feature
priority: P1
project_slug: orchestra-hooks
status: done
title: Flutter Desktop Event Listener
type: feature
---

# Flutter Desktop Event Listener

Listen for mcp.* WS events in Flutter app. Auto-refresh relevant screens when data changes (e.g. project created -> refresh project list). Add new event types to core/ws/ws_event.dart. New features/hooks/mcp_event_handler.dart.


---
**in-progress -> in-testing** (2026-03-18T09:26:39Z):
## Changes
- apps/flutter/lib/core/ws/ws_event.dart (added McpEvent sealed class hierarchy: McpToolCalledEvent, McpAgentSpawnedEvent, McpNotificationEvent, McpGenericEvent — parses type:"mcp" WS events by action field)
- apps/flutter/lib/features/hooks/mcp_event_handler.dart (new file — McpEventHandler listens to WsManager.eventStream, dispatches provider invalidations on tool calls/notifications, auto-refreshes project/feature/note screens)
- apps/flutter/lib/screens/summary/summary_screen.dart (wired mcpRealtimeProvider alongside syncRealtimeProvider in build method)


---
**in-testing -> in-docs** (2026-03-18T09:27:30Z):
## Results
- apps/flutter/test/features/hooks/mcp_event_test.dart (6 tests — parses tool_called, agent_spawned, notification, unknown action, type hierarchy, missing fields — all pass)


---
**in-docs -> in-review** (2026-03-18T09:28:13Z):
## Docs
- docs/flutter-event-listener.md (documents MCP event listener architecture, event types, provider invalidation strategy, and file locations)


---
**Review (approved)** (2026-03-18T09:28:18Z): New code — MCP event types in ws_event.dart + McpEventHandler with provider invalidation + wired into summary screen. 6/6 tests pass.
