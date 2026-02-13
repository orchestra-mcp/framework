# OSV-48: IWidgetControlService Interface & Core Implementation

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want a typed IWidgetControlService so that extensions can register, show, hide, and toggle widgets with state persistence and theme integration.

## Acceptance Criteria

- [ ] IWidgetControlService interface in src/app/Widgets/IWidgetControlService.ts
- [ ] WidgetControlService implements registerWidget/showWidget/hideWidget/toggleWidget/getRegisteredWidgets
- [ ] registerWidget returns Disposable
- [ ] Multi-view support per widget
- [ ] State persistence: position, size, visibility across restarts
- [ ] Widget events: onShow, onHide, onResize, onMove
- [ ] Unit tests for all public methods

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-136 | Define IWidgetControlService interface and widget types | backlog | task |
| OSV-137 | Implement WidgetControlService with state persistence | backlog | task |
| OSV-138 | Write unit tests for WidgetControlService | backlog | task |
