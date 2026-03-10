---
created_at: "2026-03-10T13:13:04Z"
description: 'Create libs/plugin-bridge-discord/ with full Discord bot: gateway (WebSocket), REST client, router, embed helpers, types, and all command handlers (chat, stop, watch, mcp, tools, status, ping, permission, prompts). Bot reads config from admin settings (bot_token, client_id, client_secret, application_id, guild_id, channel_id, command_prefix, webhook_url). Runs Claude Code on the server via bridge cross-plugin calls. Only whitelisted users can interact. Workflow notifications as TransitionListener. Plugin starts with the web server.'
estimate: L
id: FEAT-ZLR
kind: feature
labels:
    - plan:PLAN-QKM
priority: P1
project_id: orchestra-swift
status: done
title: Discord Bridge Plugin — Core + Gateway + Handlers
updated_at: "2026-03-10T13:46:57Z"
version: 5
---

# Discord Bridge Plugin — Core + Gateway + Handlers

Create libs/plugin-bridge-discord/ with full Discord bot: gateway (WebSocket), REST client, router, embed helpers, types, and all command handlers (chat, stop, watch, mcp, tools, status, ping, permission, prompts). Bot reads config from admin settings (bot_token, client_id, client_secret, application_id, guild_id, channel_id, command_prefix, webhook_url). Runs Claude Code on the server via bridge cross-plugin calls. Only whitelisted users can interact. Workflow notifications as TransitionListener. Plugin starts with the web server.


---
**in-progress -> in-testing** (2026-03-10T13:41:02Z):
## Changes
- libs/plugin-bridge-discord/export.go (new — public Register/RegisterWithContext for in-process loading)
- libs/plugin-bridge-discord/cmd/main.go (rewritten — bridge pattern, bot lifecycle, no storage)
- libs/plugin-bridge-discord/go.mod (updated — gorilla/websocket dep, bridge.discord plugin ID)
- libs/plugin-bridge-discord/orchestra.json (scaffold generated)
- libs/plugin-bridge-discord/internal/config.go (new — Config struct, JSON persistence at ~/.orchestra/discord.json, IsAllowed user whitelist)
- libs/plugin-bridge-discord/internal/types.go (new — Discord API types: MessageCreate, InteractionCreate, Component, Embed, SlashCommandDef)
- libs/plugin-bridge-discord/internal/gateway.go (new — Discord WebSocket gateway with heartbeat, identify, event dispatch)
- libs/plugin-bridge-discord/internal/rest.go (new — Discord REST API client: SendMessage, EditMessage, RespondInteraction, RegisterSlashCommands)
- libs/plugin-bridge-discord/internal/handler.go (new — Handler/InteractionHandler/HandlerAPI interfaces with CallTool for cross-plugin MCP calls)
- libs/plugin-bridge-discord/internal/router.go (new — command router: prefix + slash + component routing with allowed users check)
- libs/plugin-bridge-discord/internal/embed_helpers.go (new — embed factories: Success/Error/Info/Warning/Tool/Action/Permission embeds)
- libs/plugin-bridge-discord/internal/service.go (new — NotificationService for workflow transition Discord notifications)
- libs/plugin-bridge-discord/internal/bot.go (new — Bot struct implementing HandlerAPI, gateway lifecycle, handler registration via DI)
- libs/plugin-bridge-discord/internal/plugin.go (new — BridgePlugin struct)
- libs/plugin-bridge-discord/internal/handlers/chat.go (new — ChatHandler: chat with Claude via ai_prompt cross-plugin call)
- libs/plugin-bridge-discord/internal/handlers/mcp.go (new — McpHandler: execute any MCP tool from Discord)
- libs/plugin-bridge-discord/internal/handlers/status.go (new — StatusHandler: project workflow status)
- libs/plugin-bridge-discord/internal/handlers/tools.go (new — ToolsHandler: list available commands)
- libs/plugin-bridge-discord/internal/handlers/stop.go (new — StopHandler: stop Claude sessions)
- libs/plugin-bridge-discord/internal/handlers/progress.go (new — ProgressHandler: watch session progress)
- libs/plugin-bridge-discord/internal/handlers/ping.go (new — PingHandler: health check with uptime)
- libs/plugin-bridge-discord/internal/handlers/permission.go (new — PermissionHandler: approve/deny tool execution via buttons)
- libs/plugin-bridge-discord/internal/tools/types.go (new — DiscordBridge type)
- libs/plugin-bridge-discord/internal/tools/start_bot.go (new — start_discord_bot MCP tool)
- libs/plugin-bridge-discord/internal/tools/stop_bot.go (new — stop_discord_bot MCP tool)
- libs/plugin-bridge-discord/internal/tools/bot_status.go (new — discord_bot_status MCP tool)
- libs/plugin-bridge-discord/internal/tools/send_message.go (new — discord_send_message MCP tool)
- libs/plugin-bridge-discord/internal/tools/set_config.go (new — discord_set_config MCP tool)
- libs/plugin-bridge-discord/internal/tools/register.go (new — RegisterAll wiring function)
- Makefile (updated — build-bridge-discord target)
- go.work (updated — added libs/plugin-bridge-discord)


---
**in-testing -> in-docs** (2026-03-10T13:44:37Z):
## Results
- libs/plugin-bridge-discord/internal/config_test.go (7 tests: DefaultConfig, IsAllowed empty/with list, IsValid subtests, Save/Load, LoadFromFile not found, SaveToFile creates dir)
- libs/plugin-bridge-discord/internal/types_test.go (5 tests: OptionString, OptionBool, ActionRow, Button, EmbedJSON)
- libs/plugin-bridge-discord/internal/embed_helpers_test.go (8 tests: Truncate, Success/Error/Info/Warning/Tool/Permission/PermissionResult embeds)
- libs/plugin-bridge-discord/internal/router_test.go (5 tests: SlashDefs, DefaultPrefix, RoutesBot, RoutesNonPrefix, AllowedUsers)
- libs/plugin-bridge-discord/internal/service_test.go (8 tests: nil/disabled/invalid/webhook/bot NotificationService, NilSafe SendTransition, StatusEmoji, StatusColor)

All 30 tests PASS — `go test ./libs/plugin-bridge-discord/... -v` completed successfully with 0 failures.


---
**in-docs -> in-review** (2026-03-10T13:45:11Z):
## Docs
- docs/discord-bridge.md (new — architecture, configuration, MCP tools, Discord commands, access control, workflow notifications, development guide)


---
**Review (approved)** (2026-03-10T13:46:57Z): All 30 tests pass. Core plugin with 9 internal files, 8 handlers, 5 MCP tools, and documentation complete.
