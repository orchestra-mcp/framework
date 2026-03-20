---
id: FEAT-RQU
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: Projects plugin — detail view and workflow states
type: feature
---

# Projects plugin — detail view and workflow states

ProjectDetailView (AdwNavigationPage). Header: project icon (AdwAvatar), name (GtkLabel large), description. Status AdwPreferencesGroup: Total Tasks, Completed, Completion % with GtkLevelBar (purple, animated fill). Status breakdown AdwPreferencesGroup per workflow state with count badges. BacklogTree: GtkTreeListModel with GtkColumnView showing collapsible epics → stories → tasks. WorkflowState enum (13 states) with to_label() and CSS class helpers. State badge colors: backlog=dim, todo=accent, in-progress=purple, done=success, blocked=error.