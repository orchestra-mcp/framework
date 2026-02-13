# OSV-25: ISettingsService Interface & Storage Engine

**Type**: Story | **Status**: done | **Points**: 8

As a developer, I want a typed ISettingsService interface with JSON storage so that extensions can register settings groups and individual settings with validation, defaults, and atomic writes.

## Acceptance Criteria

- [ ] ISettingsService interface in src/app/Settings/ISettingsService.ts
- [ ] SettingsService implements registerGroup/registerSetting/get/set/onDidChange/exportSettings/importSettings
- [ ] registerGroup and registerSetting return Disposable
- [ ] Local JSON storage with atomic writes (write to temp, rename)
- [ ] Validation functions run on set(), reject invalid values
- [ ] onDidChange fires per-key callbacks and cross-process IPC broadcasts
- [ ] Unit tests for all methods including validation edge cases

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-79 | Define ISettingsService interface, SettingsGroup, and SettingDefinition types | backlog | task |
| OSV-80 | Implement SettingsService with JSON storage and atomic writes | backlog | task |
| OSV-81 | Write unit tests for SettingsService | backlog | task |
