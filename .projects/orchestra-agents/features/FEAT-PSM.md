---
estimate: M
id: FEAT-PSM
kind: feature
priority: medium
project_slug: orchestra-agents
status: todo
title: Hook event log viewer dashboard for web and Flutter desktop
type: feature
---

# Hook event log viewer dashboard for web and Flutter desktop

Build a UI for viewing MCP hook event logs. (1) Web: /settings/admin-logs page with table showing event_type, tool_name, agent_type, session_id, created_at. Filters: event type dropdown, session ID search, date range. Paginated. (2) Flutter desktop: add Logs tab in admin section with same table/filters. (3) Both consume GET /api/admin/hook-events endpoint (new). (4) Go backend handler wrapping get_hook_events MCP tool or querying SQLite directly.
