---
id: FEAT-CAA
kind: feature
priority: P0
project_slug: orchestra-android
status: done
title: Design system (OrchestraTheme + 25 color themes)
type: feature
---

# Design system (OrchestraTheme + 25 color themes)

Material 3 dark color scheme with Orchestra palette. OrchestraColors: Background #0A0D14, Surface #111520, Accent #A900FF, Border #1E2436, TextPrimary #E8ECF4, TextMuted #8892A8, Success #22C55E, Error #EF4444. OrchestraTheme composable: themeId param, dynamicColor toggle (Material You on API 31+). 25 themes including orchestra, dracula, github-dark, github-light, one-dark, monokai-pro, synthwave-84. OrchestraTypography (bodyMedium 14sp, labelLarge 14sp SemiBold). OrchestraShapes (sm=8dp, md=12dp, lg=16dp). CodeFont = JetBrains Mono. Theme persisted in DataStore Proto.


---
**in-progress -> ready-for-testing**: 25-theme design system implemented: ThemeColors with id/name/isDark + 6 core + 6 derived tokens. allThemes linkedMapOf with all 25 themes (orchestra, dracula, github-dark/light, one-dark, monokai-pro, synthwave-84, nord, catppuccin-mocha/latte, tokyo-night, gruvbox-dark/light, solarized-dark/light, ayu-dark/light, material-ocean, palenight, night-owl, shades-of-purple, cobalt2, rose-pine, everforest-dark, kanagawa). DataStore persistence via ThemePreferences. ThemeViewModel with SharingStarted.Eagerly. OrchestraAppTheme for hiltViewModel injection. ThemePicker with LazyVerticalGrid + ColorDot mini-palette + accessibility semantics.


---
**ready-for-testing -> in-testing**: Verified: linkedMapOf preserves insertion order for ThemePicker display. isDark flag selects lightColorScheme vs darkColorScheme correctly for 5 light themes. buildDarkColorScheme/buildLightColorScheme map all Material 3 slots. DataStore preferencesDataStore declared at file level (correct). SharingStarted.Eagerly avoids initial flash. ThemePicker adaptive grid works phone/tablet/foldable.


---
**in-testing -> ready-for-docs**: Edge cases: null themeId falls back to "orchestra", DataStore flows have defaults so no null handling needed, dynamic colour path branches correctly on API 31+ per isDark, ThemeCard has contentDescription + Role.Button + selected for TalkBack, derived token defaults computed from core tokens so no theme needs to specify all fields.


---
**ready-for-docs -> in-docs**: Documented in artifact 21-kotlin-android-app.md. Theme catalogue, ThemeColors token schema, DataStore persistence flow, and ThemePicker component all covered.


---
**in-docs -> documented**: Docs complete.


---
**documented -> in-review**: Code review passed: ThemeModule correctly empty (Hilt resolves via constructor injection), no @Provides duplication, OrchestraTheme signature unchanged (preview-safe), OrchestraAppTheme is separate composable (no mixed concerns), datastore + datastore-preferences both added to shared build, no hardcoded colour values in composables.


---
**in-review -> done**: Review approved.