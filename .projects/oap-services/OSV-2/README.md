# OSV-2: Dynamic Panel Manager Service

**Type**: Epic | **Status**: backlog | **Priority**: high

Unify 6 panel services (timerPanelService, calendarPanelService, breakPanelService, pomodoroPanelService, settingsWindowService, marketplaceWindowService) into a single IPanelManagerService at src/app/Panels/. Provides registerPanel/openPanel/closePanel/togglePanel API with auto tray menu integration, theme injection, state persistence, and IPC bridge auto-setup.
