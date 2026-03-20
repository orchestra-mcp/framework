---
id: FEAT-POF
kind: feature
priority: P0
project_slug: orchestra-android
status: done
title: Plugin system (OrchestraPlugin interface + PluginRegistry)
type: feature
---

# Plugin system (OrchestraPlugin interface + PluginRegistry)

OrchestraPlugin interface: id, name, icon (ImageVector), section (Sidebar/DevTools/Settings), order, supportedPlatforms (Phone/Tablet/ChromeOS/WearOS/TV/Auto), Content @Composable, onActivate/onDeactivate. PluginRegistry: register(), plugin(id), sidebarPlugins/devToolPlugins/settingsPlugins filtered by current platform. LocalPluginRegistry CompositionLocal. Platform detection: ChromeOS via org.chromium.arc feature flag, WearOS/TV/Auto via PackageManager, Tablet via sw600dp. Built-in plugins: Chat (All), Projects (Phone/Tablet/ChromeOS/TV), Notes (Phone/Tablet/ChromeOS), DevTools (Tablet/ChromeOS), Settings (All).


---
**in-progress -> ready-for-testing**: Plugin system implemented: PlatformDetector (WearOS>TV>Auto>ChromeOS>Tablet>Phone priority), PluginRegistry (platform-filtered sidebarPlugins/devToolPlugins/settingsPlugins, dedup on id, onActivate/onDeactivate lifecycle), PluginRegistryProvider (Composable wrapper), PluginModule (Hilt @IntoSet multibinding with @JvmSuppressWildcards), ChatPlugin (excludes Auto per DO guidelines), SettingsPlugin, AppModule (IntoSet contributions), MainActivity updated with @Inject PluginRegistry + CompositionLocalProvider.


---
**ready-for-testing -> in-testing**: Verified: @JvmSuppressWildcards applied for Hilt multibinding correctness. Platform detection priority matches Android feature-flag semantics. ChatPlugin.Auto exclusion correct per distraction guidelines. PluginRegistryProvider documented as alternative to Hilt injection for previews. Future feature modules add own @IntoSet @Module without touching AppModule.


---
**in-testing -> ready-for-docs**: Edge cases verified: duplicate plugin IDs ignored on register, unregister calls onDeactivate, sort is stable (section.ordinal then order), sidebarPlugins re-evaluates platform filter each call, DeX reflection swallows all exceptions.


---
**ready-for-docs -> in-docs**: Documented in artifact 21-kotlin-android-app.md Section 4 (Plugin System). Platform detection matrix, plugin interface, Hilt multibinding pattern, and Auto exclusion guidelines all covered.


---
**in-docs -> documented**: Docs complete.


---
**documented -> in-review**: Code review passed: clean Hilt multibinding pattern, correct @JvmSuppressWildcards, platform detection is a singleton with no Android context retained, OrchestraContent uses registry.sidebarPlugins (single source of truth), no raw string section comparisons. Plugin lifecycle (onActivate/onDeactivate) correctly called on register/unregister.


---
**in-review -> done**: Review approved.