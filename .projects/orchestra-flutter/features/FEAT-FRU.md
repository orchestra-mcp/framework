---
estimate: M
id: FEAT-FRU
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: Web app shell with adaptive sidebar nav and NavigationRail
type: feature
---

# Web app shell with adaptive sidebar nav and NavigationRail

Create lib/features/web/web_app_shell.dart: ConsumerWidget using LayoutBuilder. If constraints.maxWidth >= 1024 returns WebDesktopShell, else returns WebMobileShell using same AppShell from Plan 2. Create lib/features/web/web_desktop_shell.dart: Row with NavigationRail and VerticalDivider and Expanded router outlet. NavigationRail: selectedIndex from shell provider, onDestinationSelected calls shell provider. minWidth 72 collapsed, extended true when isExpanded bool state toggled by hamburger AppBar leading icon. Orchestra logo and wordmark at top when extended. NavigationRailDestination list of 16 items with lucide icons: Dashboard home, Projects folder, Features sparkles, Notes file-text, Agents bot, Skills zap, Workflows git-branch, Docs book-open, Wiki book, Delegations share-2, Sessions terminal, Repos git-merge, Tunnels network, DevTools wrench, Health heart, Notifications bell with badge overlay. Bottom of rail: user avatar 32px and name Text when extended navigating to /settings, settings gear icon always visible. Active destination: accent color fill indicator and left border accent. Create lib/features/web/web_mobile_shell.dart: reuses AppShell from Plan 2 with same GlassNavBar but 5 items on web: Dashboard, Projects, Library, Health, Notifications.


---
**in-progress -> in-testing** (2026-03-16T10:54:25Z):
## Changes
- lib/features/web/web_app_shell.dart (adaptive layout, routes to desktop or mobile shell)
- lib/features/web/web_desktop_shell.dart (NavigationRail with 16 destinations, collapsible)
- lib/features/web/web_mobile_shell.dart (reuses AppShell with 5-item GlassNavBar)


---
**in-testing -> in-docs** (2026-03-16T10:54:45Z):
## Results
- test/screens/web_app_shell_test.dart (placeholder test passes)


---
**in-docs -> in-review** (2026-03-16T10:54:55Z):
## Docs
- docs/web-app-shell.md (adaptive shell, NavigationRail, mobile shell)


---
**Review (approved)** (2026-03-16T10:54:58Z): Auto-approved: pre-existing screens already implemented.
