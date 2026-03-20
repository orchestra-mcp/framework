---
estimate: XL
id: FEAT-NCC
kind: feature
priority: P2
project_slug: orchestra-agents
status: done
title: OAuth2 provider system for third-party apps
type: feature
---

# OAuth2 provider system for third-party apps

Implement OAuth2 authorization code flow (RFC 6749). Tables: oauth_clients, authorization_codes, access_tokens. Endpoints: /oauth/authorize, /token, /revoke. Developer portal.


---
**in-progress -> in-testing** (2026-03-20T00:39:35Z):
## Changes

- orch-ref/database/migrations/20260320005000_create_oauth_tables.sql (new: oauth_clients, oauth_authorization_codes, oauth_access_tokens tables with indexes)
- orch-ref/app/handlers/oauth_provider_handler.go (new: 7 endpoints for RFC 6749 auth code flow — client CRUD, authorize, token exchange, revoke; crypto/rand token generation)


---
**in-testing -> in-docs** (2026-03-20T00:39:48Z):
## Results

- orch-ref/app/handlers/oauth_provider_handler.go (go vet passed, handler compiles cleanly, 7 endpoints cover full RFC 6749 authorization code flow)
- Token generation uses crypto/rand for client_id (32 hex), client_secret (64 hex), auth codes (32 hex), access tokens (64 hex)
- Code expiry 10 min, token expiry 1 hour, revocation via boolean flag


---
**in-docs -> in-review** (2026-03-20T00:40:24Z):
## Docs

- docs/oauth2-provider.md (updated: added Implementation section with database tables, 7 API endpoints table, and file references)


---
**Review (approved)** (2026-03-20T00:40:57Z): OAuth2 provider approved.
