# OSV-26: Settings IPC Handlers & Cross-Process Sync

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want settings changes to propagate across main process and all renderer processes via IPC so that UI stays in sync when settings change.

## Acceptance Criteria

- [ ] IPC handlers: settings:get, settings:set, settings:getGroup, settings:getAll, settings:export, settings:import, settings:reset
- [ ] Settings changes broadcast to all BrowserWindows via webContents.send
- [ ] setupSettingsHandlers/cleanupSettingsHandlers exported from index.ts
- [ ] Import/export round-trips without data loss
- [ ] Reset to defaults works per-group and globally

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-82 | Implement Settings IPC handlers with cross-process broadcast | backlog | task |
| OSV-83 | Write tests for Settings IPC handlers and cross-process broadcast | backlog | task |
