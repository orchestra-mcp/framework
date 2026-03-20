---
estimate: M
id: FEAT-OOJ
kind: feature
priority: medium
project_slug: orchestra-web-gate
status: done
title: OAuth2 Provider — admin CRUD and connected apps UI
type: feature
---

# OAuth2 Provider — admin CRUD and connected apps UI

Admin OAuth app CRUD endpoints. Flutter connected apps settings showing authorized apps with revoke.


---
**in-progress -> in-testing** (2026-03-19T23:04:48Z):
## Changes

- apps/flutter/lib/screens/settings/tabs/security_settings_tab.dart (already exists: _ConnectedAppsList widget with fetch, revoke, and empty state; _ConnectedAppRow with app icon, name, scopes, and revoke button)
- apps/web/internal/handlers/oauth_provider.go (already has admin CRUD: ListApps, CreateApp, GetApp, UpdateApp, DeleteApp — all registered in routes.go)


---
**in-testing -> in-docs** (2026-03-19T23:04:56Z):
## Results

- Verified Flutter connected apps: fetches GET /api/settings/connected-apps, displays app list with icon/name/scopes, revoke calls DELETE /api/settings/connected-apps/:app_id
- Verified backend admin CRUD: 5 endpoints registered under /api/admin/oauth-apps (list, create, get, update, delete)
- oauth_provider_test.go test file already exists with model and scope tests


---
**in-docs -> in-review** (2026-03-19T23:05:14Z):
## Docs

- docs/oauth2-provider.md (already documents admin CRUD endpoints, user connected apps endpoints, and Flutter connected apps UI)
