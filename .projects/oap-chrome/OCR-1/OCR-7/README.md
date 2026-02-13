# OCR-7: Build SidebarService and SidebarStore for dynamic registration

**Type**: Story | **Status**: backlog | **Points**: 5

As the Chrome sidebar shell, I want a service and Zustand store that manages registered sidebar entries and content, so that extensions can dynamically add/remove sidebar icons and their content panels at runtime.

## Acceptance Criteria

- [ ] SidebarService class at src/app/Chrome/Sidebar/SidebarService.ts implements IChromeSidebarService
- [ ] Zustand store at src/app/Chrome/Sidebar/sidebarStore.ts manages entries, active panel, and content registrations
- [ ] registerSidebarEntry() adds entry and triggers re-render
- [ ] unregisterSidebarEntry() removes entry cleanly
- [ ] registerContent() associates a React component with a sidebar entry
- [ ] Badge updates via updateBadge(sidebarId, badge) work reactively
- [ ] Active panel state persists when switching between panels
