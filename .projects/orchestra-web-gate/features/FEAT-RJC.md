---
estimate: S
id: FEAT-RJC
kind: chore
priority: medium
project_slug: orchestra-web-gate
status: done
title: Verify Flutter 2FA settings and add QR rendering
type: feature
---

# Verify Flutter 2FA settings and add QR rendering

Verify the 2FA setup/confirm/disable flow in two_factor_settings_tab.dart. Add QR code image rendering. Verify web 2FA login flow.


---
**in-progress -> in-testing** (2026-03-19T22:43:32Z):
## Changes

- apps/flutter/lib/screens/settings/tabs/two_factor_settings_tab.dart (added QR code rendering using qr_flutter package — QrImageView with rounded styling on white background)
- apps/flutter/pubspec.yaml (added qr_flutter: ^4.1.0 dependency)


---
**in-testing -> in-docs** (2026-03-19T22:45:08Z):
## Results

- flutter analyze passes with no issues on two_factor_settings_tab.dart
- Verified endpoint wiring: setup (POST /api/auth/2fa/setup), confirm (POST /api/auth/2fa/confirm), disable (POST /api/auth/2fa/disable) all match backend routes
- Verified web 2FA login flow: login returns requires_2fa + temp_token, redirects to /two-factor, verify2FA sends code + temp_token
- QR code renders correctly using qr_flutter QrImageView with otpauth:// URI


---
**in-docs -> in-review** (2026-03-19T22:45:28Z):
## Docs

- docs/flutter-2fa-settings.md (updated: added QR code rendering step to the enable flow)
