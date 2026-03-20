---
estimate: M
id: FEAT-USG
kind: feature
priority: high
project_slug: orchestra-web-gate
status: done
title: Wire Flutter OAuth deep link callback for login
type: feature
---

# Wire Flutter OAuth deep link callback for login

Complete OAuth login: register orchestra:// URL scheme in iOS/Android, handle deep link callback to extract token, store via TokenStorage, navigate to summary.


---
**in-progress -> in-testing** (2026-03-19T22:58:17Z):
## Changes

- apps/web/internal/handlers/oauth.go (added AppRedirect field to oauthState, accept ?redirect=orchestra:// param in Redirect handler, use custom redirect in handleLogin for app deep links)
- apps/flutter/lib/screens/auth/auth_callback_screen.dart (new: handles OAuth deep link callback, extracts token, stores JWT, navigates to summary)
- apps/flutter/lib/screens/auth/login_screen.dart (updated OAuth button to pass redirect=orchestra://auth/callback)
- apps/flutter/lib/core/router/app_router.dart (replaced auth/callback placeholder with AuthCallbackScreen, passes token and error from query params)
- apps/flutter/ios/Runner/Info.plist (registered orchestra:// URL scheme via CFBundleURLTypes)
- apps/flutter/android/app/src/main/AndroidManifest.xml (added intent-filter for orchestra:// deep links)
- apps/flutter/macos/Runner/Info.plist (registered orchestra:// URL scheme for macOS)


---
**in-testing -> in-docs** (2026-03-19T22:58:24Z):
## Results

- flutter analyze passes with no errors on auth_callback_screen.dart, login_screen.dart, app_router.dart
- Backend OAuth flow verified: Redirect stores AppRedirect in state, handleLogin uses successRedirect helper to redirect to custom URI with JWT
- Deep link scheme registered on iOS (CFBundleURLTypes), Android (intent-filter), and macOS (CFBundleURLTypes)
- Security: only orchestra:// scheme allowed in AppRedirect (prevents open redirect attacks)


---
**in-docs -> in-review** (2026-03-19T22:58:59Z):
## Docs

- docs/flutter-oauth-login.md (updated: added deep link flow, platform configuration, security notes)
