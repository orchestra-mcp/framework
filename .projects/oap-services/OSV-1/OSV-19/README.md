# OSV-19: Tray Menu Electron Integration & IPC Handlers

**Type**: Story | **Status**: done | **Points**: 3

As a developer, I want the TrayMenuService to integrate with Electron's native Tray API and expose IPC handlers so that renderer processes and extensions can interact with the tray menu.

## Acceptance Criteria

- [ ] Electron Tray nativeImage built from icon path or color
- [ ] Real-time icon color changes (green/yellow/red for service status)
- [ ] IPC handlers: tray:register, tray:update, tray:unregister, tray:getItems
- [ ] Hotkey registration via globalShortcut for items with hotkey field
- [ ] setupTrayHandlers/cleanupTrayHandlers exported from index.ts
- [ ] Integration test verifying Electron Tray.setContextMenu called on changes

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-63 | Implement Electron Tray integration with nativeImage icon builder | in_progress | task |
| OSV-64 | Implement IPC handlers for tray menu operations | backlog | task |
| OSV-65 | Write integration tests for Electron tray adapter and IPC handlers | backlog | task |
