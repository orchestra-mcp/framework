---
estimate: L
id: FEAT-API
kind: feature
priority: P1
project_slug: orchestra-flutter
status: todo
title: Projects screen, project detail with tabs and project tree view
type: feature
---

# Projects screen, project detail with tabs and project tree view

Create lib/features/projects/projects_screen.dart: Scaffold with GlassListTile list from Drift ProjectsDao.watchAll() stream, pull-to-refresh, FAB with plus icon creating new project via modal sheet asking name and description then calling ApiClient.createProject() and adding to sync_queue. Each tile shows project color icon container and name and description preview and active features count badge. Swipe right pin updating Drift isPinned, swipe left delete with confirm dialog. Long press enters multi-select mode showing bulk action bar with Delete and Export buttons. project_detail_screen.dart: receives project id via go_router params, shows project header GlassCard with name large and description and status chip. TabBar below with 4 tabs: Overview showing stats cards features by status and plans count and open requests count, Features showing filterable GlassListTile list with status chip filter row, Plans showing plan cards each with title and phase progress bar, Requests showing request list with priority P0-P3 badges. project_tree_screen.dart: receives project id, builds animated tree using expandable nodes. Root node is project name. Children: Features group expandable showing feature tiles with status chips, Plans group, Requests group, Persons group showing avatar chips. Each leaf node tappable navigating to detail or markdown editor. IndentGuide lines using CustomPaint. Expand/collapse uses AnimatedSize with 200ms curve.
