# Discord Admin Settings

Admin panel configuration for the Discord bot, accessible at Settings > Discord Bot (admin only).

## Settings Key

Stored in the `SystemSetting` table under the key `discord`. Managed via `GET/PATCH /api/admin/settings/discord`.

## Configuration Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `enabled` | boolean | `false` | Master toggle — bot starts on server launch if true |
| `bot_token` | string | `""` | Discord bot token |
| `application_id` | string | `""` | Discord application ID |
| `client_id` | string | `""` | OAuth client ID (for Discord login) |
| `client_secret` | string | `""` | OAuth client secret |
| `guild_id` | string | `""` | Guild ID for slash commands |
| `channel_id` | string | `""` | Default channel for notifications |
| `command_prefix` | string | `"!"` | Prefix for text commands |
| `webhook_url` | string | `""` | Webhook URL for notifications |
| `allowed_users` | string[] | `[]` | Discord usernames allowed to interact (empty = all) |

## Security

The `discord` settings key is NOT in `publicKeys` — it requires admin authentication to read or write, protecting sensitive fields like `bot_token` and `client_secret`.

## Frontend Location

Settings > Admin section > Discord Bot tab (`/settings?tab=admin-discord`)

Three sections:
1. **Bot Configuration** — Enabled toggle, bot token, application ID, guild/channel IDs, prefix, webhook
2. **OAuth Credentials** — Client ID and secret (also used by Discord OAuth login flow)
3. **Allowed Users** — Comma-separated list of Discord usernames

## Auto-Start

When `enabled` is `true` and the bot token is configured, the Discord bot starts automatically with the web server. The bot reads its configuration from the admin settings on startup.
