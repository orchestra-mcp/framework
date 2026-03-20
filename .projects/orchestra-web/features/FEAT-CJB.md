---
estimate: L
id: FEAT-CJB
kind: feature
priority: low
project_slug: orchestra-web
status: done
title: OAuth2 Authorization Server
type: feature
---

# OAuth2 Authorization Server

New models: OAuthApp, OAuthAuthorization, OAuthAccessToken. Endpoints: GET/POST /oauth/authorize, POST /oauth/token (auth code + refresh grants), GET /oauth/userinfo, POST /oauth/revoke. Full authorization code flow.


---
**in-progress -> in-testing** (2026-03-19T21:56:32Z):
## Changes
- apps/web/internal/models/oauth_app.go (new) — OAuthApp (client_id, client_secret, redirect_uris, scopes, owner_id), OAuthAuthorization (code, scopes, redirect_uri, expires_at, used), OAuthAccessToken (access_token, refresh_token, scopes, expires_at)
- apps/web/internal/handlers/oauth_provider.go (new) — full OAuth2 authorization server: GET /oauth/authorize (consent page data), POST /oauth/authorize (approve/deny → code), POST /oauth/token (authorization_code + refresh_token grants with client secret validation), GET /oauth/userinfo (OIDC profile), POST /oauth/revoke. Admin CRUD: POST/GET/PUT/DELETE /api/admin/oauth-apps. User: GET /settings/connected-apps + DELETE /settings/connected-apps/:app_id. Helper route registration functions.
- apps/web/internal/routes/routes.go — registered OAuth2 provider routes (public, admin, user) via handler registration functions


---
**in-testing -> in-docs** (2026-03-19T21:57:08Z):
## Results
- apps/web/internal/handlers/oauth_provider_test.go (4 tests, all passing):
  - TestOAuthAppModel: verifies model fields and JSON redirect_uris unmarshaling
  - TestOAuthAuthorizationModel: verifies code field and default Used=false
  - TestScopeString: verifies scope array to space-separated string conversion + invalid JSON handling
  - TestExtractBearerTokenFromString: verifies Bearer token extraction logic
- Go compilation clean


---
**in-docs -> in-review** (2026-03-19T21:57:30Z):
## Docs
- docs/oauth2-provider.md (new — models, all endpoints, authorization flow, admin CRUD, user connected apps, token lifecycle, security measures)


---
**Review (approved)** (2026-03-19T21:58:01Z): OAuth2 authorization server with full auth code flow, admin CRUD, user connected apps.
