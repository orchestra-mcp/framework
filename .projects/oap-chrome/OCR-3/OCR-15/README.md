# OCR-15: Build TopBar component with breadcrumbs and global actions

**Type**: Story | **Status**: backlog | **Points**: 5

As a user, I want a top bar above the sidebar content that shows breadcrumb navigation and global action buttons registered by extensions, so that I have context about where I am and quick access to common actions.

## Acceptance Criteria

- [ ] TopBar component at src/app/Chrome/Header/TopBar.tsx renders items from a topBarStore
- [ ] Items sorted by position (left, center, right) then by order
- [ ] Breadcrumb navigation shows current workspace > active sidebar panel
- [ ] TopBarStore at src/app/Chrome/Header/topBarStore.ts manages registrations
- [ ] TopBar height is 28px matching the existing status bar height aesthetic
- [ ] TopBar only renders when at least one item is registered
- [ ] Responsive: items truncate or hide on narrow widths
