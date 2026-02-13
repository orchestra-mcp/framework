# ODS-9: Build theme engine with CSS custom properties

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want a theme engine that uses CSS custom properties so that themes can be switched dynamically at runtime without page reloads.

## Acceptance Criteria

- [x] Theme engine class with setTheme(), getTheme(), and subscribeToTheme()
- [x] CSS custom properties with --mt- prefix generated for all tokens
- [x] Theme switching works without page reload
- [x] localStorage persistence for theme preference
- [x] System theme detection (light/dark) implemented

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| ODS-19 | Create ThemeEngine class with core functionality | done | task |
| ODS-20 | Add system theme detection and auto-switching | done | task |
| ODS-21 | Create CSS custom properties generator utility | done | task |
| ODS-22 | Create singleton theme engine instance and exports | done | task |
