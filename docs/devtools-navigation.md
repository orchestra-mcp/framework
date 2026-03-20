# DevTools Navigation Integration

Sidebar group and route registration for the 5 DevTools screens.

## Routes

| Path | Screen |
|------|--------|
| `/devtools` | Redirects to `/devtools/api` |
| `/devtools/api` | API Collections Manager |
| `/devtools/database` | Database Browser |
| `/devtools/logs` | Log Runner |
| `/devtools/secrets` | Secrets Manager |
| `/devtools/prompts` | Prompts Manager |

All routes are registered inside the main `ShellRoute` so the desktop sidebar and mobile nav bar remain visible.

## Desktop Sidebar

A new `devtools` entry in the icon rail (build icon) opens a sidebar with 5 navigation items:
- API Collections (api icon)
- Database (storage icon)
- Log Runner (receipt icon)
- Secrets (key icon)
- Prompts (chat icon)

Clicking any item navigates to the corresponding screen. The rail icon highlights when any `/devtools/*` route is active.

## Mobile

DevTools screens are accessible via the spotlight search or direct navigation. The bottom nav bar remains unchanged (Summary, Health, Terminal, Search).

## L10n

Added `devtools` key to `app_en.arb` with value "DevTools".

## Files Modified
- `apps/flutter/lib/core/router/app_router.dart` — 5 route constants, 6 GoRoute entries (incl. redirect), 5 screen imports
- `apps/flutter/lib/screens/shell/desktop_shell.dart` — `_SidebarType.devtools`, rail destination, `_DevToolsSidebar` widget
- `apps/flutter/lib/l10n/app_en.arb` — `devtools` string
- `apps/flutter/test/screens/shell/devtools_navigation_test.dart` — 5 tests
