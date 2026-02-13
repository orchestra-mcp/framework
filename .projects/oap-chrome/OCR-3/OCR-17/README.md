# OCR-17: Build SidebarHeader component with per-panel action buttons

**Type**: Story | **Status**: backlog | **Points**: 3

As a user, I want each sidebar panel to have a header bar showing the panel label and action buttons (like refresh, add, filter), so that I have contextual actions available for the currently active panel.

## Acceptance Criteria

- [ ] SidebarHeader component at src/app/Chrome/Header/SidebarHeader.tsx renders header for active sidebar panel
- [ ] Header label auto-set from the active SidebarEntry.label
- [ ] Action buttons rendered from headerStore filtered by active sidebarId
- [ ] HeaderStore at src/app/Chrome/Header/headerStore.ts manages per-sidebar action registrations
- [ ] Action buttons rendered as icon buttons with tooltips
- [ ] Header only renders when a sidebar entry is active
- [ ] Header height is 32px with consistent padding and border-bottom
