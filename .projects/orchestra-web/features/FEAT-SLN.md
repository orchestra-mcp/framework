---
id: FEAT-SLN
kind: feature
priority: P1
project_slug: orchestra-web
status: backlog
title: Features Kanban + Projects Grid + Prompts Browser
type: feature
---

# Features Kanban + Projects Grid + Prompts Browser

Three project management pages reusing existing task components from @orchestra-mcp/tasks.

Features page (`apps/web/src/pages/features.tsx`):
- Project selector dropdown at top (calls mcp.callTool("list_projects"))
- 5-column Kanban using BacklogView + BacklogColumn from @orchestra-mcp/tasks
- BacklogCard components with StatusBadge + PriorityIcon from @orchestra-mcp/tasks
- Fetches per column: mcp.callTool("list_features", {project_id, status: "backlog"|"todo"|"in-progress"|"in-review"|"done"})
- LifecycleProgressBar from @orchestra-mcp/tasks on each card
- Refresh button using Button from @orchestra-mcp/ui

Projects page (`apps/web/src/pages/projects.tsx`):
- Card grid: 3 cols desktop, 2 tablet, 1 mobile
- Each card (Panel from @orchestra-mcp/ui): project name, description, ID Badge, feature count
- Loads via mcp.callTool("list_projects")
- Skeleton from @orchestra-mcp/ui during load
- Click card navigates to /features?project={id}

Prompts page (`apps/web/src/pages/prompts.tsx`):
- Two-panel layout matching Tools Explorer
- Left: prompt list from mcp.listPrompts()
- Right: prompt name + description, argument inputs (Input from @orchestra-mcp/ui per argument, required marked), "Run" Button
- Result: message bubbles (role: user/assistant) using MarkdownRenderer from @orchestra-mcp/editor for content rendering

Acceptance: Features Kanban shows features per column, Projects grid loads all projects, Prompt execution shows messages