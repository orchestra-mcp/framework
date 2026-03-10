# Discord Bridge Plugin

The `bridge.discord` plugin connects Orchestra MCP to Discord, allowing team members to manage projects, run AI prompts, and receive workflow notifications directly from Discord channels.

## Architecture

```
Discord Gateway (WebSocket)
    ↓
Bot (internal/bot.go)
    ↓
Router (internal/router.go)
    ↓
Handlers (internal/handlers/)
    ↓
Cross-plugin MCP calls (api.CallTool)
    ↓
Orchestra MCP tools (ai_prompt, list_features, etc.)
```

The plugin follows the **bridge pattern** (like `bridge-claude`): in-memory state, no storage dependency, direct cross-plugin tool calls via `CallTool()`.

## Configuration

Config is stored at `~/.orchestra/discord.json`:

```json
{
  "enabled": true,
  "bot_token": "Bot MTIz...",
  "application_id": "123456789",
  "guild_id": "987654321",
  "channel_id": "111222333",
  "command_prefix": "!",
  "webhook_url": "https://discord.com/api/webhooks/...",
  "allowed_users": ["user1#1234", "user2#5678"]
}
```

| Field | Required | Description |
|-------|----------|-------------|
| `enabled` | Yes | Master toggle |
| `bot_token` | Yes* | Discord bot token |
| `application_id` | Yes* | Discord application ID |
| `guild_id` | No | Guild for slash commands (global if empty) |
| `channel_id` | No | Default channel for notifications |
| `command_prefix` | No | Prefix for text commands (default: `!`) |
| `webhook_url` | Alt* | Webhook URL (alternative to bot token) |
| `allowed_users` | No | Whitelist of allowed Discord users (empty = allow all) |

*Either `bot_token` + `application_id` or `webhook_url` is required.

## MCP Tools

| Tool | Description |
|------|-------------|
| `start_discord_bot` | Start the Discord bot |
| `stop_discord_bot` | Stop the Discord bot |
| `discord_bot_status` | Get bot connection status |
| `discord_send_message` | Send a message to a channel |
| `discord_set_config` | Update bot configuration |

## Discord Commands

### Prefix Commands (default: `!`)

| Command | Handler | Description |
|---------|---------|-------------|
| `!chat` | ChatHandler | AI chat session (sticky channel mapping) |
| `!mcp <tool> [args]` | McpHandler | Execute any MCP tool |
| `!status` | StatusHandler | Project status overview |
| `!tools` | ToolsHandler | List available commands/features |
| `!stop` | StopHandler | Stop active AI sessions |
| `!progress` | ProgressHandler | Check AI session progress |
| `!ping` | PingHandler | Bot health check |
| `!permission` | PermissionHandler | Approve/deny pending permissions |

### Slash Commands

All prefix commands are also registered as slash commands (`/chat`, `/mcp`, etc.).

### Button Interactions

The permission handler uses Discord buttons for approve/deny actions with `custom_id` routing.

## Access Control

When `allowed_users` is configured, only listed Discord users can interact with the bot. Messages from unauthorized users are silently ignored. The whitelist is managed via admin settings or the `discord_set_config` MCP tool.

## Workflow Notifications

The `NotificationService` implements transition notifications. When a feature changes status, the bot sends an embed to the configured channel with:

- Status emoji and color coding
- Feature ID and title
- Old and new status
- Project context

## Running

The bot auto-starts with Orchestra when `enabled: true` and config is valid. It can also be controlled via MCP tools:

```
# Via MCP
start_discord_bot
stop_discord_bot
discord_bot_status
```

## Development

```bash
# Build
make build-bridge-discord

# Test
go test ./libs/plugin-bridge-discord/... -v

# Run standalone
bin/bridge-discord --workspace .
```

## Dependencies

- `gorilla/websocket` — Discord Gateway WebSocket connection
- `github.com/orchestra-mcp/sdk-go` — Plugin SDK
