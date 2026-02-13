# OSV-23: Migrate Existing Panel Services to Unified API

**Type**: Story | **Status**: backlog | **Points**: 5

As a developer, I want all existing panel services migrated to use IPanelManagerService so that the codebase is consistent and uses the new dynamic registration pattern.

## Acceptance Criteria

- [ ] timerPanelService migrated to PanelManagerService.registerPanel call
- [ ] calendarPanelService migrated to PanelManagerService.registerPanel call
- [ ] breakPanelService migrated to PanelManagerService.registerPanel call
- [ ] pomodoroPanelService migrated to PanelManagerService.registerPanel call
- [ ] settingsWindowService migrated to PanelManagerService.registerPanel call
- [ ] marketplaceWindowService migrated to PanelManagerService.registerPanel call
- [ ] All original panel services removed or deprecated
- [ ] No regressions in panel functionality
