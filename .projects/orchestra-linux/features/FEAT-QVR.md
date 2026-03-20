---
id: FEAT-QVR
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: Notes plugin — list, editor, pin/tag
type: feature
---

# Notes plugin — list, editor, pin/tag

NotesPlugin (id: "notes", icon: "accessories-text-editor-symbolic", section: SIDEBAR). NotesView with AdwNavigationSplitView. Sidebar (240px): GtkSearchEntry, New Note (+) button, Pinned Notes GtkListBox section, Other Notes GtkListBox section. Each row: AdwActionRow (title, date, tags). NoteEditor: AdwHeaderBar (back, pin toggle, save, delete actions), GtkEntry for title (large, borderless), GtkFlowBox for tags (add/remove), GtkSourceView for content (monospace, markdown language, orchestra-dark scheme). Calls: create_note, get_note, update_note, list_notes, search_notes, pin_note, tag_note tools.