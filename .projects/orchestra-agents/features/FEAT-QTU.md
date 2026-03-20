---
created_at: "2026-03-15T12:00:00Z"
description: 'Create a sync endpoint that exports all user/team data (projects, features, notes, skills, agents) as a SQLite-compatible payload. On MCP init or login, the local MCP downloads this payload and writes it to a local SQLite database. The RAG engine then re-indexes from this SQLite. Flow: (1) GET /api/sync/export returns all team data as JSON, (2) MCP sync-cloud plugin calls this on login, (3) Local storage-markdown plugin writes to SQLite, (4) RAG engine re-indexes. This enables offline-first operation with full data available locally.'
estimate: L
id: FEAT-QTU
kind: feature
labels:
    - plan:PLAN-UGE
depends_on:
    - FEAT-VSR
priority: P2
project_id: orchestra-agents
status: todo
title: "Local SQLite sync export and RAG rebuild on login"
updated_at: "2026-03-15T12:00:00Z"
version: 0
---

# Local SQLite sync export and RAG rebuild on login

Create a sync export endpoint + local SQLite write + RAG re-index flow. Enables offline-first operation with full project data available locally to the MCP.
