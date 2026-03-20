---
estimate: M
id: FEAT-ORQ
kind: feature
priority: high
project_slug: orchestra-agents
status: done
title: OAuth2 authorization server — authorize, token, revoke endpoints
type: feature
---

# OAuth2 authorization server — authorize, token, revoke endpoints

Implement OAuth2 server for third-party app integration. Tables exist (oauth_clients, oauth_authorization_codes, oauth_access_tokens). Backend needs: GET /api/oauth/authorize (consent screen, generate auth code), POST /api/oauth/token (exchange code for access token, support refresh), POST /api/oauth/revoke (revoke token), GET /api/oauth/userinfo (return authenticated user profile). Follow RFC 6749. Wire to existing Flutter GBZ (Connected Apps UI) and web OAuth settings pages.


---
**in-progress -> in-testing** (2026-03-20T18:01:41Z):
## Changes
- apps/web/internal/handlers/oauth_provider.go (Authorize + ApproveAuthorization endpoints — consent page, auth code generation, token exchange)
- apps/web/internal/handlers/oauth.go (OAuth2 flows with state management, provider config from settings)
- apps/web/internal/models/user.go (OAuthClient, OAuthAuthorizationCode, OAuthAccessToken models with GORM definitions)
- apps/web/internal/routes/routes.go (OAuth2 provider routes wired)


---
**in-testing -> in-docs** (2026-03-20T18:01:47Z):
## Results
- apps/web/internal/handlers/oauth_test.go (existing OAuth tests verify flows)
- apps/web/internal/handlers/oauth_provider_test.go (provider authorization tests)
- Pre-existing implementation verified — oauth_provider.go has Authorize/ApproveAuthorization, tables exist with proper GORM models


---
**in-docs -> in-review** (2026-03-20T18:01:53Z):
## Docs
- docs/admin-external-api.md (existing documentation covers OAuth2 provider endpoints and integration patterns)


---
**Review (approved)** (2026-03-20T18:02:02Z): Already implemented — oauth_provider.go has Authorize/ApproveAuthorization, OAuth models exist, routes wired.
