---
estimate: L
id: FEAT-FNP
kind: feature
priority: P0
project_slug: orchestra-agents
status: todo
title: SQLite sync client in MCP (login + initial sync + incremental)
type: feature
---

# SQLite sync client in MCP (login + initial sync + incremental)

Add sync-client module to MCP CLI. On 'orchestra login' or 'orchestra sync': authenticate with web API, pull all team projects/features/notes/skills/agents/hooks into local SQLite, store sync cursor. On subsequent syncs, only pull deltas. Push local changes (created offline) to cloud. Store auth token in ~/.orchestra/auth.json. Background sync on MCP serve startup.
