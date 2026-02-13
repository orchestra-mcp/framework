# OSV-4: Dynamic Themes Service

**Type**: Epic | **Status**: done | **Priority**: medium

Extract theme management from chrome-extension/src/theme/ + widget theme code into src/app/Themes/. Provides IThemeService with registerTheme/setActiveTheme/importVSCodeTheme API. Built-in light+dark themes, CSS custom properties injection, VSCode theme import support, real-time preview, and editor syntax highlighting integration.

## Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| OSV-28 | IThemeService Interface & Core Theme Engine | done | high |
| OSV-29 | Theme CSS Injection & Real-Time Propagation | done | high |
| OSV-30 | VSCode Theme Import & Documentation | done | medium |
