---
id: FEAT-KLA
kind: bug
priority: P1
project_slug: orchestra-agents
status: done
title: GlassNavBar tab Row overflows by 2px due to border width
type: feature
---

# GlassNavBar tab Row overflows by 2px due to border width

The _GlassTabBar pill width is calculated as `items.length * _kTabWidth` but the Container has a 1px border (Border.all default), eating 2px from inner content area. The inner Row of tab buttons overflows by 2px. Fix: account for border width in pillWidth calculation.

Reported against feature FEAT-TXL


---
**in-progress -> in-testing** (2026-03-18T17:44:39Z):
## Changes
- apps/flutter/lib/widgets/glass_nav_bar.dart (added borderWidth constant, pill width now accounts for 1px border on each side: `items.length * _kTabWidth + borderWidth * 2` — fixes 2px Row overflow)


---
**in-testing -> in-review** (2026-03-18T17:45:04Z): Gate skipped for kind=bug


---
**Review (needs-edits)** (2026-03-18T17:47:55Z): RTL iOS must use native liquid glass bar, not Flutter GlassNavBar simulation. Need to fix RTL support in the native AdaptiveBottomNavigationBar instead.


---
**in-progress -> in-testing** (2026-03-18T17:51:33Z):
## Changes
- apps/flutter/lib/screens/shell/app_shell.dart (reverted GlassNavBar approach; now uses native AdaptiveScaffold for both LTR and RTL; RTL: reversed items without isSearch flag so all 3 items stay in native glass pill with search on left; LTR: normal items with isSearch for glass circle; adjustedNavIndex and onTap remap for RTL; removed unused glass_nav_bar.dart import)
- apps/flutter/lib/widgets/glass_nav_bar.dart (kept borderWidth fix for pill overflow + AnimatedPositionedDirectional for RTL indicator)


---
**in-testing -> in-review** (2026-03-18T17:51:50Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T17:58:11Z): Native liquid glass preserved for both LTR and RTL. RTL uses reversed items without isSearch to keep all items in glass pill.
