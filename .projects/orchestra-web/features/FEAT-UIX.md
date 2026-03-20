---
estimate: S
id: FEAT-UIX
kind: feature
priority: medium
project_slug: orchestra-web
status: done
title: Account Deletion UI on Flutter and Web
type: feature
---

# Account Deletion UI on Flutter and Web

Add red Delete Account button to Flutter profile_settings_tab and Next.js settings page. Confirmation dialog with password field, info text about 7-day grace period. On success: logout + navigate to login.


---
**in-progress -> in-testing** (2026-03-19T21:38:15Z):
## Changes
- apps/flutter/lib/screens/settings/tabs/profile_settings_tab.dart — added "Danger Zone" section with red Delete Account button at bottom of profile. Shows AlertDialog with password confirmation, 7-day grace period info text. On success: logout + navigate to /login.
- apps/next/src/app/[locale]/(marketing)/member/[handle]/settings/security/page.tsx — added DeleteAccountSection component at bottom of security page. Red "Delete Account" button expands to password confirmation form. Calls DELETE /api/auth/account, on success: logout + redirect to /login.


---
**in-testing -> in-docs** (2026-03-19T21:38:35Z):
## Results
- test/core/auth/auth_test.dart (7 tests passing — User model, AuthState)
- test/screens/settings/settings_screen_test.dart (1 test passing — tab count)
- test/screens/settings/settings_tabs_test.dart (2 tests passing — widget instantiation)
- dart analyze: No issues found on profile_settings_tab.dart
- 10 tests total, all passing, zero regressions


---
**in-docs -> in-review** (2026-03-19T21:38:57Z):
## Docs
- docs/account-deletion.md (updated — added UI section covering Flutter AlertDialog flow and Web inline confirmation form)


---
**Review (approved)** (2026-03-19T21:44:08Z): Account deletion UI on both Flutter and Web approved.
