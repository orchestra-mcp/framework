---
estimate: M
id: FEAT-AZF
kind: feature
priority: P2
project_slug: orchestra-web-gate
status: backlog
title: Audit logging for tunnel operations
type: feature
---

# Audit logging for tunnel operations

Log every tool call made through a tunnel: timestamp, user, tunnel, tool_name, arguments (sanitized), response status, duration_ms. Store in PostgreSQL audit_log table. Admin UI to view audit trail with filters (by user, tunnel, tool, date range). Export as CSV/JSON. Retention policy (configurable, default 90 days). This is critical for team/enterprise use — knowing who did what on which machine.