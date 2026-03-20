---
id: FEAT-PMZ
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: Ctrl+K command palette search
type: feature
---

# Ctrl+K command palette search

Global search overlay triggered by Ctrl+K (app.search action). AdwDialog containing GtkSearchEntry + GtkScrolledWindow with GtkListBox results. Search across: projects (list_projects), features (search_features), notes (search_notes), docs (doc_search), files (search via engine-rag). Results grouped by type with icons. Keyboard navigation: Up/Down arrows, Enter to open. Escape to close. Result rows show type icon, title, subtitle (project/status/path). Debounce input 150ms.