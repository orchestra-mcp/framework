---
estimate: S
id: FEAT-QFN
kind: bug
priority: high
project_slug: orchestra-web-gate
status: todo
title: Fix web passkey login — Cannot read properties of undefined
type: feature
---

# Fix web passkey login — Cannot read properties of undefined

Debug and fix the passkey WebAuthn login flow in apps/next/src/store/auth.ts. The beginRes.publicKey is undefined when calling /api/auth/passkey/authenticate/begin. Add null guards and fix response handling.
