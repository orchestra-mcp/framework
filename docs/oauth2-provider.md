# OAuth2 Authorization Server

Orchestra acts as an OAuth2 authorization server, allowing third-party applications to authenticate users.

## Models

- **OAuthApp**: client_id, client_secret (bcrypt), redirect_uris (JSON), scopes (JSON), owner_id
- **OAuthAuthorization**: code (unique), scopes, redirect_uri, expires_at, used
- **OAuthAccessToken**: access_token (unique), refresh_token (unique), scopes, expires_at

## Endpoints

### Authorization Flow (Public)

| Method | Path | Description |
|--------|------|-------------|
| GET | `/oauth/authorize?client_id=&redirect_uri=&scope=&response_type=code` | Returns app info for consent page |
| POST | `/oauth/authorize` | Approve/deny (authenticated) → returns redirect URL with code |
| POST | `/oauth/token` | Exchange code for tokens (authorization_code grant) or refresh (refresh_token grant) |
| GET | `/oauth/userinfo` | OIDC user profile (Bearer token required) |
| POST | `/oauth/revoke` | Revoke access/refresh token |

### Admin CRUD

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/admin/oauth-apps` | List all apps |
| POST | `/api/admin/oauth-apps` | Create app (returns client_secret once) |
| GET | `/api/admin/oauth-apps/:id` | Get app |
| PUT | `/api/admin/oauth-apps/:id` | Update app |
| DELETE | `/api/admin/oauth-apps/:id` | Delete app (cascades) |

### User Connected Apps

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/settings/connected-apps` | List apps user has authorized |
| DELETE | `/api/settings/connected-apps/:app_id` | Revoke user's authorization for an app |

## Token Flow

1. App redirects user to `GET /oauth/authorize` with client_id, redirect_uri, scope
2. User approves → `POST /oauth/authorize` → redirect with code (10-min expiry)
3. App exchanges code → `POST /oauth/token` with client_id, client_secret → access_token (1h) + refresh_token
4. App uses `Authorization: Bearer {token}` → `GET /oauth/userinfo` → user profile
5. App refreshes → `POST /oauth/token` with grant_type=refresh_token → rotated token pair

## Security

- Client secrets are bcrypt-hashed (shown only once at creation)
- Authorization codes are single-use with 10-minute expiry
- Access tokens expire after 1 hour
- Refresh tokens rotate on use (old token invalidated)
- Redirect URIs are strictly validated against registered URIs

## Flutter Connected Apps UI

The security settings tab includes a "Connected Apps" section at the bottom:
- Lists apps the user has authorized via `GET /api/settings/connected-apps`
- Shows app name, scopes, and authorization date
- "Revoke" button per app calls `DELETE /api/settings/connected-apps/:app_id`
- Empty state with icon when no apps are connected

## Implementation (2026-03-20)

### Database Tables
- `oauth_clients` — client_id (32 hex), client_secret (64 hex), redirect_uris, scopes, soft delete
- `oauth_authorization_codes` — code (32 hex), 10 min expiry, single-use flag
- `oauth_access_tokens` — token (64 hex), 1 hour expiry, revocation flag

### API Endpoints
| Method | Path | Auth | Description |
|--------|------|------|-------------|
| POST | `/api/oauth/clients` | Yes | Create OAuth client |
| GET | `/api/oauth/clients` | Yes | List user's clients |
| DELETE | `/api/oauth/clients/:id` | Yes | Delete client (owner) |
| GET | `/oauth/authorize` | Yes | Consent page data |
| POST | `/oauth/authorize` | Yes | Generate auth code |
| POST | `/oauth/token` | No | Exchange code for token |
| POST | `/oauth/revoke` | No | Revoke access token |

### Files
- `orch-ref/database/migrations/20260320005000_create_oauth_tables.sql`
- `orch-ref/app/handlers/oauth_provider_handler.go`
