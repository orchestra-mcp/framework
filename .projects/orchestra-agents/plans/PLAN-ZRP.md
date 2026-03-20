---
id: PLAN-ZRP
project_slug: orchestra-agents
status: approved
title: MCP Command Registry + Dynamic Workflow Engine
type: plan
---

# MCP Command Registry + Dynamic Workflow Engine

Two capabilities:

**1. MCP Command Registry** — Searchable catalog of all MCP tools
- Augment Router to track toolName-to-pluginID mapping
- 3 MCP tools: list_mcp_tools, search_mcp_tools, get_mcp_tool

**2. Dynamic Workflow Engine (DATABASE-BACKED)** — Per-project configurable workflows with CRUD
- PostgreSQL table for workflow definitions (shared across devices, synced)
- Schema: id, project_id, name, description, initial_state, states (JSONB), transitions (JSONB), gates (JSONB), created_at, updated_at
- 5 MCP tools: create_workflow, get_workflow, update_workflow, delete_workflow, list_workflows
- Per-project engine resolution from DB (not YAML files)
- Hot-reload: rebuild Engine when workflow record changes
- Fix nextStepHint hardcoded switch to use eng.StateLabel()
- Default workflow seeded on project init
- DB storage enables multi-device sync, team sharing, and UI management
