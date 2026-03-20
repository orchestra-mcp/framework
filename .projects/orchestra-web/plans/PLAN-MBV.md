---
id: PLAN-MBV
project_slug: orchestra-web
status: completed
title: Auth System Overhaul — Passkey, 2FA, Magic Link, Sessions, OAuth, Account Deletion
type: plan
---

# Auth System Overhaul — Passkey, 2FA, Magic Link, Sessions, OAuth, Account Deletion

Complete auth system overhaul across Web (Next.js), Flutter, and Go backend. 7 phases: (1) Fix passkey login web+flutter, (2) Fix 2FA with real TOTP validation, (3) Fix magic link login flutter, (4) Session manager + tunnel status, (5) Social OAuth login flutter, (6) Account deletion with 7-day grace period, (7) OAuth2 provider (Orchestra as OAuth server). Backend has comprehensive APIs but frontends have broken/placeholder implementations. Critical backend bugs: 2FA accepts any code, session revoke is no-op.
