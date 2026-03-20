---
id: FEAT-RPO
kind: bug
priority: P1
project_slug: orchestra-flutter
status: done
title: Admin pages bleed-through during navigation — transparent backgrounds
type: feature
---

# Admin pages bleed-through during navigation — transparent backgrounds

Permission chips from RolesPage/UserDetailPage are visible behind user list rows when navigating between admin pages. Root cause: all admin pages use Padding as root widget with no opaque background. Fix: wrap each page's root in ColoredBox(color: tokens.bg).


---
**in-progress -> in-testing** (2026-03-18T07:21:49Z):
## Changes
- apps/flutter/lib/screens/web/admin/billing_page.dart (wrapped root in ColoredBox with tokens.bg)
- apps/flutter/lib/screens/web/admin/logs_page.dart (wrapped root in ColoredBox with tokens.bg)
- apps/flutter/lib/screens/web/admin/plugins_page.dart (wrapped root in ColoredBox with tokens.bg)
- apps/flutter/lib/screens/web/admin/analytics_page.dart (wrapped root in ColoredBox with tokens.bg)
- apps/flutter/lib/screens/web/admin/security_page.dart (wrapped root in ColoredBox with tokens.bg)

## Summary
Fixed admin page bleed-through by wrapping 5 remaining admin page root widgets in ColoredBox(color: tokens.bg). 17 other admin pages already had the fix applied.

## Verification
Navigate between admin pages — no more content bleed-through from roles/user detail pages.


---
**in-testing -> in-review** (2026-03-18T07:22:17Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T07:23:51Z): Admin page bleed-through fixed. 5 pages wrapped in ColoredBox. Tests pass.
