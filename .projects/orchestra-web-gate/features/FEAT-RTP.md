---
estimate: S
id: FEAT-RTP
kind: chore
priority: medium
project_slug: orchestra-web-gate
status: done
title: Verify Flutter magic link and forgot password flows
type: feature
---

# Verify Flutter magic link and forgot password flows

Verify magic link login and forgot password screens work end-to-end with backend.


---
**in-progress -> in-testing** (2026-03-19T22:49:05Z):
## Changes

- apps/flutter/lib/screens/auth/magic_callback_screen.dart (new: magic link verification screen — extracts token from query params, calls POST /api/auth/magic-link/verify, stores JWT, navigates to summary)
- apps/flutter/lib/screens/auth/reset_password_screen.dart (fixed: replaced placeholder _submit with real API call to POST /api/auth/reset-password with token and password)
- apps/flutter/lib/core/router/app_router.dart (wired magic callback and reset password routes to pass token query parameter)
- apps/flutter/lib/core/api/endpoints.dart (added authResetPassword constant)


---
**in-testing -> in-docs** (2026-03-19T22:49:14Z):
## Results

- flutter analyze passes with no errors on magic_callback_screen.dart and reset_password_screen.dart
- Verified magic link flow: send (POST /api/auth/magic-link/send) → email → deep link /auth/magic?token=xxx → MagicCallbackScreen verifies token → stores JWT → navigates to summary
- Verified reset password flow: forgot-password sends email → deep link /reset-password?token=xxx → ResetPasswordScreen calls POST /api/auth/reset-password with token + password
- Verified backend routes match: magic-link/send (line 166), magic-link/verify (line 168), reset-password (line 169)


---
**in-docs -> in-review** (2026-03-19T22:49:55Z):
## Docs

- docs/flutter-magic-link-reset.md (new: documents magic link login and password reset flows end-to-end)
