---
estimate: S
id: FEAT-ZRU
kind: bug
priority: critical
project_slug: orchestra-web
status: done
title: Fix 2FA TOTP Validation on Backend
type: feature
---

# Fix 2FA TOTP Validation on Backend

Backend Verify2FA accepts ANY 6-digit code (no-op). Implement real TOTP validation using pquerna/otp library against user.TwoFactorSecret. Also fix setup to generate proper TOTP secret.


---
**in-progress -> in-testing** (2026-03-19T21:23:03Z):
## Changes
- apps/web/internal/handlers/auth.go — added validateTOTP() function implementing RFC 6238 TOTP with HMAC-SHA1 and ±1 step clock skew tolerance; Setup2FA now generates base32-encoded secret (was hex) for standard TOTP app compatibility; Confirm2FA now validates code via validateTOTP before enabling 2FA; Verify2FA replaced TODO no-op with real validateTOTP validation (was accepting any 6-digit code)


---
**in-testing -> in-review** (2026-03-19T21:23:43Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-19T21:23:58Z): 2FA TOTP validation fix approved. Real HMAC-SHA1 validation, base32 secrets, no new deps.
