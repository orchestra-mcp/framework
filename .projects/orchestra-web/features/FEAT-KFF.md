---
id: FEAT-KFF
kind: feature
priority: P1
project_slug: orchestra-web
status: backlog
title: Search Spotlight + Command Palette
type: feature
---

# Search Spotlight + Command Palette

Global search and command palette using SearchSpotlight from @orchestra-mcp/search — accessible from any page via Cmd+K keyboard shortcut.

File: `apps/web/src/components/search/spotlight.tsx`

Implementation:
- SearchSpotlight from @orchestra-mcp/search as the core component
- Triggered by: Cmd+K / Ctrl+K global keyboard shortcut (useEffect on keydown)
- Modal overlay using Modal from @orchestra-mcp/ui as backdrop

Search categories (SearchCategory types from @orchestra-mcp/search):
1. Projects — mcp.callTool("list_projects") filtered by query
2. Features — mcp.callTool("search_features", {query}) across all projects
3. Notes — mcp.callTool("list_notes") filtered by title/content
4. Tools — filter already-loaded toolsStore.tools by name/description
5. Prompts — filter already-loaded prompts by name
6. Commands — static list: Go to Projects, Go to Chat, Go to DevTools, New Feature, New Note, New Chat

Each SearchResult: title, subtitle, category, icon (BoxIcon), action (navigation or MCP call)

Result selection:
- Arrow keys navigate, Enter executes
- Navigation results: router.push(path)
- Action results: mcp.callTool(...) then toast success

Integration into AppShell:
- Render <Spotlight> at root of AppShell (always mounted)
- "Search" item in sidebar with Cmd+K hint label
- SearchSpotlight trigger button in sidebar header area

Acceptance: Cmd+K opens spotlight, typing searches all categories, arrow keys navigate, Enter executes, Escape closes