---
id: FEAT-SET
kind: feature
priority: P1
project_slug: orchestra-win
status: backlog
title: Projects plugin — list, detail, backlog tree, workflow states
type: feature
---

# Projects plugin — list, detail, backlog tree, workflow states

Implement `Orchestra.Desktop/Plugins/ProjectsPlugin/` — full project management UI.

**`ProjectsPage.xaml`** — two-column layout:
- Left: `ProjectSidebar` (280px) — `AutoSuggestBox` search, "+ New Project" button, `ListView` (icon, name, feature count, completion %, Active `InfoBadge`)
- Right: `ProjectDetailPage` — header (icon, name, description), status card (Total/Completed/% with animated purple `ProgressBar`), status breakdown (`InfoBar` per workflow group), `BacklogTree` (`TreeView` — epics > stories > tasks)

**`WorkflowState` enum** (13 states) with `GetColor()` and `GetDisplayName()` extensions:
- backlog/cancelled → gray, todo → blue, in-progress → purple (#A900FF), ready-for-testing → yellow, in-testing → orange, ready-for-docs → cyan, in-docs → teal, documented/done → green, in-review → indigo, blocked/rejected → red

**`BacklogTree`** — `TreeView` with lazy loading, drag-to-reorder, right-click context menu (set status, set priority, add dependency, delete)

**MCP tools called:** `list_projects`, `get_project_status`, `create_project`, `get_progress`, `list_features`, `create_feature`, `advance_feature`, `get_next_feature`, `get_blocked_features`, `get_dependency_graph`

**Platform:** Desktop, Xbox (dashboard view), HoloLens