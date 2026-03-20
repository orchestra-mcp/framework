---
estimate: S
id: FEAT-XSO
kind: bug
priority: high
project_slug: orchestra-web-gate
status: done
title: Fix web passkey login bug — undefined challenge
type: feature
---

# Fix web passkey login bug — undefined challenge

Debug and fix the passkey WebAuthn login flow in apps/next/src/store/auth.ts. The beginRes.publicKey is undefined when calling /api/auth/passkey/authenticate/begin. Add null guards and fix response handling.


---
**in-progress -> in-testing** (2026-03-19T22:35:05Z):
## Changes

- apps/next/src/store/auth.ts (fixed loginWithPasskey: added JSON body to POST request, added null guard for publicKey response, clear error message)
- apps/next/src/store/auth.ts (fixed beginPasskeyRegistration: added JSON body for consistency)


---
**in-testing -> in-review** (2026-03-19T22:35:14Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-19T22:35:55Z): User approved the passkey fix.
