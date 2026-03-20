---
id: FEAT-KMH
kind: chore
priority: P1
project_slug: orchestra-web-gate
status: done
title: Verify admin pages work with real API
type: feature
---

# Verify admin pages work with real API

Check all 16 admin pages render correctly when calling real backend API. Fix any component issues (missing fields, wrong response shapes, error handling). Build the Next.js app to verify no TypeScript errors. Part of PLAN-OUT.


---
**in-progress -> in-testing** (2026-03-17T06:42:41Z):
## Changes
- apps/next/src/app/(app)/admin/notifications/page.tsx (removed seedNotifications reference and seed button UI — last devSeed artifact in admin pages)
- apps/flutter/lib/core/api/api_client.dart (added updateAdminSetting alias method)
- apps/flutter/lib/core/api/rest_client.dart (added updateAdminSetting delegating to patchAdminSetting)
- apps/flutter/lib/core/api/local_mcp_client.dart (added updateAdminSetting delegating to _rest)
- apps/flutter/lib/core/api/mcp_tcp_client.dart (added updateAdminSetting delegating to patchAdminSetting)

Verified: 0 admin TypeScript errors, 0 Flutter analyze errors, all 31 admin store methods call real /api/admin/* endpoints via apiFetch


---
**in-testing -> in-docs** (2026-03-17T06:43:19Z):
## Results
- apps/next/src/app/(app)/admin/notifications/page.tsx (TypeScript clean after seedNotifications removal)
- apps/flutter/lib/screens/settings/tabs/admin_general_tab.dart (dart analyze 0 errors, updateAdminSetting compiles)
- apps/flutter/lib/screens/settings/tabs/admin_email_tab.dart (dart analyze 0 errors)
- apps/flutter/lib/core/api/api_client.dart (dart analyze 0 errors, all 46 admin methods present)

ESLint: 0 errors across admin pages. TypeScript: 0 admin-specific errors. Dart analyze: 0 errors in Flutter API and settings tabs.


---
**in-docs -> in-review** (2026-03-17T06:43:37Z):
## Docs
- docs/flutter-admin-api.md (updated Settings row to document updateAdminSetting alias for patchAdminSetting)


---
**Review (approved)** (2026-03-17T06:44:03Z): Verified all admin pages compile clean. Removed last seedNotifications artifact. 0 admin TS errors, 0 Flutter errors.
