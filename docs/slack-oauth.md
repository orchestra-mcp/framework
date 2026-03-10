# Slack OAuth Login

OAuth2 login and account linking for Slack, extending the existing multi-provider OAuth system.

## Slack-Specific Details

### OAuth Flow

Slack uses OAuth v2 (`oauth.v2.access`) which differs from standard OAuth:

1. **Auth URL**: `https://slack.com/oauth/v2/authorize` with `user_scope` parameter (not `scope`)
2. **Scopes**: `identity.basic,identity.email,identity.avatar` (comma-separated, not space-separated)
3. **Token Exchange**: `POST https://slack.com/api/oauth.v2.access` — returns access token nested under `authed_user.access_token`
4. **User Info**: `GET https://slack.com/api/users.identity` — returns user data nested under `user` key

### Token Response Format

```json
{
  "ok": true,
  "authed_user": {
    "id": "U12345",
    "access_token": "xoxp-user-token",
    "scope": "identity.basic,identity.email"
  }
}
```

The handler extracts `authed_user.access_token` when the top-level `access_token` is empty.

### User Info Response Format

```json
{
  "ok": true,
  "user": {
    "id": "U67890",
    "name": "John Doe",
    "email": "john@example.com",
    "image_192": "https://avatars.slack-edge.com/user-192.png"
  },
  "team": {
    "id": "T11111"
  }
}
```

The handler extracts fields from the nested `user` object when top-level fields are empty.

### Slack App Setup

1. Create a Slack app at https://api.slack.com/apps
2. Under **OAuth & Permissions**, add redirect URL: `https://your-domain/api/auth/oauth/slack/callback`
3. Under **User Token Scopes**, add: `identity.basic`, `identity.email`, `identity.avatar`
4. Copy **Client ID** and **Client Secret** from Basic Information
5. Enter credentials in Admin > Settings > Integrations > Slack OAuth

### Configuration

Set in admin panel at Settings > Integrations:
- `slack_client_id` — Slack app Client ID
- `slack_client_secret` — Slack app Client Secret

### Frontend

- Login page shows Slack button (purple, `bxl-slack` icon)
- Settings > Connected Accounts shows Slack with connect/disconnect
- Admin > Integrations shows Slack OAuth client ID/secret fields

### Avatar

Slack provides avatar URLs directly (e.g., `https://avatars.slack-edge.com/...`), so no URL construction is needed (unlike Discord which returns a hash).
