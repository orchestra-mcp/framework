# Slack Bridge Plugin

Slack bot bridge for Orchestra MCP — interact with Claude and MCP tools from Slack.

## Architecture

The plugin at `libs/plugin-bridge-slack/` connects to Slack via Socket Mode (WebSocket) and routes messages, slash commands, and button interactions to handlers that call MCP tools via cross-plugin bridge.

```
Slack (Socket Mode WebSocket)
  └─ Gateway (connect, ack envelopes, dispatch)
       └─ Router (prefix commands, slash commands, interactions)
            └─ Handlers (chat, mcp, ping, status, tools, stop, progress, permission)
                 └─ HandlerAPI (send messages, call MCP tools)
```

## Setup

### Slack App Configuration

1. Create a Slack app at https://api.slack.com/apps
2. Enable **Socket Mode** (Settings > Socket Mode > Enable)
3. Create an **App-Level Token** with `connections:write` scope → gives you `xapp-...` token
4. Add **Bot Token Scopes** (OAuth & Permissions):
   - `chat:write` — send messages
   - `commands` — slash commands
   - `app_mentions:read` — optional
5. Install the app to your workspace → gives you `xoxb-...` bot token
6. Subscribe to **Event Subscriptions** (bot events):
   - `message.channels` — messages in public channels
   - `message.groups` — messages in private channels
   - `message.im` — direct messages
7. Create **Slash Commands** as needed: `/chat`, `/mcp`, `/ping`, `/status`, `/tools`, `/stop`, `/watch`

### Orchestra Configuration

Set via `slack_set_config` MCP tool or edit `~/.orchestra/slack.json`:

```json
{
    "enabled": true,
    "bot_token": "xoxb-...",
    "app_token": "xapp-...",
    "signing_secret": "abc123...",
    "app_id": "A12345",
    "channel_id": "C67890",
    "command_prefix": "!",
    "webhook_url": "",
    "allowed_users": [],
    "team_id": "T11111"
}
```

| Field | Required | Description |
|-------|----------|-------------|
| `bot_token` | Yes | Bot user OAuth token (`xoxb-...`) |
| `app_token` | Yes | App-level token for Socket Mode (`xapp-...`) |
| `signing_secret` | No | For verifying Slack request signatures |
| `app_id` | No | Slack app ID |
| `channel_id` | No | Default channel for notifications |
| `command_prefix` | No | Prefix for text commands (default: `!`) |
| `webhook_url` | No | Incoming webhook URL (alternative to bot) |
| `allowed_users` | No | Slack user IDs allowed to use the bot (empty = all) |
| `team_id` | No | Slack workspace/team ID |

## MCP Tools

| Tool | Description |
|------|-------------|
| `start_slack_bot` | Start the Slack bot (connects Socket Mode) |
| `stop_slack_bot` | Stop the Slack bot |
| `slack_bot_status` | Get bot status (running/stopped, config summary) |
| `slack_send_message` | Send a message to a Slack channel |
| `slack_set_config` | Update Slack bot configuration |

## Bot Commands

### Prefix Commands (default prefix: `!`)

| Command | Description |
|---------|-------------|
| `!chat <prompt>` | Chat with Claude AI |
| `!mcp <tool> [json-args]` | Execute any MCP tool |
| `!ping` | Health check (uptime, platform) |
| `!status [project]` | Show project workflow status |
| `!tools` | List available commands |
| `!stop [session_id]` | Stop a Claude session |
| `!watch [session_id]` | Watch session progress |

### Slash Commands

| Command | Description |
|---------|-------------|
| `/chat <prompt>` | Chat with Claude AI |
| `/mcp tool:<name> args:<json>` | Execute MCP tool |
| `/ping` | Health check |
| `/status` | Project status |
| `/tools` | List commands |
| `/stop` | Stop session |
| `/watch` | Watch progress |

### Button Interactions

- **Permission approve/deny** — When Claude needs permission for a tool, buttons appear in Slack for approve/deny decisions

## Message Format

Uses Slack Block Kit for rich formatting:
- **Headers** — `plain_text` header blocks
- **Sections** — `mrkdwn` text blocks for content
- **Context** — Small metadata text
- **Actions** — Buttons for interactive decisions
- **Attachments** — Colored sidebar (green=success, red=error, blue=info, orange=warning)

## Notifications

The `NotificationService` sends workflow transition notifications to Slack when features change status. Uses webhook URL if configured, falls back to `chat.postMessage` with bot token.

Status emojis: :clipboard: todo, :hammer: in-progress, :microscope: in-testing, :writing_hand: in-docs, :eyes: in-review, :white_check_mark: done

## Direct AI Chat (@mentions & DMs)

Users can chat with Orchestra directly without any command prefix:

- **@mention in a channel** — `@Orchestra what is Go?` routes to AI chat
- **Direct message** — Any DM to the bot routes to AI chat

The router's `RouteDirect` method handles both cases:
1. Strips the `<@UBOTID>` mention tag from the beginning of the message
2. Prepends `chat ` so the chat handler processes it as an AI prompt
3. Ignores bot messages, unauthorized users, empty text, and bare mentions with no content

### Required Event Subscriptions

To enable direct chat, add these bot events in your Slack app settings:
- `app_mention` — triggers when someone @mentions the bot in a channel
- `message.im` — triggers for direct messages to the bot

### How It Works

```
User: @Orchestra explain QUIC protocol
  → RouteDirect strips mention → "explain QUIC protocol"
  → Prepends "chat " → "chat explain QUIC protocol"
  → Chat handler calls ai_prompt tool → Claude responds
  → Response posted back to channel
```

DMs (channels starting with `D`) are automatically routed through `RouteDirect`. Regular channel messages still require the command prefix (e.g., `!chat`).

## Access Control

When `allowed_users` is set (non-empty array of Slack user IDs), only those users can interact with the bot. Empty list allows all workspace members.

## Differences from Discord Bridge

| Aspect | Discord | Slack |
|--------|---------|-------|
| Connection | WebSocket Gateway v10 | Socket Mode (WebSocket) |
| Auth | `Bot {token}` | `Bearer {token}` (xoxb + xapp) |
| Messages | Embeds (title, description, color) | Block Kit + Attachments |
| Commands | Registered via API | Configured in Slack dashboard |
| Interactions | Component interactions | `block_actions` via Socket Mode |
| Config path | `~/.orchestra/discord.json` | `~/.orchestra/slack.json` |
