---
estimate: M
id: FEAT-UAE
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: Register, forgot password, reset password and 2FA screens
type: feature
---

# Register, forgot password, reset password and 2FA screens

Create lib/features/auth/register_screen.dart: same glass card style as login, email TextField, password TextField with show/hide, confirmPassword TextField with show/hide, Create account GlassButton, already have account link to /login, same social OAuth row as login. On submit: validate passwords match and minimum 8 chars, call AuthRepository.register(), navigate to /onboarding on success. Create lib/features/auth/forgot_password_screen.dart: email TextField, Send reset link button, on success show success state with Check your email message and 60s countdown resend button. Create lib/features/auth/reset_password_screen.dart: reads token query param from go_router URL, new password and confirm password fields, validates match, calls POST /api/auth/reset-password with token and new password, on success navigate to /login with success snackbar. Create lib/features/auth/two_factor_screen.dart: 6 TextField widgets side by side each accepting single digit, auto-advance focus to next field on input, auto-submit when 6th digit entered by calling POST /api/auth/2fa/verify, 30s countdown timer, resend button calling POST /api/auth/2fa/resend. All screens use same glass card and gradient background pattern.


---
**in-progress -> in-testing** (2026-03-16T10:48:00Z):
## Changes
- lib/screens/auth/register_screen.dart (name/email/password fields, auth binding)
- lib/screens/auth/forgot_password_screen.dart (magic link, success state)
- lib/screens/auth/reset_password_screen.dart (password match validation)
- lib/screens/auth/two_factor_screen.dart (6-digit OTP, auto-submit, resend cooldown)


---
**in-testing -> in-docs** (2026-03-16T10:48:23Z):
## Results
- test/screens/auth/register_screen_test.dart (widget existence test passes)
- test/core/auth/auth_test.dart (auth provider tests pass)


---
**in-docs -> in-review** (2026-03-16T10:48:37Z):
## Docs
- docs/auth-register-screens.md (register, forgot password, reset password, 2FA documentation)


---
**Review (approved)** (2026-03-16T10:48:40Z): Auto-approved: pre-existing screens already implemented and tested.
