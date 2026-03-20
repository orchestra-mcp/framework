---
estimate: M
id: FEAT-VSJ
kind: feature
priority: P1
project_slug: orchestra-hooks
status: done
title: Hook → WebSocket Event Bridge
type: feature
---

# Hook → WebSocket Event Bridge

When receive_hook_event processes an event, broadcast via WS hub to connected Flutter clients. New WS event types: mcp.tool_called, mcp.feature_advanced, mcp.project_created. Files: apps/web/internal/handlers/hook_events.go (new), apps/web/internal/hub/event.go


---
**in-progress -> in-testing** (2026-03-18T08:47:46Z):
## Changes
- internal/handlers/hook_events.go (new — HookEventHandler with Receive and List endpoints, event type mapping)
- internal/models/mcp_event_log.go (new — MCPEventLog model with user_id, event_type, session_id, tool_name, agent_type, data JSON)
- internal/hub/event.go (added ToolName, SessionID, AgentType fields for mcp event type)
- internal/database/database.go (added MCPEventLog to AutoMigrate list)
- internal/routes/routes.go (registered POST/GET /api/hooks/events routes, initialized hookEventHandler)

## Summary
Created hook-to-WebSocket bridge. POST /api/hooks/events receives MCP events (event_type, session_id, tool_name, agent_type, data), persists to mcp_event_logs table, and broadcasts to user's WS clients as type "mcp" events. GET /api/hooks/events returns recent event logs. Event type mapping converts Claude Code hook events to WS actions.

## Verification
Go build passes clean. Routes registered. Handler bridges MCP events to WS hub.


---
**in-testing -> in-docs** (2026-03-18T08:48:20Z):
## Results
- internal/handlers/hook_events_test.go (14 tests passing — 8 for mapEventAction, 6 for entityTypeFromEvent)

## Summary
All 14 unit tests pass covering event type mapping (tool_use_start/end, agent_tool_use_start/end, notification, subagent_start/end, custom) and entity type derivation. Full handler test suite still passes.

## Coverage
Test coverage includes all event type branches and fallback cases for both mapping functions.


---
**in-docs -> in-review** (2026-03-18T08:49:03Z):
## Docs
- docs/eventbus-event-streaming.md (added Hook → WebSocket Bridge section with API endpoints, event type mapping table, and backend file references)

## Summary
Added documentation for the Go backend hook-to-WebSocket bridge to the existing event streaming doc.

## Location
- docs/eventbus-event-streaming.md


---
**Review (approved)** (2026-03-18T08:49:34Z): Hook event bridge complete. 14 tests pass. API endpoints registered.
