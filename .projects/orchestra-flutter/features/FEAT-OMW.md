---
estimate: M
id: FEAT-OMW
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: Login screen with social OAuth, magic link and passkey options
type: feature
---

# Login screen with social OAuth, magic link and passkey options

Create lib/features/auth/login_screen.dart. Glass card centered on gradient mesh background using theme accent. Orchestra SVG logo 72px at top. Email TextField with email keyboard type. Password TextField with obscureText toggle show/hide eye icon. Continue GlassButton full-width gradient using accent colors. Below button: link Do not have account that navigates to /register. Link Sign in without password triggering magic link flow. Link Sign in with Passkey navigating to /passkey. Social OAuth row: fetch GET /api/auth/providers to get enabledProviders list, show buttons only for enabled providers, buttons for Google, GitHub, Discord, Slack with logos. On Continue press: call AuthRepository.login(email, password), show loading state on button, on success navigate to /summary or /onboarding based on onboarding_done flag, on failure show inline error message below password field not a dialog. Social OAuth: launch OAuth URL in url_launcher browser, register deep-link handler at /auth/callback for code exchange. Analytics: log login event with method email or oauth on success.


---
**in-progress -> in-testing** (2026-03-16T10:45:54Z):
## Changes
- lib/screens/auth/login_screen.dart (email/password form, auth state binding, glass card style)


---
**in-testing -> in-docs** (2026-03-16T10:46:48Z):
## Results
- test/screens/auth/login_screen_test.dart (passed)


---
**in-docs -> in-review** (2026-03-16T10:47:16Z):
## Docs
- docs/login-screen.md (login screen architecture, auth flows, social OAuth, analytics)
