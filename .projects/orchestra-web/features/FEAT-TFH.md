---
id: FEAT-TFH
kind: feature
priority: P0
project_slug: orchestra-web
status: backlog
title: Updated Sidebar + Routing (All Pages)
type: feature
---

# Updated Sidebar + Routing (All Pages)

Update the app shell sidebar and routing to include all pages discovered after initial planning. Expands FEAT-JXA with the full nav structure.

Update `apps/web/src/components/layout/sidebar.tsx`:
Replace the original 7 nav items with the full 13-item navigation:

Primary nav (top group):
1. Projects — bx-folder
2. Features — bx-git-branch
3. Chat — bx-chat (NEW)
4. Notes — bx-note (NEW)
5. Agents — bx-bot (NEW)
6. DevTools — bx-terminal (NEW)

Tools nav (second group, label "Tools"):
7. Tools Explorer — bx-wrench
8. Prompts — bx-message-square
9. Memory — bx-brain (NEW)

Workspace nav (third group, label "Workspace"):
10. Packs — bx-package
11. Docs — bx-book (NEW)
12. Storage — bx-hdd
13. Activity — bx-bar-chart

Bottom (always visible):
- Search button (Cmd+K hint) — bx-search (NEW)
- Settings — bx-cog (NEW)

Update `apps/web/src/App.tsx` — add all new routes:
- /chat → ChatListPage
- /chat/:id → ChatSessionPage
- /notes → NotesListPage
- /notes/:id → NoteEditorPage
- /agents → AgentsPage
- /devtools → DevToolsPage
- /memory → MemoryPage
- /docs → DocsIndexPage
- /docs/:slug → DocViewerPage
- /settings → SettingsPage

Update Zustand connection store to include gatewayUrl from localStorage so settings page can persist.

Acceptance: all 13 nav items render, all routes load correct pages, settings and search are accessible from sidebar bottom, active route highlights correctly