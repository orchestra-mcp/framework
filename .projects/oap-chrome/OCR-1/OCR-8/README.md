# OCR-8: Build SidebarIconRail and SidebarContent React components

**Type**: Story | **Status**: backlog | **Points**: 5

As a user, I want to see a vertical icon rail on the left side of the sidebar that shows registered extension icons with badges and highlights the active panel, so that I can navigate between different sidebar views.

## Acceptance Criteria

- [ ] SidebarIconRail component at src/app/Chrome/Sidebar/SidebarIconRail.tsx renders entries from sidebarStore
- [ ] Icons sorted by order field
- [ ] Active entry highlighted with accent indicator bar (matching current ActivityItem style)
- [ ] Badge rendering for entries with badge values
- [ ] SidebarContent component at src/app/Chrome/Sidebar/SidebarContent.tsx lazy-loads registered content components
- [ ] Content panels preserved in DOM when switching (not unmounted)
- [ ] Connection indicator dot at bottom of rail
- [ ] Visual style matches existing App.tsx ActivityItem styling
