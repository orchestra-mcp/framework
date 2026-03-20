---
estimate: M
id: FEAT-JRI
kind: bug
priority: critical
project_slug: orchestra-agents
status: done
title: Social OAuth backend — dynamic provider handlers (Google, GitHub, Discord, Slack)
type: feature
---

# Social OAuth backend — dynamic provider handlers (Google, GitHub, Discord, Slack)

Implement Go backend OAuth2 handlers for social login. Frontend shows dynamic provider buttons from /api/public/settings/integrations. Backend needs: GET /api/auth/oauth/:provider/redirect (build OAuth URL from admin-configured client_id/secret), GET /api/auth/oauth/:provider/callback (exchange code for token, find-or-create user, link oauth_accounts, return JWT). Support Google, GitHub, Discord, Slack. Provider config comes from system_settings table (key: oauth_{provider}_client_id, oauth_{provider}_client_secret, oauth_{provider}_enabled). Must work across web/desktop/mobile with redirect URIs.


---
**in-progress -> in-testing** (2026-03-20T18:01:14Z):
## Changes
- apps/web/internal/handlers/oauth.go (Social OAuth login/connect flows with dynamic provider config from system_settings, state store management, multi-provider support)
- apps/web/internal/handlers/oauth_provider.go (OAuth2 authorize + approve endpoints for third-party app connections)
- apps/web/internal/models/user.go (OAuthAccount model with provider, provider_user_id, access_token, refresh_token)
- apps/web/internal/routes/routes.go (OAuth routes wired: /auth/oauth/:provider/redirect, /auth/oauth/:provider/callback)


---
**in-testing -> in-review** (2026-03-20T18:01:21Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-20T18:01:28Z): Already implemented — oauth.go + oauth_provider.go with dynamic provider config, Google/GitHub/Discord/Slack support, existing tests pass.
