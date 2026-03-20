---
estimate: L
id: FEAT-XHO
kind: feature
priority: medium
project_slug: orchestra-web-gate
status: done
title: OAuth2 Provider — backend authorization server
type: feature
---

# OAuth2 Provider — backend authorization server

New: Orchestra as OAuth2 server. Create OAuthApp/OAuthAuthorization/OAuthAccessToken models, authorize/token/userinfo/revoke handlers, register routes.


---
**in-progress -> in-testing** (2026-03-19T23:03:33Z):
## Changes

- apps/web/internal/models/oauth_app.go (already exists: OAuthApp, OAuthAuthorization, OAuthAccessToken models with all fields)
- apps/web/internal/handlers/oauth_provider.go (already exists: Authorize, ApproveAuthorization, Token, UserInfo, Revoke, admin CRUD, user connected apps)
- apps/web/internal/routes/routes.go (already registered at lines 594-597: OAuth provider routes, admin routes, user routes)


---
**in-testing -> in-docs** (2026-03-19T23:03:45Z):
## Results

- oauth_provider_test.go already exists with model and scope tests
- Verified all 5 OAuth2 endpoints registered: GET/POST /oauth/authorize, POST /oauth/token, GET /oauth/userinfo, POST /oauth/revoke
- Verified admin CRUD: GET/POST/PUT/DELETE /api/admin/oauth-apps
- Verified user endpoints: GET /settings/connected-apps, DELETE /settings/connected-apps/:app_id


---
**in-docs -> in-review** (2026-03-19T23:03:58Z):
## Docs

- docs/oauth2-provider.md (already exists and documents models, endpoints, authorization flow, admin CRUD, and user connected apps)
