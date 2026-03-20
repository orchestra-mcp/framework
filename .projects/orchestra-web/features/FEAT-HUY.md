---
id: FEAT-HUY
kind: feature
priority: P1
project_slug: orchestra-web
status: backlog
title: Notes Page (Rich Markdown Editor)
type: feature
---

# Notes Page (Rich Markdown Editor)

Notes list and rich markdown editor reusing @orchestra-mcp/editor components, backed by plugin-tools-notes MCP tools.

Files:
- `apps/web/src/pages/notes.tsx` — notes list
- `apps/web/src/pages/notes/[id].tsx` — note editor

Notes list (`notes.tsx`):
- Grid of note cards using Panel from @orchestra-mcp/ui
- Each card: title, tags as Badges, truncated preview, icon + color
- Pinned notes section at top (pinned: true from list_notes)
- "New Note" Button → create via mcp.callTool("create_note")
- Search/filter Input at top
- Loads via mcp.callTool("list_notes")
- Skeleton from @orchestra-mcp/ui during load
- Click → navigate to /notes/:id

Note editor (`notes/[id].tsx`):
- Two-panel layout: metadata sidebar (left 280px) + editor (right, flex-1)
- Editor: MarkdownEditor from @orchestra-mcp/editor (full rich markdown with toolbar)
- Auto-save on change with 1s debounce via mcp.callTool("update_note")
- Metadata sidebar:
  - Title Input (auto-saves)
  - Tags: inline editable tag chips using Badge from @orchestra-mcp/ui + Input for new tag
  - Icon selector: emoji/icon picker (color-coded)
  - Color picker for note accent color
  - Pin toggle Button
  - Delete Button with confirmation Modal from @orchestra-mcp/ui
- Top toolbar: "Preview" toggle to switch MarkdownEditor → MarkdownRenderer
- useToaster from @orchestra-mcp/ui for save confirmations

Zustand store (`apps/web/src/stores/notes.ts`):
- State: {notes[], currentNote, saving, searchQuery}
- Actions: {fetchNotes, createNote, updateNote, deleteNote, setSearch, pinNote}

Acceptance: notes list loads with pinned section, new note creates, editor auto-saves with debounce, tags editable, preview toggle works