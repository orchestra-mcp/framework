# Discord OAuth Login

OAuth2 login and account linking for Discord, Google, and GitHub.

## Flow

1. User clicks social button on login page or "Connect" on settings page
2. Browser redirects to `GET /api/auth/oauth/:provider` (login) or `/api/auth/oauth/:provider/connect` (link)
3. Server generates CSRF state, redirects to provider's OAuth consent screen
4. Provider redirects back to `GET /api/auth/oauth/:provider/callback` with authorization code
5. Server exchanges code for access token, fetches user info
6. Login mode: creates/links user, issues JWT, redirects to `/auth/oauth-callback?token=...`
7. Connect mode: links provider account to current user, redirects to `/settings?tab=social`

## Endpoints

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/api/auth/oauth/:provider` | Public | Initiate OAuth login/register |
| GET | `/api/auth/oauth/:provider/callback` | Public | Handle provider callback |
| GET | `/api/auth/oauth/:provider/connect` | Cookie JWT | Link account to authenticated user |

Supported providers: `discord`, `google`, `github`, `slack`.

## Configuration

OAuth credentials are stored in the `integrations` admin setting (`SystemSetting` table, key = `integrations`). Set via the admin panel at Settings > Integrations.

Required fields per provider:
- `discord_client_id` / `discord_client_secret`
- `google_client_id` / `google_client_secret`
- `github_client_id` / `github_client_secret`
- `slack_client_id` / `slack_client_secret`

## Login Behavior

| Scenario | Action |
|----------|--------|
| OAuth account already linked | Log in linked user |
| Email matches existing user | Link OAuth account, log in |
| No matching user | Create new user + OAuth account |

## Connect Behavior

| Scenario | Action |
|----------|--------|
| Provider account linked to another user | Error: "account_linked_to_another_user" |
| Already connected to this user | Update tokens |
| New connection | Create OAuth account link |

## Frontend Pages

- **Login** (`/login`): Social buttons for Google, GitHub, Discord, Slack
- **OAuth Callback** (`/auth/oauth-callback`): Receives JWT token, stores it, redirects to dashboard
- **Settings > Connected Accounts** (`/settings?tab=social`): Shows connected providers with connect/disconnect buttons
- **Admin > Integrations** (`/settings?tab=admin-integrations`): Configure OAuth client credentials

## Security

- CSRF state tokens with 10-minute expiry (in-memory `sync.Map`)
- State validated on callback: provider match + expiry check
- Connect mode reads JWT from `orchestra_token` cookie (browser redirect doesn't send Authorization header)
- Random password generated for OAuth-created users (no password login until user sets one)
- Blocked/suspended users cannot log in via OAuth
