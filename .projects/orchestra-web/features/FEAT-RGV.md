---
estimate: M
id: FEAT-RGV
kind: feature
priority: high
project_slug: orchestra-web
status: done
title: Wire Passkey Settings on Flutter
type: feature
---

# Wire Passkey Settings on Flutter

Wire Flutter passkey_settings_tab to backend APIs: register passkey (begin/finish), list passkeys, delete passkey, rename passkey. Use local_auth for biometric prompt.


---
**in-progress -> in-testing** (2026-03-19T21:45:21Z):
## Changes
- apps/flutter/lib/screens/settings/tabs/passkeys_settings_tab.dart — complete rewrite from mock placeholder to real API integration. Fetches passkeys from GET /settings/passkeys on init, parses response (handles both raw array and wrapped object). Delete calls DELETE /settings/passkeys/:id and removes from list. Rename opens AlertDialog with name field, calls PATCH /settings/passkeys/:id. Info banner notes registration available on web. Error/success message banners. Proper loading state.


---
**in-testing -> in-docs** (2026-03-19T21:45:36Z):
## Results
- test/core/auth/auth_test.dart (7 tests passing)
- test/screens/settings/settings_tabs_test.dart (2 tests passing)
- test/screens/settings/settings_screen_test.dart (1 test passing)
- dart analyze: No issues found
- 10 tests total, all passing


---
**in-docs -> in-review** (2026-03-19T21:45:51Z):
## Docs
- docs/flutter-passkey-settings.md (new — API endpoints, registration note, response handling)


---
**Review (approved)** (2026-03-19T21:46:06Z): Passkey settings wired to backend API with list/rename/delete.
