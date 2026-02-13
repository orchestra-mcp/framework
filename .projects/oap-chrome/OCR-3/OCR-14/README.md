# OCR-14: Define TopBar, StatusBar, and Header registration interfaces

**Type**: Story | **Status**: backlog | **Points**: 3

As an extension developer, I want TypeScript interfaces for registering items into the top bar, status bar, and sidebar header, so that my extension can contribute UI elements to these global chrome areas.

## Acceptance Criteria

- [ ] TopBarItem interface at src/app/Chrome/Header/types.ts with id, component, position (left|center|right), order
- [ ] StatusBarItem interface at src/app/Chrome/Status/types.ts with id, text, icon, tooltip, alignment (left|right), order, onClick
- [ ] HeaderAction interface at src/app/Chrome/Header/types.ts with id, icon, label, onClick, order, sidebarId
- [ ] ITopBarService with registerTopBarItem/unregisterTopBarItem
- [ ] IStatusBarService with registerStatusBarItem/updateStatusBarItem/unregisterStatusBarItem
- [ ] IHeaderService with registerHeaderAction/unregisterHeaderAction
- [ ] All interfaces exported from their respective index.ts files
