---
id: FEAT-HXU
kind: feature
priority: P1
project_slug: orchestra-web
status: backlog
title: Activity Log + Packs Grid + Storage Browser
type: feature
---

# Activity Log + Packs Grid + Storage Browser

Three utility pages for debugging, pack management, and .projects/ file browsing.

Activity page (`apps/web/src/pages/activity.tsx`):
- In-memory Zustand store `useActivityStore` tracking every mcp.callTool invocation
- Entry shape: {id, timestamp, method, toolName, durationMs, success, errorMessage}
- DataTable from @orchestra-mcp/widgets: columns [Time, Tool, Duration, Status]
- Badge from @orchestra-mcp/ui for success (green) / error (red)
- "Clear" Button at top right
- Auto-scroll to latest entry using useEffect
- Empty state: EmptyState from @orchestra-mcp/ui

Packs page (`apps/web/src/pages/packs.tsx`):
- Grid of installed packs via mcp.callTool("list_packs")
- Each card (Panel from @orchestra-mcp/ui): pack name, version Badge, description, counts: skills/agents/hooks as Badges
- Shimmer from @orchestra-mcp/ui during load

Storage page (`apps/web/src/pages/storage.tsx`):
- FileTree from @orchestra-mcp/explorer in left panel showing .projects/ directory
- FileNode type: name, path, type (file/directory), children
- Populate tree via mcp.callTool("list_notes") or storage list calls
- Right panel: file content preview using MarkdownRenderer from @orchestra-mcp/editor for .md files, CodeBlock from @orchestra-mcp/editor for other files
- Breadcrumb from @orchestra-mcp/ui showing current path

Acceptance: Activity log records tool calls with timing, Packs grid shows installed packs, Storage tree browses .projects/ with file preview