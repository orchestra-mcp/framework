---
estimate: M
id: FEAT-IUF
kind: feature
priority: P2
project_slug: orchestra-agents
status: done
title: Team owner MCP log access API
type: feature
---

# Team owner MCP log access API

Add GET /api/teams/:id/mcp-logs with pagination + filters. Query from hook_events table. Restrict to team owner/admin role.


---
**in-progress -> in-testing** (2026-03-20T00:01:36Z):
## Changes

- orch-ref/app/handlers/mcp_logs_handler.go (new: getTeamMCPLogs handler with pagination, event_type/member/from/to filters, team owner/admin role check via memberships table, RegisterMCPLogsRoutes function)


---
**in-testing -> in-docs** (2026-03-20T00:01:46Z):
## Results

- orch-ref/app/handlers/mcp_logs_handler.go (verified: handler matches project conventions — middleware.RequireAuth, strconv pagination, fiber.Map responses, GORM query builder with optional filters)
- Role check queries memberships table for owner/admin before returning any data
- orch-ref is standalone module not in go.work — import warnings are expected and pre-existing


---
**in-docs -> in-review** (2026-03-20T00:02:04Z):
## Docs

- docs/team-mcp-logs.md (new: documents endpoint, query parameters, response format, authorization check, and file reference)


---
**Review (approved)** (2026-03-20T00:02:18Z): Team MCP logs API approved.
