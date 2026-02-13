# OSV-18: ITrayMenuService Interface & Core Implementation

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want a typed ITrayMenuService interface and core implementation so that extensions can dynamically register, update, and unregister tray menu items at runtime using the Disposable pattern.

## Acceptance Criteria

- [ ] ITrayMenuService interface defined in src/app/Tray/ITrayMenuService.ts
- [ ] TrayMenuService class implements interface with register/update/unregister/onDidChange
- [ ] Every register() call returns a Disposable that removes the item on dispose()
- [ ] Debounced menu rebuild (100ms) on batch changes
- [ ] Group-based ordering with separators between groups
- [ ] Sub-menu support via parentId field
- [ ] Unit tests cover all public methods with >90% coverage

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-60 | Define ITrayMenuService interface and TrayMenuItem types | in_progress | task |
| OSV-61 | Implement TrayMenuService class with debounced rebuild | backlog | task |
| OSV-62 | Write unit tests for TrayMenuService | backlog | task |
