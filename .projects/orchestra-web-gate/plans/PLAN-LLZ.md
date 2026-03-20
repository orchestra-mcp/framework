---
id: PLAN-LLZ
project_slug: orchestra-web-gate
status: completed
title: Auth System Overhaul — Passkey, 2FA, Magic Link, Sessions, OAuth, Account Deletion, OAuth2 Provider
type: plan
---

# Auth System Overhaul — Passkey, 2FA, Magic Link, Sessions, OAuth, Account Deletion, OAuth2 Provider

Comprehensive auth system overhaul across web (Next.js) and mobile (Flutter) frontends with backend (Go/Fiber) additions.

## Summary of Work

**Phase 1 — Fix Passkey Login (Web)**: The web passkey login at `apps/next/src/store/auth.ts:361-415` calls the correct endpoint but the error suggests the response may not be parsed correctly. Need to debug and add null guards.

**Phase 2 — Wire 2FA Settings (Flutter)**: The 2FA tab at `apps/flutter/lib/screens/settings/tabs/two_factor_settings_tab.dart` is ALREADY FULLY WIRED — setup/confirm/disable all connected to correct endpoints. Just needs verification.

**Phase 3 — Fix Magic Link Login (Flutter)**: Already wired at `apps/flutter/lib/screens/auth/magic_login_screen.dart` — calls `Endpoints.authMagicLinkSend`. No "backend does not support" comment found. Already working.

**Phase 4 — Enhance Sessions Tab (Flutter)**: Sessions tab at `apps/flutter/lib/screens/settings/tabs/sessions_settings_tab.dart` already shows device/OS/browser/IP and tunnel_active indicator. Already working.

**Phase 5 — OAuth Login (Flutter)**: Login screen at `apps/flutter/lib/screens/auth/login_screen.dart` ALREADY HAS OAuth buttons (Google, GitHub, Apple, Discord, Slack) with `url_launcher`. But needs callback deep link handling to complete the flow.

**Phase 6 — Account Deletion**: Backend handler exists at `auth.go:819-860`. Flutter has delete UI in profile tab. Web settings page has delete button. Need to verify web handler wiring.

**Phase 7 — OAuth2 Provider**: New feature — Orchestra as OAuth server for third-party apps. New models + handlers needed.

## Key Findings from Code Review

After thorough code review, many items in the original plan are already implemented:
- Flutter 2FA: Fully wired (setup, confirm, disable)
- Flutter Magic Link: Fully wired
- Flutter Sessions: Already shows device info + tunnel status
- Flutter OAuth buttons: Already present with url_launcher
- Flutter Passkey settings: List, rename, delete all wired
- Backend account deletion: Fully implemented with 7-day grace
- Flutter account deletion: Fully implemented in profile tab

## Actual Work Needed

1. **Web passkey bug fix** — Debug why `beginRes.publicKey` is undefined
2. **Flutter OAuth callback handling** — Deep link `orchestra://auth/callback` to complete OAuth flow
3. **Web delete account** — Verify `handleDeleteAccount` exists and wires correctly
4. **OAuth2 Provider** — New backend models + authorization server endpoints + admin CRUD + Flutter connected apps UI
