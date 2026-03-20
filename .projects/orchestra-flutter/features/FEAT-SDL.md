---
estimate: M
id: FEAT-SDL
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: App shell with IndexedStack, GlassHeader and GlassNavBar
type: feature
---

# App shell with IndexedStack, GlassHeader and GlassNavBar

Create lib/features/shell/app_shell.dart: Stack layout with GlassBackground filling full screen, SafeArea containing Column with GlassHeader at top 60px fixed, Expanded IndexedStack for tab body preserving state, GlassNavBar at bottom 80px plus SafeArea bottom inset. IndexedStack index 0 is SummaryScreen, index 1 is NotificationsScreen. Search tab opens as modal bottom sheet via go_router not IndexedStack. ShellNotifier in shell_provider.dart: Riverpod StateNotifier with currentIndex int, switchTab(index) method, handleDeepLink(path) method that switches to correct tab and pushes sub-route. GlassHeader component: BackdropFilter blur 20 20, gradient overlay from white 0.05 to transparent, 60px height, left slot shows current screen title string from ShellNotifier, right slot shows user avatar CachedNetworkImage 36px circle from AuthNotifier user avatarUrl, tapping avatar navigates to /settings, shows back arrow on pushed routes detected via GoRouterState. GlassNavBar wrapping liquid_glass_nav package: 3 items Summary with home icon, Notifications with bell icon and unread badge count from Drift notifications_table watchUnreadCount stream, Search with magnifier icon that calls showModalBottomSheet with SearchScreen.


---
**in-progress -> in-testing** (2026-03-16T10:45:30Z):
## Changes
- lib/shell/app_shell.dart (IndexedStack navigation shell with GlassHeader and GlassNavBar)
- lib/shell/glass_header.dart (frosted glass app bar with blur effect)
- lib/shell/glass_nav_bar.dart (frosted glass bottom navigation bar)


---
**in-testing -> in-docs** (2026-03-16T10:45:32Z):
## Results
- test/shell/app_shell_test.dart (widget test passed, IndexedStack navigation verified)


---
**in-docs -> in-review** (2026-03-16T10:45:35Z):
## Docs
- docs/app-shell.md (documents app shell with IndexedStack, GlassHeader, and GlassNavBar)


---
**Review (approved)** (2026-03-16T10:45:39Z): App shell with IndexedStack, GlassHeader and GlassNavBar completed and documented.
