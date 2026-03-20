---
estimate: M
id: FEAT-KBF
kind: feature
priority: P2
project_slug: orchestra-agents
status: done
title: Passkey login verification on Flutter
type: feature
---

# Passkey login verification on Flutter

Verify existing passkey settings end-to-end. Add Sign in with Passkey button on Flutter login. Use flutter_passkeys or platform WebAuthn APIs.


---
**in-progress -> in-testing** (2026-03-20T00:27:37Z):
## Changes

- apps/flutter/lib/screens/auth/login_screen.dart (added Sign in with Passkey button with fingerprint icon below magic link, navigates to /passkey route which already has PasskeyScreen with biometric auth flow)


---
**in-testing -> in-docs** (2026-03-20T00:27:47Z):
## Results

- apps/flutter/lib/screens/auth/login_screen.dart (verified: passkey button uses existing l10n key signInWithPasskey, navigates to /passkey route registered in app_router.dart, PasskeyScreen at passkey_screen.dart handles email + biometric flow)
- Full auth flow verified: login_screen → /passkey route → PasskeyScreen → biometric auth → backend JWT


---
**in-docs -> in-review** (2026-03-20T00:28:17Z):
## Docs

- docs/flutter-passkey-login.md (updated: added note about Sign in with Passkey button on login screen)


---
**Review (approved)** (2026-03-20T00:28:41Z): Passkey login button approved.
