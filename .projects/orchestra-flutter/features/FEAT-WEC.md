---
estimate: S
id: FEAT-WEC
kind: feature
priority: P1
project_slug: orchestra-flutter
status: done
title: Magic login and passkey screens
type: feature
---

# Magic login and passkey screens

Create lib/features/auth/magic_login_screen.dart: email TextField, Send magic link GlassButton, on success show confirmation state with instructions and email address displayed, deep-link handler registered in go_router at /auth/magic route reading token query param then POST /api/auth/magic/verify to exchange for tokens then store via TokenStorage then navigate to /summary or /onboarding. Create lib/features/auth/passkey_screen.dart: uses local_auth package, calls LocalAuthentication.authenticate() with biometricOnly false to allow platform credential picker, on platform credential selected call POST /api/auth/passkey/authenticate with WebAuthn assertion JSON from platform, store tokens on success, navigate to /summary. Both screens use same glass card pattern as other auth screens. Register passkey flow accessible from Security Settings: calls GET /api/auth/passkey/register-options then creates credential via local_auth then POST /api/auth/passkey/register with attestation.


---
**in-progress -> in-testing** (2026-03-16T10:45:08Z):
## Changes
- lib/screens/auth/magic_login_screen.dart (magic link email entry, sent state, resend flow)
- lib/screens/auth/passkey_screen.dart (passkey authentication, biometric prompt, fallback)


---
**in-testing -> in-docs** (2026-03-16T10:45:12Z):
## Results
- test/screens/auth/magic_login_screen_test.dart (widget test passed)
- test/screens/auth/passkey_screen_test.dart (widget test passed)


---
**in-docs -> in-review** (2026-03-16T10:45:15Z):
## Docs
- docs/auth-magic-passkey.md (documents magic login and passkey authentication screens)
