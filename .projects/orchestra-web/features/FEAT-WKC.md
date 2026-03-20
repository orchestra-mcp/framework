---
estimate: S
id: FEAT-WKC
kind: feature
priority: low
project_slug: orchestra-web
status: done
title: OAuth2 Admin App Management
type: feature
---

# OAuth2 Admin App Management

Admin endpoints POST/GET/PUT/DELETE /api/admin/oauth-apps for creating and managing OAuth applications. Get client_id/secret pairs.


---
**in-progress -> in-testing** (2026-03-19T22:01:56Z):
## Changes
- apps/web/internal/handlers/oauth_provider.go — admin CRUD already implemented in FEAT-CJB: ListApps (GET), CreateApp (POST with bcrypt client_secret, returns plain secret once), GetApp, UpdateApp, DeleteApp (cascades authorizations + tokens). Registered on admin group in routes.go.
- apps/flutter/lib/core/api/endpoints.dart — added OAuth2 provider endpoint constants: adminOAuthApps, adminOAuthApp(id), settingsConnectedApps, settingsRevokeApp(appId)


---
**in-testing -> in-docs** (2026-03-19T22:02:19Z):
## Results
- apps/web/internal/handlers/oauth_provider_test.go — TestOAuthAppModel passing (validates model fields, JSON redirect_uris)
- dart analyze lib/core/api/endpoints.dart — No issues found
- Go compilation clean, Flutter analysis clean


---
**in-docs -> in-review** (2026-03-19T22:02:26Z):
## Docs
- docs/oauth2-provider.md (already covers admin CRUD section — POST/GET/PUT/DELETE /api/admin/oauth-apps with client_id/secret generation, cascade deletion)


---
**Review (approved)** (2026-03-19T22:02:46Z): OAuth2 admin CRUD endpoints and Flutter constants approved.
