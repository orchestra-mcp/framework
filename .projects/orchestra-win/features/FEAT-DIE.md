---
id: FEAT-DIE
kind: feature
priority: P1
project_slug: orchestra-win
status: backlog
title: Notes plugin — list, editor, pin/tag
type: feature
---

# Notes plugin — list, editor, pin/tag

Implement `Orchestra.Desktop/Plugins/NotesPlugin/` — note-taking with markdown and tags.

**`NotesPage.xaml`** — two-column layout:
- Left: `NotesSidebar` (280px) — `AutoSuggestBox` search, "+ New Note" button, `Expander` "Pinned Notes", `Expander` "All Notes", each containing `ListView` of note rows (icon, title, date, tag chips)
- Right: `NoteEditor` — `CommandBar` (back, pin toggle, save, delete), borderless large `TextBox` title, tag `ItemsRepeater` (add/remove chips via `AutoSuggestBox`), monospace `TextBox` content body (AcceptsReturn, markdown raw)

**`MarkdownPreview`** — `WebView2` control that calls `md_render_html` MCP tool and injects result into themed HTML wrapper (dark bg, Cascadia Code mono, purple links)

**Toggle:** editor/preview split via `GridSplitter`

**MCP tools called:** `create_note`, `get_note`, `update_note`, `delete_note`, `list_notes`, `search_notes`, `pin_note`, `tag_note`, `md_render_html`, `md_toc`

**Platform:** Desktop, HoloLens