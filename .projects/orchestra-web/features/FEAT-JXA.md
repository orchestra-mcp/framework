---
id: FEAT-JXA
kind: feature
priority: P0
project_slug: orchestra-web
status: backlog
title: Theme Integration + App Shell + Navigation
type: feature
---

# Theme Integration + App Shell + Navigation

Dark theme from @orchestra-mcp/theme, app shell layout using @orchestra-mcp/ui components, and sidebar navigation with Orchestra branding.

Files:
- `apps/web/src/index.css` — import @orchestra-mcp/theme/styles; call initTheme() on load to apply orchestra dark theme CSS variables
- `apps/web/src/main.tsx` — ReactDOM.createRoot, wrap in ToasterProvider from @orchestra-mcp/ui, call initTheme('orchestra', 'default') before render

App shell (`apps/web/src/components/layout/app-shell.tsx`):
- Use Panel from @orchestra-mcp/ui as main container
- Flexbox layout: Sidebar (240px, fixed) + main content area (flex-1, overflow-auto)
- ConnectionStatus dot from @orchestra-mcp/tasks in top-right showing gateway connectivity
- React Router Outlet for page content

Sidebar (`apps/web/src/components/layout/sidebar.tsx`):
- Use Sidebar component from @orchestra-mcp/ui as base
- OrchestraLogo from @orchestra-mcp/icons at top
- 7 NavLink items using BoxIcon from @orchestra-mcp/icons for icons:
  1. Projects — bx-folder icon
  2. Features — bx-git-branch icon
  3. Tools — bx-wrench icon
  4. Prompts — bx-message-square icon
  5. Packs — bx-package icon
  6. Activity — bx-bar-chart icon
  7. Storage — bx-hdd icon
- Active state: accent background using theme CSS variable --color-accent
- Bottom: ConnectionStatusDot from @orchestra-mcp/tasks showing gateway status

Zustand stores (`apps/web/src/stores/`):
- connection.ts — State: {gatewayUrl, connected, error} | Actions: {setGatewayUrl, connect, disconnect}
- tools.ts — State: {tools[], loading, selectedTool, callResult, callError} | Actions: {fetchTools, callTool, selectTool, clearResult}
- prompts.ts — State: {prompts[], loading, selectedPrompt, runResult} | Actions: {fetchPrompts, runPrompt, selectPrompt}

App.tsx — BrowserRouter, Routes: / -> /projects redirect, /projects, /features, /tools, /prompts, /packs, /activity, /storage all wrapped in AppShell
main.tsx — ReactDOM.createRoot + providers

Acceptance: app loads with sidebar, theme CSS variables applied (dark background #0a0d14), all 7 routes render without error, connection dot shows status