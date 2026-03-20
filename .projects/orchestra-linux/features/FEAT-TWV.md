---
id: FEAT-TWV
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: Projects plugin — list and sidebar
type: feature
---

# Projects plugin — list and sidebar

ProjectsPlugin (id: "projects", icon: "view-grid-symbolic", section: SIDEBAR). ProjectsView with AdwNavigationSplitView. Sidebar (240px): GtkSearchEntry, New Project GtkButton (+), GtkListBox with AdwActionRow per project (icon, name, task count badge, completion %, "Active" status badge). Calls list_projects() tool on activate, refreshes on feature.* events. Displays project icon as AdwAvatar or colored square.