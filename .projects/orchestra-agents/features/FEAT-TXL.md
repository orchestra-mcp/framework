---
id: FEAT-TXL
kind: bug
priority: P1
project_slug: orchestra-agents
status: done
title: Fix RTL navbar + spotlight search missing translations
type: feature
---

# Fix RTL navbar + spotlight search missing translations

Fix four i18n issues in the Flutter app:\n1. Bottom navbar renders LTR in Arabic — items should be mirrored for RTL\n2. Spotlight search categories and type labels use hardcoded English strings\n3. GlassNavBar search mode has hardcoded "Search everything..." and "Cancel"\n4. Chevron icon in category tiles always points right — should flip for RTL


---
**in-progress -> in-testing** (2026-03-18T17:25:28Z):
## Changes
- apps/flutter/lib/screens/shell/app_shell.dart (RTL navbar item reversal — detect RTL via Directionality, reverse items list and adjust selectedIndex + tap index mapping for both iOS AdaptiveBottomNavigationBar and Android NavigationBar)
- apps/flutter/lib/widgets/spotlight_search.dart (convert _categories from const to _buildCategories(l10n) builder, convert typeLabel getter to resolveTypeLabel(l10n) method, add RtlUtils.dirIcon for chevron flip, pass l10n to _ResultTile)
- apps/flutter/lib/widgets/glass_nav_bar.dart (replace hardcoded 'Search everything...' with l10n.searchEverything, replace hardcoded 'Cancel' with l10n.cancel)
- apps/flutter/lib/l10n/app_en.arb (add singular keys: project, feature, agent, skill, workflow, doc, session, delegation)
- apps/flutter/lib/l10n/app_ar.arb (add Arabic singular translations: مشروع, ميزة, وكيل, مهارة, سير عمل, مستند, جلسة, تفويض)
- apps/flutter/lib/l10n/app_localizations.dart (auto-generated)
- apps/flutter/lib/l10n/app_localizations_en.dart (auto-generated)
- apps/flutter/lib/l10n/app_localizations_ar.dart (auto-generated)


---
**in-testing -> in-review** (2026-03-18T17:25:55Z): Gate skipped for kind=bug


---
**Review (needs-edits)** (2026-03-18T17:27:25Z): Navbar RTL reversal not working correctly. iOS should show tabs on right and search on left in RTL. Android also needs proper reversal.


---
**in-progress -> in-testing** (2026-03-18T17:28:54Z):
## Changes
- apps/flutter/lib/screens/shell/app_shell.dart (reverted manual RTL item reversal — both iOS UITabBarController and Flutter NavigationBar handle RTL layout automatically via Row/Directionality; removed adjustedNavIndex, isRtl flag, and logicalIndex remapping; restored original _onNavTap signature; added comments documenting native RTL behavior)


---
**in-testing -> in-review** (2026-03-18T17:29:12Z): Gate skipped for kind=bug


---
**Review (needs-edits)** (2026-03-18T17:30:16Z): Android navbar RTL is correct, but iOS AdaptiveBottomNavigationBar (liquid glass) does not auto-reverse for RTL — needs manual reversal on iOS path only.


---
**in-progress -> in-testing** (2026-03-18T17:30:53Z):
## Changes
- apps/flutter/lib/screens/shell/app_shell.dart (iOS path: re-added manual RTL reversal for AdaptiveBottomNavigationBar which does not auto-reverse — items reversed, selectedIndex adjusted via 2-navIndex, onTap remaps via 2-i; Android path: unchanged, Flutter NavigationBar handles RTL natively)


---
**in-testing -> in-review** (2026-03-18T17:31:09Z): Gate skipped for kind=bug


---
**Review (needs-edits)** (2026-03-18T17:34:17Z): iOS native bottom bar pill/search circle positions don't flip for RTL. Need to disable native rendering for RTL so Flutter handles layout.


---
**in-progress -> in-testing** (2026-03-18T17:34:55Z):
## Changes
- apps/flutter/lib/screens/shell/app_shell.dart (iOS path: set useNativeBottomBar to !isRtl — native glass bar for LTR, Flutter-rendered bar for RTL which auto-flips pill/search positions via Row directionality; removed manual item reversal, adjustedNavIndex, and onTap remapping; items stay in logical order)


---
**in-testing -> in-review** (2026-03-18T17:35:12Z): Gate skipped for kind=bug


---
**Review (needs-edits)** (2026-03-18T17:37:27Z): useNativeBottomBar:false loses glass style. Need to use GlassNavBar for RTL iOS instead, preserving the frosted glass appearance while getting proper RTL layout.


---
**in-progress -> in-testing** (2026-03-18T17:38:34Z):
## Changes
- apps/flutter/lib/screens/shell/app_shell.dart (iOS RTL: use GlassNavBar via Scaffold instead of AdaptiveScaffold — same frosted glass style, Flutter Row auto-reverses pill/search positions for RTL; iOS LTR: unchanged native liquid glass bar; Android: unchanged)
- apps/flutter/lib/widgets/glass_nav_bar.dart (replaced AnimatedPositioned with AnimatedPositionedDirectional using start: instead of left: — indicator slides correctly in both LTR and RTL)


---
**in-testing -> in-review** (2026-03-18T17:38:50Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T17:43:17Z): Verified on iOS in Arabic: search circle on left, glass tab pill on right, glass style preserved. All 4 fixes working correctly.
