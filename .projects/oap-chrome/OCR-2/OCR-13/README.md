# OCR-13: Integrate TabService with existing editor and terminal tabs

**Type**: Story | **Status**: backlog | **Points**: 8

As a user, I want the existing editor TabBar and terminal session list to be powered by the new tab system, so that all tabbed content uses a unified API and I get a consistent experience.

## Acceptance Criteria

- [ ] Editor tabs (from packages/chrome-extension/src/sidepanel/editor/TabBar.tsx) migrated to use ITabService.openTab()
- [ ] Terminal sessions open as tabs via ITabService.openTab() with type='terminal'
- [ ] Diff views open as tabs via ITabService.openTab() with type='diff'
- [ ] Query result views open as tabs via ITabService.openTab() with type='query-result'
- [ ] Log viewer opens as a tab via ITabService.openTab() with type='log-viewer'
- [ ] All existing tab functionality (open file, close file, switch file) still works
- [ ] Old editor/TabBar.tsx component removed or adapted to delegate to new TabBar
