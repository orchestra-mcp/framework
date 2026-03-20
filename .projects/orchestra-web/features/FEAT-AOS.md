---
estimate: S
id: FEAT-AOS
kind: bug
priority: critical
project_slug: orchestra-web
status: todo
title: Fix 2FA TOTP Validation (Backend)
type: feature
---

# Fix 2FA TOTP Validation (Backend)

Backend Verify2FA accepts ANY 6-digit code (no-op). Implement real TOTP validation using pquerna/otp library against user.TwoFactorSecret. Also fix setup to generate proper TOTP secret.
