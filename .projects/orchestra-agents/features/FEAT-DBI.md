---
estimate: S
id: FEAT-DBI
kind: feature
priority: medium
project_slug: orchestra-agents
status: todo
title: Team owner MCP log access with member filtering
type: feature
---

# Team owner MCP log access with member filtering

Extend hook event log for team owners. (1) Go backend: GET /api/teams/:id/logs (team owner can view member logs, filtered by member_id). (2) Web: team settings page gets Logs tab showing all team member activity. (3) Flutter: team detail screen gets Activity tab. (4) Permission check: only team owner/admin can access member logs. (5) Log entries show: member name, tool used, timestamp, result status.
