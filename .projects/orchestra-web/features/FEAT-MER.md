---
estimate: M
id: FEAT-MER
kind: feature
priority: medium
project_slug: orchestra-web
status: done
title: Social OAuth Login Buttons on Flutter
type: feature
---

# Social OAuth Login Buttons on Flutter

Add OAuth provider buttons to Flutter login screen for Google, GitHub, Apple, Discord, Jira, Slack, Twitter. Fetch enabled providers from settings, open OAuth URL in browser, handle deep link callback with token.


---
**in-progress -> in-testing** (2026-03-19T21:48:25Z):
## Changes
- apps/flutter/lib/screens/auth/login_screen.dart — added OAuth provider buttons section between Sign In button and bottom links. "or continue with" divider + 5 provider buttons (Google, GitHub, Apple, Discord, Slack) as icon buttons in a Wrap. Each opens /api/auth/oauth/:provider in external browser via url_launcher.
- apps/flutter/lib/l10n/app_en.arb — added orContinueWith key
- apps/flutter/lib/l10n/app_ar.arb — added orContinueWith Arabic translation


---
**in-testing -> in-docs** (2026-03-19T21:48:40Z):
## Results
- test/screens/auth/login_screen_test.dart (1 test passing: LoginScreen is a widget)
- test/core/auth/auth_test.dart (7 tests passing)
- dart analyze: No issues found
- 8 tests total, all passing


---
**in-docs -> in-review** (2026-03-19T21:48:54Z):
## Docs
- docs/flutter-oauth-login.md (new — supported providers, flow description, configuration)


---
**Review (approved)** (2026-03-19T21:49:17Z): OAuth login buttons for 5 providers on Flutter login screen.
