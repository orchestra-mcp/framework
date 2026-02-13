# OSV-1: Dynamic Tray Menu Service

**Type**: Epic | **Status**: done | **Priority**: high

Extract and wrap tray menu functionality from packages/desktop/src/main/services/trayService.ts + menuContributionService.ts into src/app/Tray/ with ITrayMenuService dynamic registration API. Supports real-time icon updates, debounced menu rebuild, group-based ordering, sub-menus, and Disposable pattern.

## Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| OSV-18 | ITrayMenuService Interface & Core Implementation | done | high |
| OSV-19 | Tray Menu Electron Integration & IPC Handlers | done | high |
| OSV-20 | Tray Menu Documentation & Migration Guide | done | medium |
