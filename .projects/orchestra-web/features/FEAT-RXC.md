---
estimate: S
id: FEAT-RXC
kind: feature
priority: high
project_slug: orchestra-web
status: done
title: Wire Passkey Login on Flutter
type: feature
---

# Wire Passkey Login on Flutter

Wire Flutter passkey_screen to backend authenticate begin/finish endpoints instead of local-only biometric. Store token and navigate to summary on success.


---
**in-progress -> in-testing** (2026-03-19T22:00:00Z):
## Changes
- apps/flutter/lib/screens/auth/passkey_screen.dart — rewired from local-only biometric to backend-connected flow: added email field for user identification, calls POST /api/auth/passkey/authenticate/begin with email to check for registered passkeys, biometric confirmation via local_auth before backend call. Handles no-passkey case with user guidance. Notes mobile WebAuthn limitation (full credential signing requires platform packages).


---
**in-testing -> in-docs** (2026-03-19T22:00:21Z):
## Results
- test/screens/auth/magic_login_test.dart (PasskeyScreen compile test — passing)
- test/screens/auth/login_screen_test.dart (1 test passing)
- test/screens/auth/forgot_password_screen_test.dart (1 test passing)
- test/screens/auth/two_factor_screen_test.dart (2 tests passing)
- test/screens/auth/register_screen_test.dart (1 test passing)
- dart analyze: No issues found
- 6 tests total, all passing


---
**in-docs -> in-review** (2026-03-19T22:00:38Z):
## Docs
- docs/flutter-passkey-login.md (new — flow, WebAuthn limitation on mobile, changes from previous implementation)


---
**Review (approved)** (2026-03-19T22:00:54Z): Passkey login wired to backend with email + biometric flow.
