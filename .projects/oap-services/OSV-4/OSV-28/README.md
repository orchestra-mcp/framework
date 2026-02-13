# OSV-28: IThemeService Interface & Core Theme Engine

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want a typed IThemeService so that extensions can register custom themes and the IDE can switch between them with CSS custom properties injected everywhere.

## Acceptance Criteria

- [ ] IThemeService interface in src/app/Themes/IThemeService.ts
- [ ] ThemeService implements registerTheme/setActiveTheme/getActiveTheme/getAvailableThemes/onDidChangeTheme
- [ ] registerTheme returns Disposable
- [ ] Built-in light and dark themes registered on startup
- [ ] CSS custom properties map generated from ThemeDefinition.colors
- [ ] Active theme persisted in settings across restarts
- [ ] Unit tests for theme registration, switching, and event firing

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-86 | Define IThemeService interface and ThemeDefinition types | backlog | task |
| OSV-87 | Implement ThemeService with built-in light and dark themes | backlog | task |
| OSV-88 | Write unit tests for ThemeService | backlog | task |
