# 3-Panel Dashboard Layout

## Overview

The dashboard uses a 3-panel layout inspired by VS Code and Linear:

```
┌──────────┬──────────────────┬──────────────────────────┐
│ Icon Rail│  Sidebar Panel   │     Content Area         │
│  (56px)  │    (260px)       │     (remaining)          │
│          │                  │                          │
│  [Logo]  │ WorkspaceSwitcher│                          │
│  [Nav]   │ Section Header   │                          │
│  [Nav]   │ [Search...]      │    Page Content          │
│  [Nav]   │ Item 1           │                          │
│          │ Item 2           │                          │
│ [Toggle] │ Item 3           │                          │
│ [Avatar] │ Tunnel Status    │                          │
└──────────┴──────────────────┴──────────────────────────┘
```

## Icon Rail (56px)

Fixed vertical strip on the inline-start edge. Contains:

- **Logo** (top) — Orchestra logo linking to `/dashboard`
- **Nav icons** — Icon-only buttons with tooltips, active indicator bar (purple `#a900ff`)
- **Admin icon** — Shield icon, visible only to users with `canViewAdmin` permission
- **Sidebar toggle** — Collapses/expands the sidebar panel
- **User avatar** — Dropdown menu at the bottom (sign out, profile)

Background: `#0d0b11` (dark, distinct from sidebar panel).

## Sidebar Panel (260px, collapsible)

Positioned after the icon rail at `insetInlineStart: 56px`. Hidden when sidebar is collapsed.

### Contextual CRUD Lists

The sidebar panel shows a **list of items** based on the active route:

| Route | Content | Data Source |
|-------|---------|-------------|
| `/projects` | Project list with name, description | MCP `list_projects` |
| `/notes` | Notes list, pinned first, with tags | MCP `list_notes` |
| `/plans` | Plans with status dot and feature count | MCP `list_plans` |
| `/tunnels` | Tunnels with status, OS, tool count | `useTunnelStore` |
| `/admin/*` | Admin sub-navigation links | Static list |

Each section includes:
- Section header with icon and "+" button
- Search/filter input (except tunnels)
- Scrollable item list with hover/active states
- Loading skeleton shimmer during fetch

### Pages Without Sidebar

These pages show **only the icon rail** (no sidebar panel):
- `/dashboard` — overview page
- `/chat` — has own session management
- `/settings` — has own sidebar navigation
- `/subscription` — single page
- `/notifications` — single page

### Admin Mode

On `/admin/*` routes, shows "Administration" header and admin sub-navigation items instead of CRUD lists.

### Bottom

Tunnel status indicator with colored dot.

## Content Area

Main page content with `marginInlineStart`:
- `316px` when sidebar expanded (56 + 260)
- `56px` when sidebar collapsed or on pages without sidebar

## Collapse Behavior

- `sidebarCollapsed` state stored in `usePreferencesStore`
- Collapsed: only icon rail visible (56px), sidebar panel hidden
- Expanded: both visible (56 + 260 = 316px)

## Mobile Responsive

Below `768px`:
- Both icon rail and sidebar panel slide off-screen via `translateX(-100%)`
- Hamburger menu button appears in the header
- `.open` class slides panels back in with `translateX(0)`
- Content area has `margin-inline-start: 0`

## RTL Support

All layout uses CSS logical properties (`insetInlineStart`, `marginInlineStart`).

Mobile transforms flip direction for RTL:
- `[dir="rtl"] .app-icon-rail` uses `translateX(100%)` instead of `translateX(-100%)`
- `[dir="rtl"] .app-sidebar-panel` uses `translateX(100%)`

## Data Flow

```
useMCP() → callTool('list_*') → parseMCP*() → sidebarItems state → SidebarListPanel
useTunnelStore() → tunnels array → SidebarListPanel (tunnels section)
```

MCP responses are markdown tables/lists parsed by `parseMCPProjects`, `parseMCPNotes`, `parseMCPPlans`.

## CSS Classes

| Class | Element |
|-------|---------|
| `.app-icon-rail` | Icon rail container |
| `.app-sidebar-panel` | Sidebar panel container |
| `.app-main` | Content area |
| `.icon-rail-btn` | Icon button in the rail |
| `.app-sidebar-collapse` | Collapse toggle button |
| `.app-hamburger` | Mobile hamburger button |

## Key Files

- `src/app/(app)/layout.tsx` — Layout implementation with sidebar CRUD lists
- `src/app/globals.css` — Mobile responsive and RTL rules
- `src/__tests__/three-panel-layout.test.ts` — 41 test cases
