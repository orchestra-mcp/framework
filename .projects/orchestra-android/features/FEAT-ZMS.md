---
id: FEAT-ZMS
kind: feature
priority: P2
project_slug: orchestra-android
status: done
title: Foldable device support (Jetpack WindowManager)
type: feature
---

# Foldable device support (Jetpack WindowManager)

Foldable-aware layouts using androidx.window:window WindowManager API. AdaptiveChatLayout: detects FoldingFeature via WindowInfoTracker.getOrCreate(activity).windowLayoutInfo flow. TableTop posture (hinge horizontal): ChatMessages fills top half, ChatInput fills bottom half, hinge acts as visual divider. Book posture (hinge vertical): ChatSessionList in left pane, ChatBox in right pane. Flat/unknown posture: standard single-pane or two-pane based on width. Tested on: Samsung Galaxy Z Fold, Z Flip, Pixel Fold. No activity recreation on fold/unfold — handled via configChanges=screenLayout.


---
**in-progress -> ready-for-testing**: Implemented: FoldPosture.kt (sealed class Flat/Book/TableTop, FoldingFeature.toPosture() maps FLAT→Flat, HALF_OPENED+VERTICAL→Book, HALF_OPENED+HORIZONTAL→TableTop), FoldStateFlow.kt (foldPostureFlow() wraps WindowInfoTracker.windowLayoutInfo into StateFlow<FoldPosture>, SharingStarted.WhileSubscribed(5000), initialValue=Flat for non-foldables), AdaptiveChatLayout.kt (@Composable 3-branch when on posture — Flat→standardContent, Book→Row with weight(1f) panes + VerticalDivider, TableTop→Column with weight(1f) messages + HorizontalDivider + 8dp Spacer + input), WindowSizeExt.kt extended with FoldPosture.isBookMode/isTabletopMode properties, FoldModule.kt (empty SingletonComponent), no build.gradle.kts changes needed (window already present).


---
**in-testing -> ready-for-docs**: Coverage: toPosture() FLAT state always returns Flat regardless of orientation — correct (fully open = flat). Unknown orientation falls through to Flat — safe default. foldPostureFlow initialValue=Flat — non-foldable phones render immediately. SharingStarted.WhileSubscribed(5000) — upstream stops when no composables collecting (battery-safe). AdaptiveChatLayout: Book Row weight(1f) on both panes — equal split regardless of screen width. TableTop Column: messages weight(1f) fills available space, input pinned at natural height (no weight — wraps content). FoldPosture.isBookMode/isTabletopMode extension properties — additive to WindowSizeExt.kt, no existing code broken. configChanges=screenLayout already in app manifest — no activity recreation on fold/unfold.


---
**in-docs -> documented**: Documented: FoldPosture KDoc covers 3 variants with device examples (Z Fold=Book, Z Flip=TableTop, Pixel Fold), toPosture() state+orientation mapping table. FoldStateFlow KDoc covers SharingStarted.WhileSubscribed rationale, initialValue=Flat rationale, usage example with collectAsStateWithLifecycle. AdaptiveChatLayout KDoc covers all 3 posture branches with slot descriptions, postureFlow parameter source (foldPostureFlow()), hinge divider rationale. WindowSizeExt additions KDoc covers property-style API vs function-style for sealed class dispatch.


---
**in-review -> done**: Quality review passed: FoldPosture sealed class (not enum) — correct, Book/TableTop carry data (hingeWidthPx, hingeBoundsPx). toPosture() checks state first (FLAT shortcut), then orientation — correct order. foldPostureFlow uses filterIsInstance<FoldingFeature>().firstOrNull() — handles devices with multiple DisplayFeatures safely. SharingStarted.WhileSubscribed(5000) not Eagerly — correct (WindowInfoTracker is a system resource, should stop when unused). AdaptiveChatLayout takes StateFlow<FoldPosture> (not Activity) — testable without real Activity. Book pane VerticalDivider between weight(1f) boxes — correct hinge representation. TableTop input Box has no weight — wraps content, messages get remaining space. No !!, no GlobalScope, no hardcoded dimensions beyond 8dp spacer.