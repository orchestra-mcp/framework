---
id: FEAT-IAX
kind: feature
priority: P0
project_slug: orchestra-android
status: done
title: Adaptive layout (NavigationRail + NavigationBar + two-pane)
type: feature
---

# Adaptive layout (NavigationRail + NavigationBar + two-pane)

OrchestraContent root composable using Material 3 window size classes. COMPACT width → NavigationBar (bottom, 80dp). MEDIUM/EXPANDED width → NavigationRail (80dp left). Width ≥840dp → ListDetailPaneScaffold two-pane (280dp list + detail). Foldable: isTableTop posture → top/bottom chat split; isBook → left/right list+detail. TopAppBar with ConnectionIndicator (green/amber/red dot) and model badge. Plugin-driven nav items from PluginRegistry.sidebarPlugins. SavedStateHandle restores selected plugin on rotation/resize.


---
**in-progress -> ready-for-testing**: Adaptive layout implemented: 3-breakpoint system (COMPACT→BottomBarLayout, MEDIUM→RailLayout, EXPANDED→RailTwoPaneLayout). ListDetailPaneScaffold with rememberListDetailPaneScaffoldNavigator for two-pane on expanded. FoldingFeature isBookMode/isTabletopMode extensions for foldable support. WindowInfoTracker reactive state for live fold-posture changes. OrchestraContent null-guards LocalActivity for preview/test safety. AnimatedPane transitions on both panes.


---
**ready-for-testing -> in-testing**: Verified: Scaffold innerPadding forwarded to content (no clipping). NavigationRail items vertically centred via equal Spacers. Plugin hot-swap safety (selectedPlugin falls back to first if id invalid). ListDetailPaneScaffold navigates to detail on rail tap AND list tile tap. PluginListPane highlights active item with secondaryContainer. adaptive-navigation dep added to build files.


---
**in-testing -> ready-for-docs**: Edge cases: fold posture change triggers layout recomposition via collectAsStateWithLifecycle. Empty plugin list handled (selectedId defaults to ""). Preview/Robolectric safe (LocalActivity null-guarded). COMPACT fallback for null activity context.


---
**ready-for-docs -> in-docs**: Documented in artifact 21-kotlin-android-app.md Section 6 (Adaptive Layout). Breakpoint matrix, two-pane scaffold diagram, foldable posture handling, and WindowSizeClass decision table all covered.


---
**in-docs -> documented**: Docs complete.


---
**documented -> in-review**: Code review passed: clean separation of layout concerns into individual files, no magic booleans, @OptIn scoped correctly to each function, LazyColumn not Column for list pane (no unbounded height), Modifier chain correct (weight before fillMaxHeight). OrchestraContent is a thin orchestrator with no layout logic inline.


---
**in-review -> done**: Review approved.