# OSV-3: Dynamic Settings Service

**Type**: Epic | **Status**: done | **Priority**: high

Extract settings management from packages/desktop/src/main/services/settingsService.ts + settingsWindowService.ts + settings-renderer.ts into src/app/Settings/. Provides ISettingsService with registerGroup/registerSetting/get/set/onDidChange API. Settings UI auto-generated from schema, local JSON storage with atomic writes, import/export, and cross-process propagation via IPC.

## Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| OSV-25 | ISettingsService Interface & Storage Engine | done | high |
| OSV-26 | Settings IPC Handlers & Cross-Process Sync | done | high |
| OSV-27 | Settings Search & Documentation | done | medium |
