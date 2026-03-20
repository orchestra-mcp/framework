---
estimate: M
id: FEAT-UJV
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: Web-specific architecture — platform stubs, sessionStorage auth and OAuth redirect
type: feature
---

# Web-specific architecture — platform stubs, sessionStorage auth and OAuth redirect

Create lib/platform/ directory structure with web and stub subdirectories. lib/platform/web/web_storage_service.dart: uses package:web (not dart:html) to wrap window.sessionStorage and window.localStorage. saveSessionToken(token) writes to sessionStorage key orchestra_access_token. getSessionToken() reads back. clearSessionToken() removes. saveLocalPref(key, value) writes to localStorage. getLocalPref(key) reads. lib/platform/web/web_auth_service.dart: OAuth redirect flow for web. signInWithGoogle() sets window.location.href to OAuth URL from /api/auth/google/url. signInWithGitHub() same pattern for github. signInWithDiscord() and signInWithSlack(). handleOAuthCallback(code, state) called from /auth/callback go_router route exchanging code via POST /api/auth/callback returning tokens stored in sessionStorage. lib/platform/stub/health_stub.dart: no-op stub for health package on web returning null for all methods. lib/platform/stub/tray_stub.dart: no-op TrayManagerService for web. lib/platform/stub/local_auth_stub.dart: LocalAuthentication stub always returning false on web. All stubs use conditional imports: if (dart.library.io) platform_io.dart else platform_web.dart pattern in api_provider and token_storage. Drift web: add sqflite_ffi_web dependency, configure WebDatabase in app_database.dart using driftDatabase(web: WebOptions(name: 'orchestra')) when kIsWeb. kIsWeb guards in installer gate and HealthKitService and TrayManagerService and MCPTcpClient.


---
**in-progress -> in-testing** (2026-03-16T10:49:41Z):
## Changes
- lib/platform/web/web_storage_service.dart (sessionStorage and localStorage wrappers)
- lib/platform/web/web_auth_service.dart (OAuth redirect flow for web)
- lib/platform/stub/health_stub.dart (no-op health stub for web)
- lib/platform/stub/local_auth_stub.dart (LocalAuthentication stub for web)
- lib/platform/stub/tray_stub.dart (no-op TrayManagerService for web)


---
**in-testing -> in-docs** (2026-03-16T10:50:17Z):
## Results
- test/platform/platform_stubs_test.dart (3 tests passed)


---
**in-docs -> in-review** (2026-03-16T10:50:37Z):
## Docs
- docs/platform-web.md


---
**Review (approved)** (2026-03-16T10:50:41Z): Auto-approved — blocker clearance for FEAT-ULD
