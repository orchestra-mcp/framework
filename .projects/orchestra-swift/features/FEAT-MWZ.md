---
created_at: "2026-03-10T13:13:04Z"
description: 'Implement Discord OAuth2 login flow: (1) Go backend OAuth initiation endpoint + callback handler using golang.org/x/oauth2 + Discord provider, (2) Create/link OAuthAccount records with provider=discord, (3) Add Discord to login/register page social buttons with onClick redirect, (4) Add Discord to connected accounts in user settings (connect/disconnect), (5) Admin settings for Discord OAuth client_id/client_secret under admin-integrations tab.'
estimate: M
id: FEAT-MWZ
kind: feature
labels:
    - plan:PLAN-QKM
priority: P1
project_id: orchestra-swift
status: done
title: Discord OAuth Login + Connected Account
updated_at: "2026-03-10T14:06:44Z"
version: 5
---

# Discord OAuth Login + Connected Account

Implement Discord OAuth2 login flow: (1) Go backend OAuth initiation endpoint + callback handler using golang.org/x/oauth2 + Discord provider, (2) Create/link OAuthAccount records with provider=discord, (3) Add Discord to login/register page social buttons with onClick redirect, (4) Add Discord to connected accounts in user settings (connect/disconnect), (5) Admin settings for Discord OAuth client_id/client_secret under admin-integrations tab.


---
**in-progress -> in-testing** (2026-03-10T14:01:51Z):
## Changes
- apps/web/internal/handlers/oauth.go (new — full OAuth2 flow: Redirect, Callback, CSRF state, token exchange, user info fetch, login/connect modes, Discord/Google/GitHub providers)
- apps/web/internal/routes/routes.go (added OAuth handler + 3 routes: /oauth/:provider, /oauth/:provider/callback, /oauth/:provider/connect)
- apps/next/src/app/auth/oauth-callback/page.tsx (new — client-side token handler, stores JWT, redirects to dashboard)
- apps/next/src/app/[locale]/(auth)/login/page.tsx (added Discord social button with onClick handler, 3-column grid)
- apps/next/src/app/(app)/settings/page.tsx (added Discord to connected accounts, wired Connect button onClick, added Discord OAuth admin fields)


---
**in-testing -> in-docs** (2026-03-10T14:02:57Z):
## Results
- apps/web/internal/handlers/oauth_test.go (13 tests: state expiry, state store roundtrip, state modes, token response parsing, Discord/GitHub user info parsing, provider config struct, exchange code with mock server, exchange code empty token error, fetch user info mock server, fetch user info name fallback, Discord avatar URL construction, Discord avatar URL already-HTTP skip)

All 13 tests PASS — `go test ./internal/handlers/ -run "TestOAuth|TestToken|TestUserInfo|TestProvider|TestExchange|TestFetch|TestDiscord" -v` completed with 0 failures.


---
**in-docs -> in-review** (2026-03-10T14:03:22Z):
## Docs
- docs/discord-oauth.md (new — OAuth flow, endpoints, configuration, login/connect behavior, frontend pages, security)


---
**Review (approved)** (2026-03-10T14:06:44Z): Full OAuth2 flow for Discord/Google/GitHub with 13 passing tests. Backend handler + routes, frontend callback page, social buttons, connected accounts, admin settings.
