---
id: PLAN-UGE
project_slug: orchestra-agents
status: approved
title: Fill architecture gaps: CONTEXT.md, public notes, local SQLite sync + RAG
type: plan
---

# Fill architecture gaps: CONTEXT.md, public notes, local SQLite sync + RAG

Three gaps identified against the original team-scoped architecture vision:

## Gap 1: CONTEXT.md generation
CLAUDE.md and AGENTS.md are generated from project includes, but CONTEXT.md (project architecture, stack detection, patterns, conventions) is missing. This is the third file that drives context-aware flow for the MCP.

## Gap 2: Public Notes sharing
Skills/Agents/Hooks all have `Scope` + `PublicURL` fields and public endpoints. Notes do NOT — they're user-scoped only. Need to add scope field, public URL, and public endpoint to match the established pattern.

## Gap 3: Local SQLite sync + RAG rebuild
The vision describes moving projects to SQLite locally, syncing to PostgreSQL, and rebuilding RAG on login. Currently web backend is PostgreSQL-only, RAG engine has its own SQLite but isn't wired to the sync pipeline. Need: login → sync to local SQLite → rebuild RAG flow.