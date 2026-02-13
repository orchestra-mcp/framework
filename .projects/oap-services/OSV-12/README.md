# OSV-12: Dynamic Widget Control Service

**Type**: Epic | **Status**: done | **Priority**: medium

Migrate widget management from widgetManagerService.ts + widgetRegistryService.ts + widgetExtensionApi.ts + widgetContextMenuService.ts + widgetThemeService.ts into src/app/Widgets/. Provides IWidgetControlService with registerWidget/showWidget/hideWidget/toggleWidget API. Multi-view support, theme integration, tray menu show/hide, state persistence, and widget events.

## Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| OSV-48 | IWidgetControlService Interface & Core Implementation | done | high |
| OSV-49 | Widget Theme Integration, Tray Menu & Documentation | done | medium |
