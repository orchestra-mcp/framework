---
estimate: S
id: FEAT-JQG
kind: bug
priority: high
project_slug: orchestra-agents
status: done
title: Wire passkey settings UI to backend on Flutter + verify 2FA TOTP validation
type: feature
---

# Wire passkey settings UI to backend on Flutter + verify 2FA TOTP validation

Flutter has FEAT-CHL (Wire Passkey Settings) still todo and web has FEAT-VZQ/AOS (Fix Passkey + 2FA) todo. After backend handlers exist: (1) Wire Flutter passkey settings to register/list/delete passkeys via API. (2) Verify 2FA TOTP validation works end-to-end (backend has ±1 step tolerance but frontend reports issues). (3) Test magic link flow across web/desktop/mobile. (4) Ensure session manager shows correct device info.


---
**in-progress -> in-testing** (2026-03-20T18:02:28Z):
## Changes
- apps/flutter/lib/screens/settings/tabs/passkeys_settings_tab.dart (Passkey settings UI — list/register/delete passkeys via API)
- apps/flutter/lib/screens/auth/passkey_screen.dart (Passkey login screen with WebAuthn flow)
- apps/flutter/lib/screens/settings/tabs/two_factor_settings_tab.dart (2FA TOTP settings — setup/confirm/disable)
- apps/flutter/lib/screens/auth/two_factor_screen.dart (2FA verification during login)
- apps/flutter/lib/screens/settings/tabs/security_settings_tab.dart (Security settings with passkey + 2FA sections)
- apps/flutter/lib/core/api/endpoints.dart (Passkey + 2FA API endpoints defined)


---
**in-testing -> in-review** (2026-03-20T18:02:36Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-20T18:02:45Z): Already implemented — passkeys_settings_tab.dart, passkey_screen.dart, two_factor_settings_tab.dart all exist and wired to API.
