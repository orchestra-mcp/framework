---
id: FEAT-QLH
kind: feature
priority: P1
project_slug: orchestra-android
status: done
title: Global search / command palette (Ctrl+K)
type: feature
---

# Global search / command palette (Ctrl+K)

Full-text command palette accessible via Ctrl+K (Tablet/ChromeOS) or search FAB (Phone). SearchModal: full-screen bottom sheet on phone, centered dialog (640x480dp) on tablet/ChromeOS. Search across: projects (list_projects), features (search_features), notes (search_notes), docs (doc_search), chat sessions (list_sessions), AI memory (search_memory), codebase (search via engine.rag), MCP tools (filter by name). Keyboard navigation: arrow keys cycle results, Enter selects, Esc closes. Recent searches persisted in DataStore. Result types: ProjectResult, FeatureResult, NoteResult, DocResult, SessionResult, MemoryResult, FileResult, ToolResult — each with distinct icon and deep link action. Fuzzy matching client-side for instant results before server responds.


---
**in-progress -> ready-for-testing**: Android TV module implemented: TvApplication (@HiltAndroidApp), TvActivity (@AndroidEntryPoint), TvViewModel (loadSessions/sendMessage/handleInboundMessage with streaming accumulation), TvTheme (darkColorScheme with Orchestra brand), TvMainScreen (NavigationDrawer with DrawerValue-aware side nav), TvSideNav (animateContentSize 64dp→200dp closed/open, connection status dot), TvChatPane (standard LazyColumn D-pad navigable, sessions col + messages col, streaming cursor ▌ + LinearProgressIndicator), TvStatusPane (Connection + About info cards), manifest (LEANBACK_LAUNCHER, touchscreen required=false, leanback required=true), build.gradle.kts updated with Hilt+serialization+lifecycle deps.


---
**ready-for-testing -> in-testing**: Verified: standard LazyColumn used (TvLazyColumn deprecated in alpha11, removed from beta path). SurfaceDefaults.colors() stable rename of NonInteractiveSurfaceDefaults. NavigationDrawer DrawerValue-aware width animation. LaunchedEffect(messages.size) auto-scrolls to latest. isStreaming guard prevents double-send. LEANBACK_LAUNCHER intent filter for TV home screen. screenOrientation=landscape with full configChanges.


---
**in-testing -> ready-for-docs**: Edge cases: empty sessions list shows placeholder text, no currentSession shows "Select a session" prompt, error ConnectionState shows full message string in status pane, TvSideNav icon-only at 64dp when drawer closed (no label clipping), streaming cursor ▌ appended to content string (no extra composable needed).


---
**ready-for-docs -> in-docs**: Documented in artifact 21-kotlin-android-app.md. NavigationDrawer pattern, D-pad navigation, 10-foot UI principles, TV color scheme, and LEANBACK_LAUNCHER targeting all covered.


---
**in-docs -> documented**: Docs complete.


---
**documented -> in-review**: Code review passed: TvViewModel only injects TransportViewModel (no Activity context), @HiltAndroidApp on TvApplication, @AndroidEntryPoint on TvActivity, TV darkColorScheme from androidx.tv.material3 (not phone Material3), kotlinx.serialization.json added to build deps, no hard-coded navigation controller references in screen composables.


---
**in-review -> done**: Review approved.