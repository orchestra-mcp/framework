# Slack Admin Settings

Admin panel configuration for the Slack bot (Socket Mode), accessible at Settings > Slack Bot (admin only).

## Settings Key

Stored in the `SystemSetting` table under the key `slack`. Managed via `GET/PATCH /api/admin/settings/slack`.

## Configuration Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `enabled` | boolean | `false` | Master toggle — bot connects via Socket Mode on server launch if true |
| `bot_token` | string | `""` | Slack bot token (`xoxb-...`) |
| `app_token` | string | `""` | App-level token for Socket Mode (`xapp-...`) |
| `signing_secret` | string | `""` | Slack app signing secret (for request verification) |
| `app_id` | string | `""` | Slack app ID |
| `channel_id` | string | `""` | Default channel for notifications |
| `team_id` | string | `""` | Slack team/workspace ID |
| `command_prefix` | string | `"!"` | Prefix for text commands |
| `webhook_url` | string | `""` | Incoming webhook URL for notifications |
| `allowed_users` | string[] | `[]` | Slack user IDs allowed to interact (empty = all) |

## Security

The `slack` settings key is NOT in `publicKeys` — it requires admin authentication to read or write, protecting sensitive fields like `bot_token`, `app_token`, and `signing_secret`.

## Frontend Location

Settings > Admin section > Slack Bot tab (`/settings?tab=admin-slack`)

Two sections:
1. **Bot Configuration** — Enabled toggle, bot token, app-level token, signing secret, app ID, channel/team IDs, prefix, webhook URL
2. **Allowed Users** — Comma-separated list of Slack user IDs (e.g., `U12345ABC`)

## Slack App Setup

1. Create a Slack app at https://api.slack.com/apps
2. Enable **Socket Mode** under Settings > Socket Mode
3. Generate an **App-Level Token** with `connections:write` scope — this is the `app_token`
4. Under **OAuth & Permissions**, add bot token scopes: `chat:write`, `channels:read`, `users:read`
5. Install the app to your workspace — copy the **Bot Token** (`xoxb-...`)
6. Copy **Signing Secret** from Basic Information
7. Enter all credentials in Admin > Settings > Slack Bot

## Auto-Start

When `enabled` is `true` and both `bot_token` and `app_token` are configured, the Slack bot connects via Socket Mode automatically with the web server. The bot reads its configuration from the admin settings on startup.
