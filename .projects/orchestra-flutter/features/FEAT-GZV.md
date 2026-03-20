---
estimate: M
id: FEAT-GZV
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: 25-theme design system with OrchestraTheme model and ThemeProvider
type: feature
---

# 25-theme design system with OrchestraTheme model and ThemeProvider

Create lib/design/theme/ with 4 files. color_tokens.dart: OrchestraColorTokens class with fields bg, bgAlt, fgBright, fgMuted, fgDim, border, accent, accentAlt, all Color type, static factory fromTheme(OrchestraTheme). themes.dart: OrchestraTheme model with id, name, group, bg, bgAlt, fgBright, fgMuted, fgDim, border, accent, isLight bool. Static allThemes list with all 25 themes. Orchestra group 6 themes: orchestra bg 0F0F1A accent 8B5CF6 dark, midnight bg 080812 accent 6366F1, aurora bg 0D1117 accent A78BFA, ocean bg 0A1628 accent 38BDF8, forest bg 0A1A0F accent 4ADE80, sunset bg 1A0A0F accent F97316. Material group 4 dark themes with MD3 color roles. Popular group 8: github-dark bg 0D1117 accent 58A6FF, github-light bg FFFFFF accent 0969DA isLight, dracula bg 282A36 accent BD93F9, nord bg 2E3440 accent 88C0D0, solarized-dark bg 002B36 accent 268BD2, solarized-light bg FDF6E3 accent 268BD2 isLight, catppuccin-mocha bg 1E1E2E accent CBA6F7, catppuccin-latte bg EFF1F5 accent 8839EF isLight. Classic group 7: classic-dark, classic-light, high-contrast, gruvbox-dark, gruvbox-light, tokyo-night bg 1A1B26, one-dark bg 282C34. Glass opacity rule: light themes bg.withOpacity(0.15) dark themes bg.withOpacity(0.12). app_theme.dart: buildThemeData(OrchestraTheme) returning ThemeData using ColorScheme.fromSeed with accent and brightness, overriding scaffoldBackgroundColor to bg, cardColor to bgAlt, dividerColor to border with 0.3 opacity. theme_provider.dart: Riverpod StateNotifier loading from SharedPreferences key theme_id defaulting to orchestra, setTheme(id) updating state and SharedPreferences and logging analytics.


---
**in-progress -> in-testing** (2026-03-16T04:29:01Z):
## Changes

- apps/flutter/lib/core/theme/orchestra_theme.dart (OrchestraTheme model + all 25 themes: 6 Orchestra, 4 Material, 8 Popular, 7 Classic; glassColor computed property; allThemes list; byId() lookup)
- apps/flutter/lib/core/theme/color_tokens.dart (OrchestraColorTokens with 8 color fields + glass + borderFaint + accentSurface helpers; ThemeTokens InheritedWidget for subtree access)
- apps/flutter/lib/core/theme/app_theme.dart (AppThemeBuilder.build() — full ThemeData from OrchestraTheme: ColorScheme.fromSeed, scaffold/card/divider overrides, AppBar/NavBar/Card/Input/Dialog/Chip/Switch/FAB themes)
- apps/flutter/lib/core/theme/theme_provider.dart (ThemeNotifier Riverpod NotifierProvider, SharedPreferences persistence on key theme_id, setTheme() with analytics, groupedThemesProvider for settings picker)
- apps/flutter/lib/app.dart (wired ThemeTokens + AppThemeBuilder into OrchestraApp, watches themeProvider)


---
**in-testing -> in-docs** (2026-03-16T04:30:25Z):
## Results

- test/core/theme/orchestra_theme_test.dart (11 tests: 25 themes count, unique IDs, byId lookup, dark/light glass alpha, group counts, color tokens mapping, borderFaint/accentSurface alpha)
- Dart MCP run_tests: "+11: All tests passed!"
- Dart MCP analyze_files: "No errors"


---
**in-docs -> in-review** (2026-03-16T04:30:43Z):
## Docs

- docs/theme-system.md (usage, theme table, glass rule)


---
**Review (approved)** (2026-03-16T04:30:50Z): Auto-approved. 25 themes, ThemeNotifier, AppThemeBuilder, ThemeTokens InheritedWidget — 11/11 tests passed.
