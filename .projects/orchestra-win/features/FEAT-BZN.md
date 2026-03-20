---
id: FEAT-BZN
kind: feature
priority: P1
project_slug: orchestra-win
status: backlog
title: Ctrl+K command palette — spotlight search
type: feature
---

# Ctrl+K command palette — spotlight search

Implement a global command palette triggered by `Ctrl+K` — searches projects, features, notes, docs, and MCP tools.

**`CommandPalette.xaml`** — modal `ContentDialog` or custom overlay:
- Centered, 640×480px max, `CornerRadius=12`, semi-transparent background
- `AutoSuggestBox` with immediate focus on open, real-time results
- Results grouped: Recent, Projects, Features, Notes, Actions
- Keyboard navigation: arrow keys, Enter to select, Escape to close

**Result types:**
- `ProjectResult` → navigate to project detail
- `FeatureResult` → navigate to project + scroll to feature
- `NoteResult` → open note in editor
- `ActionResult` → run MCP tool (e.g. "New Chat", "New Project", "Switch to Spirit Mode")

**`CommandPaletteService`** — registers `Ctrl+K` keyboard shortcut via `CoreWindow.KeyDown`, opens palette overlay above current content

**Search:** calls `search_features` (engine.rag), `search_notes`, `list_projects` locally from cache for instant results; debounces 150ms

**Platform:** Desktop, HoloLens