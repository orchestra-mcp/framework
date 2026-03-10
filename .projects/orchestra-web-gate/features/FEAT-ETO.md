---
created_at: "2026-03-09T02:14:41Z"
description: |-
    Restructure the dashboard from 2-panel (sidebar + content) to 3-panel layout:
    1. **Icon Rail** (left, ~56px): Vertical icon-only navigation controlling which section is shown in the sidebar
    2. **Sidebar** (~280px): Shows CRUD list items for the selected section (projects list, notes list, plans list, etc.)
    3. **Content Area** (remaining): Preview/detail of the selected item

    Navigation items: Dashboard, Projects, Notes, Plans, Tunnels, Chat + Admin section.
    Clicking an icon in the rail switches the sidebar content. Clicking a list item opens the detail/preview.
id: FEAT-ETO
kind: feature
priority: P1
project_id: orchestra-web-gate
status: in-review
title: '3-Panel Dashboard Layout: Icon Rail + Sidebar List + Content Preview'
updated_at: "2026-03-09T02:43:39Z"
version: 9
---

# 3-Panel Dashboard Layout: Icon Rail + Sidebar List + Content Preview

Restructure the dashboard from 2-panel (sidebar + content) to 3-panel layout:
1. **Icon Rail** (left, ~56px): Vertical icon-only navigation controlling which section is shown in the sidebar
2. **Sidebar** (~280px): Shows CRUD list items for the selected section (projects list, notes list, plans list, etc.)
3. **Content Area** (remaining): Preview/detail of the selected item

Navigation items: Dashboard, Projects, Notes, Plans, Tunnels, Chat + Admin section.
Clicking an icon in the rail switches the sidebar content. Clicking a list item opens the detail/preview.


---
**in-progress -> in-testing** (2026-03-09T02:24:25Z):
## Changes
- apps/next/src/app/(app)/layout.tsx (major restructure — 3-panel layout)
  - Replaced 2-panel sidebar+content with 3-panel: icon rail (56px) + sidebar panel (260px) + content area
  - Icon rail: fixed 56px column with logo, nav icons (active indicator bar), admin icon, sidebar toggle, user avatar dropdown
  - Sidebar panel: 260px collapsible panel with workspace switcher (or admin title), contextual nav links, tunnel status indicator
  - Content area: margin adjusts from 56px (collapsed) to 316px (expanded) with smooth transition
  - User dropdown moved from header to icon rail bottom (opens to the right)
  - Removed duplicate tunnel indicator from header (now in sidebar panel bottom)
  - Removed divider + user dropdown from header (moved to icon rail)
  - Admin sub-nav items show in sidebar panel when on /admin routes
- apps/next/src/app/globals.css (mobile responsive + icon rail styles)
  - Added .icon-rail-btn hover effect
  - Updated mobile breakpoint: .app-icon-rail + .app-sidebar-panel replace old .app-sidebar
  - Both slide out on mobile, slide in with .open class
  - Updated RTL rules for new class names (translateX direction flip)
- apps/next/src/app/(app)/settings/page.tsx (pre-existing lint fix)
  - Changed `<a href="/settings/two-factor">` to `<Link href="/settings/two-factor">` to fix build error
  - Added `import Link from 'next/link'`


---
**in-testing -> in-docs** (2026-03-09T02:28:55Z):
## Results
- apps/next/src/__tests__/three-panel-layout.test.ts (33 tests — layout structure, icon rail nav, sidebar panel, mobile responsive, RTL, hover styling, header cleanup)
- apps/next/src/__tests__/i18n-polish.test.ts (27 tests — updated RTL sidebar reference from .app-sidebar to .app-icon-rail)
- All 60 tests pass, 0 failures


---
**in-docs -> in-review** (2026-03-09T02:29:24Z):
## Docs
- docs/three-panel-layout.md (new — layout structure, icon rail, sidebar panel, collapse, mobile, RTL, CSS classes)


---
**Review (needs-edits)** (2026-03-09T02:32:03Z): User feedback: 1) Not supporting mobile view properly 2) Sidebar panel doesn't show a list of items (CRUD list) 3) Pages without lists (like dashboard) should not show the sidebar panel — sidebar should only appear when the page has a list to display


---
**in-progress -> in-testing** (2026-03-09T02:42:33Z):
## Changes
- layout.tsx (sidebar CRUD lists, hasSidebar, mobile hamburger)
- i18n-polish.test.ts (RTL sidebar reference fix)


---
**in-testing -> in-docs** (2026-03-09T02:43:01Z):
## Results
- three-panel-layout.test.ts (41 tests — added 8 new tests for sidebar CRUD lists, hasSidebar, activeSection, MCP parsers, SidebarListPanel, useMCP, sidebarSearch)
- i18n-polish.test.ts (27 tests — all passing)
- All 68 tests pass, 0 failures
- Build passes with 0 errors


---
**in-docs -> in-review** (2026-03-09T02:43:39Z):
## Docs
- docs/three-panel-layout.md (updated — added contextual CRUD lists section, pages without sidebar, data flow diagram, MCP parser docs)
