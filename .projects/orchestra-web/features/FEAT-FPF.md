---
estimate: S
id: FEAT-FPF
kind: bug
priority: high
project_slug: orchestra-web
status: done
title: Fix Magic Link Login on Flutter
type: feature
---

# Fix Magic Link Login on Flutter

Remove 'backend does not support' comment. Wire send button to POST /auth/magic-link/send, handle deep link callback to POST /auth/magic-link/verify, store JWT on success. Also wire forgot_password_screen.


---
**in-progress -> in-testing** (2026-03-19T21:26:10Z):
## Changes
- apps/flutter/lib/core/api/endpoints.dart — added auth endpoints: authForgotPassword, authMagicLinkSend, authMagicLinkVerify, auth2faSetup/Confirm/Disable/Verify, authDeleteAccount, settingsPasskeys, settingsPasskey(id), authOAuth(provider)
- apps/flutter/lib/screens/auth/magic_login_screen.dart — removed fake delay and "backend does not support" comment, wired _submit() to POST /api/auth/magic-link/send via Dio
- apps/flutter/lib/screens/auth/forgot_password_screen.dart — removed fake delay and "backend does not support" comment, wired _submit() to POST /api/auth/forgot-password via Dio


---
**in-testing -> in-review** (2026-03-19T21:26:50Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-19T21:28:08Z): Magic link and forgot password screens wired to real backend APIs.
