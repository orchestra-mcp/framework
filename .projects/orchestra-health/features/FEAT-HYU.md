---
id: FEAT-HYU
kind: bug
priority: P0
project_slug: orchestra-health
status: done
title: Add Health icon to desktop sidebar rail
type: feature
---

# Add Health icon to desktop sidebar rail

Add Health as a first-class entry in _railDestinations in desktop_shell.dart with favorite_rounded icon and route to /health. This fixes the bug where Health exists in the _SidebarType enum and _HealthSidebar class but is not accessible from the icon rail navigation.


---
**in-progress -> in-testing** (2026-03-17T14:51:24Z):
## Changes
- apps/flutter/lib/screens/shell/desktop_shell.dart (added Health entry to _railDestinations array with Icons.favorite_rounded icon, Routes.health route, and _SidebarType.health sidebar type)


---
**in-testing -> in-review** (2026-03-17T14:51:49Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T14:52:35Z): Health icon added to desktop rail. One-line fix verified with flutter analyze.
