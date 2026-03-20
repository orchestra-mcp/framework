---
estimate: S
id: FEAT-SEU
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: DevTools navigation integration (sidebar + router)
type: feature
---

# DevTools navigation integration (sidebar + router)

Add DevTools group to app sidebar/drawer with icons for each screen, register routes in app_router.dart, add l10n strings. Files: screens/shell/desktop_shell.dart or app_shell.dart, core/router/app_router.dart, l10n/


---
**in-progress -> in-testing** (2026-03-20T18:44:00Z):
## Changes
- apps/flutter/lib/core/router/app_router.dart (added 5 devtools routes + /devtools redirect, imported 5 screen files)
- apps/flutter/lib/screens/shell/desktop_shell.dart (added devtools to _SidebarType enum, _RailDest, _DevToolsSidebar widget with 5 nav items, wired in switch statements)
- apps/flutter/lib/l10n/app_en.arb (added devtools l10n string)


---
**in-testing -> in-docs** (2026-03-20T18:44:28Z):
## Results
- apps/flutter/test/screens/shell/devtools_navigation_test.dart (5 tests — route constants, uniqueness, prefix matching)
- All 5 tests pass
- dart analyze: zero errors on modified files


---
**in-docs -> in-review** (2026-03-20T18:44:46Z):
## Docs
- docs/devtools-navigation.md (new — routes table, desktop sidebar, mobile, l10n, files modified)


---
**Review (approved)** (2026-03-20T18:45:11Z): DevTools navigation complete — all 7 Plan 2 features done
