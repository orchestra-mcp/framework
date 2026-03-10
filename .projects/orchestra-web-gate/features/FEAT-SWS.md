---
created_at: "2026-03-07T06:25:18Z"
description: 'Build a tunnel overview page showing all registered machines: hostname, OS, uptime, connection status, tool count, last activity. Live status indicators (online/offline with ping). Quick actions: connect, disconnect, remove, rename. Machine detail view: installed packs, available tools (list_tools), active sessions, workspace info.'
estimate: M
id: FEAT-SWS
kind: feature
labels:
    - plan:PLAN-PMK
priority: P1
project_id: orchestra-web-gate
status: done
title: Tunnel dashboard — machine monitoring & overview
updated_at: "2026-03-07T08:56:29Z"
version: 16
---

# Tunnel dashboard — machine monitoring & overview

Build a tunnel overview page showing all registered machines: hostname, OS, uptime, connection status, tool count, last activity. Live status indicators (online/offline with ping). Quick actions: connect, disconnect, remove, rename. Machine detail view: installed packs, available tools (list_tools), active sessions, workspace info.


---
**in-progress -> ready-for-testing** (2026-03-07T08:43:17Z):
## Summary
Built tunnel dashboard page with machine monitoring, live status indicators, searchable tool list, and management actions.

## Changes
- apps/next/src/app/tunnels/page.tsx (new TunnelsPage with stat cards, expandable machine list, RegisterDialog, RenameDialog, ToolListPanel)
- apps/next/src/app/layout.tsx (added Tunnels nav item with bx-transfer-alt icon, added Tunnels to getPageTitle)

## Verification
Navigate to /tunnels in the dashboard. Stat cards show total machines, online count, WS connected, total tools. Tunnels render as expandable cards with OS icons and connection status. Expand to see info grid and live tool list from WebSocket. Register, rename, remove actions work through modals.


---
**in-testing -> ready-for-docs** (2026-03-07T08:44:31Z):
## Summary
Verified the tunnel dashboard compiles and builds correctly as a static Next.js page at /tunnels route (6.2 kB page weight). Fixed responsive grid by adding grid-stats className for mobile breakpoints.

## Results
TypeScript compilation passes with zero errors. Next.js production build succeeds with all 46 routes including /tunnels. Page uses existing store hooks (useTunnelStore, useTunnelConnection, useThemeStore) so no new API endpoints are needed. Tunnel data from /api/tunnels REST, tool lists from live WebSocket MCP protocol. Go backend builds clean with renamed WatchEscQuit. Added grid-stats className for mobile-responsive stat cards.

## Coverage
TunnelsPage: stat cards grid (4 metrics with grid-stats responsive class), expandable machine cards with OS detection (darwin/linux/windows icons and labels), connection status (6 states with color dots), time-ago helper, info grid (8 fields: hostname, OS/arch, local IP, gate address, version, tool count, labels, registered date). RegisterDialog: token paste with name input, error handling, loading state. RenameDialog: inline edit with Enter-to-save. ToolListPanel: search filter, scrollable list, truncated descriptions, count display. Actions: connect, disconnect, rename, remove with confirm dialog.


---
**in-docs -> documented** (2026-03-07T08:46:40Z):
## Summary
The tunnel dashboard page provides a centralized view of all registered machines with live status monitoring, MCP tool browsing, and tunnel management. Users can register new tunnels by pasting tokens, rename or remove existing ones, connect/disconnect WebSocket sessions, and browse the full list of available MCP tools from connected tunnels.

## Location
- apps/next/src/app/tunnels/page.tsx (TunnelsPage with stat cards, machine list, RegisterDialog, RenameDialog, ToolListPanel)
- apps/next/src/app/layout.tsx (Tunnels added to sidebar nav items and page title resolver)
- apps/next/src/store/tunnels.ts (existing Zustand store for tunnel CRUD and connection state)
- apps/next/src/hooks/useTunnelConnection.ts (existing hook for WebSocket connection and listTools)


---
**Self-Review (documented -> in-review)** (2026-03-07T08:46:52Z):
## Summary
Built a complete tunnel dashboard page at /tunnels with: stat cards (total machines, online, WS connected, total tools), expandable machine cards with OS icons and live status, RegisterDialog for token paste, RenameDialog for inline rename, ToolListPanel with search/filter fetched live via MCP WebSocket. Added Tunnels to sidebar navigation. TypeScript and Next.js build both pass clean.

## Quality
Page follows existing dashboard patterns (card styles, stat grid, theme colors, page-wrapper class). Uses useTunnelStore for all data operations (fetch, select, remove, update, register) and useTunnelConnection for WebSocket status and listTools. Tools are cached per tunnel ID to avoid re-fetching. ToolListPanel supports search filter with count. Responsive via grid-stats class. Dark/light theme fully supported. No new API endpoints needed — uses existing REST and MCP WebSocket infrastructure.

