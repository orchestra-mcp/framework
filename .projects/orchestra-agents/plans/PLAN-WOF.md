---
id: PLAN-WOF
project_slug: orchestra-agents
status: completed
title: Orchestra Preview — Plan 2: Flutter DevTools UI
type: plan
---

# Orchestra Preview — Plan 2: Flutter DevTools UI

Flutter UI for 5 MCP tool categories: API Collections, Database Browser, Log Runner, Secrets Manager, Prompts Manager. All screens call MCP tools via McpTcpClient.callTool() on port 9201.

Depends on Plan 1 (PLAN-REG, completed).

## Features (7)
2.1 MCP DevTools provider layer (typed Dart wrappers for callTool) — M
2.2 API Collection Manager (3-pane: sidebar, request builder, response viewer) — L
2.3 Database Browser (connect, tables, query editor, schema viewer) — L
2.4 Log Runner (process launcher, streaming output, search/filter) — M
2.5 Secrets Manager (list/create/reveal/delete, .env import) — S
2.6 Prompts Manager (startup prompts + quick actions, markdown editor) — S
2.7 DevTools navigation integration (sidebar group, mobile drawer) — S

## Order
2.1 → 2.2 + 2.3 + 2.4 + 2.5 + 2.6 (parallel) → 2.7
