---
id: FEAT-WVX
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: Feature/task creation and management UI
type: feature
---

# Feature/task creation and management UI

AdwDialog for creating features: title input, type selector (epic/story/task/bug), priority (P0-P3), description GtkTextView. Inline feature detail popover: title, status AdwComboRow, priority AdwComboRow, assignee, labels, description editor. Advance workflow button with evidence GtkTextView. Calls create_feature(), advance_feature(), set_current_feature() tools. Shows blocked features with dependency list via get_blocked_features() and get_dependency_graph().