---
estimate: L
id: FEAT-KYW
kind: feature
priority: P0
project_slug: orchestra-agents
status: todo
title: SQLite storage plugin for MCP (replace file-based .projects/)
type: feature
---

# SQLite storage plugin for MCP (replace file-based .projects/)

Create a new storage-sqlite plugin that replaces storage-markdown. All MCP data (features, plans, notes, persons, requests, sessions) stored in local SQLite database instead of Markdown files. Schema mirrors PostgreSQL tables with UUID PKs, version, timestamps, soft delete. Plugin implements the same storage interface so all existing tools work unchanged.