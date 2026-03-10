---
created_at: "2026-03-07T06:25:18Z"
description: 'Log every tool call made through a tunnel: timestamp, user, tunnel, tool_name, arguments (sanitized), response status, duration_ms. Store in PostgreSQL audit_log table. Admin UI to view audit trail with filters (by user, tunnel, tool, date range). Export as CSV/JSON. Retention policy (configurable, default 90 days). This is critical for team/enterprise use — knowing who did what on which machine.'
estimate: M
id: FEAT-AZF
kind: feature
labels:
    - plan:PLAN-PMK
priority: P2
project_id: orchestra-web-gate
status: backlog
title: Audit logging for tunnel operations
updated_at: "2026-03-07T06:25:18Z"
version: 0
---

# Audit logging for tunnel operations

Log every tool call made through a tunnel: timestamp, user, tunnel, tool_name, arguments (sanitized), response status, duration_ms. Store in PostgreSQL audit_log table. Admin UI to view audit trail with filters (by user, tunnel, tool, date range). Export as CSV/JSON. Retention policy (configurable, default 90 days). This is critical for team/enterprise use — knowing who did what on which machine.
