# OCR-11: Build TabBar component with drag-and-drop and overflow

**Type**: Story | **Status**: backlog | **Points**: 8

As a user, I want a tab bar that shows my open tabs with drag-and-drop reordering, close buttons, and overflow handling, so that I can efficiently manage multiple open views.

## Acceptance Criteria

- [ ] TabBar component at src/app/Chrome/Tabs/TabBar.tsx renders open tabs from tabStore
- [ ] Each tab shows label, optional icon, and close button (if closable)
- [ ] Active tab visually highlighted
- [ ] Drag-and-drop reordering works via HTML5 drag events (no external library)
- [ ] Overflow handling: horizontal scroll with left/right arrows when tabs exceed width
- [ ] Tab context menu on right-click: Close, Close Others, Close All, Split Right, Split Down
- [ ] Double-click on empty tab bar area opens a new tab (if supported)
- [ ] Tab dirty indicator (dot) for unsaved content
