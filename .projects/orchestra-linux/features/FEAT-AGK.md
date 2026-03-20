---
id: FEAT-AGK
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: File explorer with GtkTreeListModel
type: feature
---

# File explorer with GtkTreeListModel

File Explorer sub-tool. Left panel: GtkTreeListModel + GtkListView for directory tree. Start from workspace root (last-opened path from GSettings). Lazy-expand directories on row activation. File icons from Gio.content_type_get_symbolic_icon(). Right panel: GtkSourceView for file preview/editing with full syntax highlighting (14 languages via GtkSource.LanguageManager). Toolbar: new file, new folder, rename, delete, refresh. Path breadcrumb using GtkLabel chain. Calls devtools.file-explorer tools: list_directory, read_file, write_file, move_file, delete_file, file_info, file_search.