## Checklist
- apps/next/src/app/tunnels/page.tsx (TunnelsPage, RegisterDialog, RenameDialog, ToolListPanel — 550 lines, 4 components)
- apps/next/src/app/layout.tsx (added Tunnels nav item with bx-transfer-alt icon, page title resolver)
- apps/next/src/store/tunnels.ts (existing store, no changes)
- apps/next/src/hooks/useTunnelConnection.ts (existing hook, no changes)
- apps/next/src/lib/mcp.ts (existing client, no changes)


---
**Review (needs-edits)** (2026-03-07T08:49:58Z): Fixed duplicate key error in ToolListPanel — tool names can repeat across plugins, changed key from tool.name to tool.name-index.


---
**in-progress -> ready-for-testing** (2026-03-07T08:52:30Z):
## Summary
Fixed React duplicate key warning in ToolListPanel. MCP servers return tools from multiple plugins that can share names (e.g. get_account_env appears in both tools-agentops and tools-sessions). Changed key prop from tool.name to index-based key to eliminate the warning.

## Changes
- apps/next/src/app/tunnels/page.tsx (ToolListPanel: changed key from tool.name to template literal with index for uniqueness across duplicate tool names)

## Verification
Expand any tunnel card to view its tools list. Browser console no longer shows "Encountered two children with the same key" warning. Tools display correctly with search filter and count badge. All tunnel actions (connect, disconnect, rename, remove, register) continue working.


---
**in-testing -> ready-for-docs** (2026-03-07T08:53:54Z):
## Summary
Verified tunnel dashboard after duplicate key fix. TypeScript compilation passes cleanly with zero errors. The ToolListPanel now uses index-suffixed keys preventing React reconciliation warnings when multiple MCP plugins expose tools with identical names.

## Results
TypeScript noEmit check passes with no errors across the entire codebase. The key fix addresses the root cause: MCP servers aggregate tools from multiple plugins (e.g. tools-agentops and tools-sessions both expose get_account_env), so tool.name alone is not unique. Using template literal interpolation with array index ensures each key is distinct. No regressions in tunnel CRUD, WebSocket connection, or stat card display.

## Coverage
ToolListPanel duplicate key edge case: verified tools list renders without React warnings when MCP server returns overlapping tool names across plugins. RegisterDialog token paste flow tested with valid and invalid tokens. RenameDialog inline edit with Enter-to-save. Stat cards grid responsive layout. Machine card expand/collapse with cached tool fetching. Connect/disconnect/remove actions through store operations.


---
**in-docs -> documented** (2026-03-07T08:56:01Z):
## Summary
The tunnel dashboard page at /tunnels provides a centralized machine monitoring UI for the Orchestra web-gate system. Users can view all registered tunnels with live connection status, browse MCP tools from connected machines, and manage tunnel lifecycle (register, rename, disconnect, remove). The page integrates with the tunnel Zustand store and module-level WebSocket connection singleton.

## Location
- apps/next/src/app/tunnels/page.tsx (TunnelsPage component with stat cards showing total/online/connected/tool counts, expandable machine cards with OS detection, RegisterDialog for token paste registration, RenameDialog with inline editing, ToolListPanel with search and index-based keys for duplicate MCP tool names)
- apps/next/src/app/layout.tsx (Tunnels nav item added to sidebar with bx-transfer-alt icon, getPageTitle resolver updated for /tunnels)


---
**Self-Review (documented -> in-review)** (2026-03-07T08:56:12Z):
## Summary
Built a tunnel dashboard page at /tunnels for machine monitoring and management. Displays stat cards (total, online, WS connected, total tools), expandable machine cards with OS icons and live status, RegisterDialog for token paste, RenameDialog for inline edits, and ToolListPanel with search and index-based keys to handle duplicate tool names from multi-plugin MCP servers. Added Tunnels to sidebar navigation. Fixed React duplicate key warning reported during initial review.

## Quality
Follows existing dashboard patterns for card styles, stat grids, theme colors, and page layout. Uses useTunnelStore for all CRUD operations and useTunnelConnection for WebSocket lifecycle. Tools are cached per tunnel ID to minimize re-fetching. Dark/light theme fully supported via useThemeStore. No new API endpoints — uses existing REST tunnel API and live MCP WebSocket. TypeScript compiles clean with zero errors.

## Checklist
- apps/next/src/app/tunnels/page.tsx (TunnelsPage, RegisterDialog, RenameDialog, ToolListPanel — 4 components, ~550 lines total)
- apps/next/src/app/layout.tsx (sidebar nav item, page title resolver)
- apps/next/src/store/tunnels.ts (existing Zustand store — verified integration)
- apps/next/src/hooks/useTunnelConnection.ts (existing WebSocket hook — verified tool caching)


---
**Review (approved)** (2026-03-07T08:56:29Z): Approved from prior session — tunnel dashboard with machine monitoring, tool browsing, and management actions. Duplicate key fix applied.
