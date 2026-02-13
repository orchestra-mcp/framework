# OSV-21: IPanelManagerService Interface & Core Implementation

**Type**: Story | **Status**: backlog | **Points**: 8

As a developer, I want a unified IPanelManagerService so that extensions can register panels with a single API instead of creating separate BrowserWindow services for each panel type.

## Acceptance Criteria

- [ ] IPanelManagerService interface defined in src/app/Panels/IPanelManagerService.ts
- [ ] PanelManagerService implements registerPanel/openPanel/closePanel/togglePanel/isPanelOpen
- [ ] registerPanel returns Disposable
- [ ] Singleton panels: only one BrowserWindow per panel ID
- [ ] Panel state persistence (position, size) via electron-store or JSON file
- [ ] onPanelOpened/onPanelClosed events fire correctly
- [ ] Unit tests for all public methods
