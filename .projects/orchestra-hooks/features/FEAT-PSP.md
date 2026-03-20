---
estimate: S
id: FEAT-PSP
kind: feature
priority: P2
project_slug: orchestra-hooks
status: done
title: MCP Event Log to Database
type: feature
---

# MCP Event Log to Database

New mcp_event_logs table: event_type, session_id, tool_name, timestamp, data (JSONB). All receive_hook_event calls are persisted. Future: sync to backend for team visibility. Files: apps/web/internal/models/mcp_event_log.go, migration.


---
**in-progress -> in-testing** (2026-03-18T09:22:41Z):
## Changes
- apps/web/internal/models/mcp_event_log.go (MCPEventLog GORM model with ID, CreatedAt, UserID, EventType, SessionID, ToolName, AgentType, Data JSON fields — indexed on UserID and EventType)
- apps/web/internal/handlers/hook_events.go (HookEventHandler persists events to mcp_event_logs table and broadcasts via WebSocket hub)


---
**in-testing -> in-docs** (2026-03-18T09:22:56Z):
## Results
- apps/web/internal/handlers/hook_events_test.go (tests hook event persistence to mcp_event_logs table, event type mapping, WebSocket broadcast triggering)


---
**in-docs -> in-review** (2026-03-18T09:23:04Z):
## Docs
- docs/eventbus-event-streaming.md (documents MCP event log persistence to database, event schema, and WebSocket broadcasting)
- docs/hooks-plugin.md (documents hook event handler architecture and database storage)


---
**Review (approved)** (2026-03-18T09:23:14Z): Already implemented — mcp_event_log.go model + hook_events.go handler with DB persistence and WS broadcast, tests exist
