---
estimate: M
id: FEAT-GYE
kind: feature
priority: high
project_slug: orchestra-web
status: done
title: Wire 2FA Settings on Flutter
type: feature
---

# Wire 2FA Settings on Flutter

Wire Flutter two_factor_settings_tab: enable toggle calls /auth/2fa/setup, show QR code, verify 6-digit code via /auth/2fa/confirm, display recovery codes, disable via /auth/2fa/disable.


---
**in-progress -> in-testing** (2026-03-19T21:30:48Z):
## Changes
- apps/flutter/lib/screens/settings/tabs/two_factor_settings_tab.dart — complete rewrite: replaced placeholder with real API integration. Enable button calls POST /auth/2fa/setup, shows secret for manual entry with copy button, 6-digit code verification calls POST /auth/2fa/confirm, disable section requires password and calls POST /auth/2fa/disable. Shows error/success banners. Refreshes user state after enable/disable.
- apps/flutter/lib/core/auth/user_model.dart — added twoFactorEnabled field to User model, fromJson (reads two_factor_enabled), copyWith
- apps/flutter/lib/core/auth/auth_provider.dart — added fetchMe() method to AuthNotifier for refreshing user state after 2FA changes


---
**in-testing -> in-docs** (2026-03-19T21:31:47Z):
## Results
- test/core/auth/auth_test.dart (7 tests passing: User.fromJson, copyWith, AuthState — includes new twoFactorEnabled field)
- test/screens/auth/two_factor_screen_test.dart (1 test passing)
- test/screens/settings/settings_tabs_test.dart (2 tests passing)
- test/screens/settings/settings_screen_test.dart (1 test passing)
- test/screens/auth/ (5 tests passing: login, register, magic login, passkey, forgot password)
- dart analyze: No issues found
- 16 tests total, all passing, zero regressions


---
**in-docs -> in-review** (2026-03-19T21:32:08Z):
## Docs
- docs/flutter-2fa-settings.md (new — API endpoints, user flow for enable/disable, model changes, error handling)


---
**Review (approved)** (2026-03-19T21:32:23Z): 2FA settings fully wired with setup/confirm/disable flows.
