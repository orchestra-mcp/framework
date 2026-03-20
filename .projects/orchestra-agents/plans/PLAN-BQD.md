---
id: PLAN-BQD
project_slug: orchestra-agents
status: in-progress
title: Team-Scoped Architecture: SQLite Sync + Claude Code Bridge + Real-Time Tracking
type: plan
---

# Team-Scoped Architecture: SQLite Sync + Claude Code Bridge + Real-Time Tracking

Complete architectural shift to team-scoped, sync-first data architecture.

## Vision
- Web app (PostgreSQL) is the source of truth
- MCP works locally over SQLite + RAG system
- On login, local SQLite syncs from PostgreSQL and rebuilds RAG
- Real-time tracking of status changes and file changes across all connected tunnels and team members
- Claude Code bridge enables smart actions from web → desktop via tunnel
- Projects managed by product/project managers on web, synced to local agents

## Architecture
```
User → Teams → Workspaces → Projects
Teams → Skills/Agents/Hooks (team-scoped automation)
Global → Skills/Agents/Hooks/Notes (shareable via public URL, includable in projects)
Tunnel → Desktop ↔ Web bridge for Claude Code smart actions
PostgreSQL (cloud) ↔ SQLite (local) sync engine
```

## Phases
1. SQLite local storage for MCP (replace file-based .projects/)
2. PostgreSQL ↔ SQLite sync engine 
3. RAG rebuild on sync (local vector search from synced data)
4. Claude Code bridge smart actions via tunnel
5. Real-time status tracking across tunnels and team members
6. Workflow control (Skills/Agents drive CLAUDE.md/AGENTS.md/CONTEXT.md)
7. Project sharing and PM tools on web
