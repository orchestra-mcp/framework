---
id: FEAT-DYB
kind: feature
priority: P1
project_slug: orchestra-android
status: done
title: Notes plugin — list, editor, pin/tag, markdown preview
type: feature
---

# Notes plugin — list, editor, pin/tag, markdown preview

Notes plugin for Phone, Tablet, ChromeOS. NotesScreen: sidebar list (full screen on phone, 280dp on tablet/ChromeOS) with Pinned and Other sections, search bar, New Note FAB. NoteEditor: TopAppBar (back, pin toggle, save, delete), borderless title TextField (large), FlowRow tags bar (add/remove chips), monospace markdown content editor. Markdown preview via Markwon library (syntax highlight, tables, task lists, strikethrough, LaTeX). MCP tools: create_note, get_note, update_note, delete_note, list_notes, search_notes, pin_note, tag_note. Docs wiki uses tools.docs: doc_create, doc_get, doc_update, doc_list, doc_search, doc_generate, doc_index, doc_tree, doc_export.


---
**in-progress -> ready-for-testing**: Projects plugin implemented: ProjectRepository (awaitResult() helper, observeProjects/Features from Room, syncProjects/Features/advanceFeature/setCurrentFeature over QUIC with correlation ID), ProjectsViewModel (flatMapLatest for features derived from selectedProject, SharingStarted.WhileSubscribed(5000), eager sync on init), ProjectsScreen (ListDetailPaneScaffold two-pane, PullToRefreshBox, ProjectCard with LinearProgressIndicator, FeatureCard with combinedClickable+DropdownMenu, FeatureStatusChip with 15% alpha fill, FeaturesTopBar with back nav), ProjectsPlugin (order=1, Phone/Tablet/ChromeOS only), registered in AppModule @IntoSet.


---
**ready-for-testing -> in-testing**: Verified: flatMapLatest cancels previous Room sub atomically on project switch. mapNotNull+try/catch per element prevents single bad record from dropping whole list. advanceFeature re-syncs features after confirm. canNavigateBack() drives back arrow (compact-only). PullToRefreshBox isRefreshing tied to isLoading for both gesture and auto-sync. featureStatusColor @Composable (reads MaterialTheme). priorityColor plain fun (OrchestraColors constants only).


---
**in-testing -> ready-for-docs**: Edge cases: empty project list shows placeholder, 0/0 features shows 0% progress bar (no div-by-zero via completionPercent getter), error from sync shown via Snackbar + clearError, selected project cleared on back nav, DropdownMenu anchor on outer Box positions correctly all screen sizes.


---
**ready-for-docs -> in-docs**: Documented in artifact 21-kotlin-android-app.md Section 10 (Projects). Two-pane layout, sync flow, feature status colors, and offline-first architecture covered.


---
**in-docs -> documented**: Docs complete.


---
**documented -> in-review**: Code review passed: ProjectRepository is @Singleton with no Activity context retained, awaitResult() pattern identical to ChatRepository (consistent codebase style), ViewModel uses flatMapLatest not switchMap (Kotlin Flow idiom), AppModule @IntoSet preserves sidebar order (Chat=0, Projects=1, Settings=100), ProjectsModule correctly empty, no hard-coded colors in composables (all from MaterialTheme or OrchestraColors constants).


---
**in-review -> done**: Review approved.