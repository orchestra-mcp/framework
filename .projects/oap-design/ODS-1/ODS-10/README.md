# ODS-10: Create theme provider for React

**Type**: Story | **Status**: done | **Points**: 3

As a React developer, I want a ThemeProvider component so that I can easily use themes in React applications with proper context and hooks.

## Acceptance Criteria

- [ ] ThemeProvider component wraps app and provides theme context
- [ ] useTheme() hook returns current theme and setTheme function
- [ ] useThemeTokens() hook returns current theme's token values
- [ ] ThemeScript component for SSR/hydration support
- [ ] TypeScript types for all theme context

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| ODS-23 | Create ThemeContext and ThemeProvider component | done | task |
| ODS-24 | Create useTheme and useThemeTokens hooks | done | task |
| ODS-25 | Create ThemeScript for SSR/hydration support | done | task |
| ODS-26 | Set up components package structure and exports | backlog | task |
