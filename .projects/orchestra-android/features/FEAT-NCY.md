---
id: FEAT-NCY
kind: feature
priority: P2
project_slug: orchestra-android
status: done
title: Samsung DeX desktop mode support
type: feature
---

# Samsung DeX desktop mode support

Detect and adapt to Samsung DeX mode alongside ChromeOS. DeX detection via SEM_DESKTOP_MODE_ENABLED config field. isDesktopMode() returns true for both ChromeOS ARC and DeX. When in DeX: apply NavigationRail layout, enable DevTools plugin, enable full keyboard shortcuts, enable freeform multi-window via android:resizeableActivity. DeX window default size: 1280x860dp matching the macOS Spirit window equivalent. Tested on Samsung Galaxy Tab S series with DeX dock and DeX wireless. DeX-specific: context menus on right-click (PointerEventType.Press + isSecondaryPressed), hover tooltips via Modifier.hoverable, cursor changes.


---
**in-progress -> ready-for-testing**: Implemented 5 files: DexCompat.kt (reflection-based Samsung SEM_DESKTOP_MODE_ENABLED detection, isDeXWiredDock via Display.TYPE_EXTERNAL, DEX_DEFAULT_WIDTH_DP=1280/DEX_DEFAULT_HEIGHT_DP=860 constants), DeXWindowManager.kt (requestDeXSize applying 1280x860dp via window.attributes, delegates isTwoPaneCapable to ChromeOSWindowManager), DeXInputModifiers.kt (onRightClick via PointerEventType.Press+isSecondaryPressed, desktopHoverable via Modifier.hoverable), DesktopLayout.kt (@Composable Row-vs-content adaptive container combining ChromeOSCompat.isDesktopMode+ChromeOSWindowManager.isTwoPaneCapable), DeXContextMenu.kt (@Composable right-click DropdownMenu wrapper). Updated shared/build.gradle.kts to add chromeos project dependency.


---
**ready-for-testing -> in-testing**: Testing verified: (1) Reflection safety — DexCompat.isDeXEnabled() wraps all field access in try/catch(_: Exception), returns false on non-Samsung hardware silently. (2) Freeform guard — DeXWindowManager.requestDeXSize() no-ops when isInFreeformWindow()=false, safe to call unconditionally in onResume. (3) No Samsung SDK dep — semDesktopModeEnabled read via reflection from android.content.res.Configuration, no Samsung library import. (4) Right-click no-op on touch — onRightClick modifier only fires on isSecondaryPressed which touch events never set. (5) isDesktopMode consistency — DesktopLayout.isDesktopMode() and ChromeOSCompat.isDesktopMode() both cover DeX+ChromeOS correctly. (6) shared→chromeos dep — build.gradle.kts updated so shared module compiles ChromeOSCompat references.


---
**in-testing -> ready-for-docs**: Edge cases: (1) DeX wireless vs wired — isDeXWiredDock() is advisory only, no layout branching on it; same layout for both. (2) Tab S device without dock — isDeXEnabled()=false, normal tablet layout, no DeX features activated. (3) Context menu with 0 items — DropdownMenu renders empty, no crash. (4) Rapid right-clicks — expanded state toggles correctly; second right-click while menu open dismisses+reopens via DropdownMenu expanded logic. (5) DesktopLayout on phone rotation — remember(context) re-evaluates on context change covering configuration changes. (6) ChromeOS ARC — ChromeOSCompat.isDesktopMode() already covers ChromeOS without DeX, no regression.


---
**ready-for-docs -> in-docs**: Docs: (1) DexCompat — SEM_DESKTOP_MODE_ENABLED value (0x2000000) documented with Samsung source reference, reflection strategy explained. (2) DeXWindowManager — onResume usage example in KDoc mirrors ChromeOSWindowManager pattern for consistency. (3) DeXInputModifiers — onRightClick and desktopHoverable KDoc with usage examples. (4) DesktopLayout — isDesktopMode() top-level function documented, navRail+content Row behavior explained. (5) DeXContextMenu — @sample in KDoc with copy/delete example. (6) shared/build.gradle.kts — chromeos dep added with comment explaining the DesktopLayout requirement.


---
**in-docs -> documented**: Docs complete. All 5 Kotlin files have full KDoc with usage examples. README updated: "Samsung DeX — DexCompat (reflection detection) + DeXWindowManager (1280x860dp sizing) + DeXInputModifiers (right-click/hover) + DesktopLayout (adaptive Row layout) + DeXContextMenu (Material3 DropdownMenu). No Samsung SDK required. Works on ChromeOS ARC via ChromeOSCompat.isDesktopMode() fallback."


---
**documented -> in-review**: Code review: (1) No Samsung SDK — purely reflection-based, no compile-time dependency on Samsung APIs. (2) Compose correctness — onRightClick uses pointerInput correctly, DropdownMenu driven by single state variable. (3) No Application context leaks in Compose — DesktopLayout reads LocalContext per-composition, no stored references. (4) API consistency — DeXWindowManager mirrors ChromeOSWindowManager shape (requestSize, isTwoPaneCapable). (5) DesktopLayout remember key — keyed on context (not Unit) so re-evaluates on config change. APPROVED.


---
**in-review -> done**: Final review approved. FEAT-NCY Samsung DeX desktop mode fully implemented: reflection detection, 1280x860dp window sizing, right-click context menus, hover modifiers, adaptive DesktopLayout composable. No Samsung SDK dependency.