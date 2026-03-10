---
created_at: "2026-03-10T14:18:25Z"
description: Create libs/plugin-bridge-slack/ mirroring Discord bridge plugin. Implement Slack Events API / Socket Mode gateway, REST client, command router with allowed-users check, notification service for workflow transitions, embed helpers (Block Kit), and 5 MCP tools (start_bot, stop_bot, bot_status, send_message, set_config). Scaffold with scripts/new-plugin.sh.
estimate: L
id: FEAT-MXX
kind: feature
labels:
    - plan:PLAN-IDD
priority: P1
project_id: orchestra-swift
status: done
title: Slack Bridge Plugin
updated_at: "2026-03-10T14:37:46Z"
version: 5
---

# Slack Bridge Plugin

Create libs/plugin-bridge-slack/ mirroring Discord bridge plugin. Implement Slack Events API / Socket Mode gateway, REST client, command router with allowed-users check, notification service for workflow transitions, embed helpers (Block Kit), and 5 MCP tools (start_bot, stop_bot, bot_status, send_message, set_config). Scaffold with scripts/new-plugin.sh.


---
**in-progress -> in-testing** (2026-03-10T14:33:13Z):
## Changes
- libs/plugin-bridge-slack/orchestra.json (plugin manifest)
- libs/plugin-bridge-slack/go.mod (module definition)
- libs/plugin-bridge-slack/export.go (public Register/RegisterWithContext)
- libs/plugin-bridge-slack/cmd/main.go (standalone binary entry)
- libs/plugin-bridge-slack/internal/config.go (Slack config with BotToken, AppToken, SigningSecret, etc.)
- libs/plugin-bridge-slack/internal/types.go (Slack event types: SocketModeEnvelope, MessageEvent, SlashCommandPayload, InteractionPayload, Block Kit types)
- libs/plugin-bridge-slack/internal/gateway.go (Socket Mode WebSocket with envelope acknowledgement)
- libs/plugin-bridge-slack/internal/rest.go (Slack Web API client: chat.postMessage, chat.update, response_url)
- libs/plugin-bridge-slack/internal/handler.go (Handler interfaces for Slack)
- libs/plugin-bridge-slack/internal/router.go (Event routing for messages, slash commands, interactions)
- libs/plugin-bridge-slack/internal/block_helpers.go (Block Kit utilities: SuccessBlocks, ErrorBlocks, InfoBlocks, etc.)
- libs/plugin-bridge-slack/internal/service.go (NotificationService for workflow transitions)
- libs/plugin-bridge-slack/internal/bot.go (Bot orchestrator with Socket Mode dispatch)
- libs/plugin-bridge-slack/internal/plugin.go (BridgePlugin struct)
- libs/plugin-bridge-slack/internal/tools/register.go (5 MCP tools registration)
- libs/plugin-bridge-slack/internal/tools/types.go (SlackBridge struct)
- libs/plugin-bridge-slack/internal/tools/start_bot.go
- libs/plugin-bridge-slack/internal/tools/stop_bot.go
- libs/plugin-bridge-slack/internal/tools/bot_status.go
- libs/plugin-bridge-slack/internal/tools/send_message.go
- libs/plugin-bridge-slack/internal/tools/set_config.go
- libs/plugin-bridge-slack/internal/handlers/chat.go (Chat with Claude)
- libs/plugin-bridge-slack/internal/handlers/mcp.go (Execute MCP tools)
- libs/plugin-bridge-slack/internal/handlers/permission.go (Approve/deny buttons)
- libs/plugin-bridge-slack/internal/handlers/ping.go (Health check)
- libs/plugin-bridge-slack/internal/handlers/progress.go (Session progress)
- libs/plugin-bridge-slack/internal/handlers/status.go (Project status)
- libs/plugin-bridge-slack/internal/handlers/stop.go (Stop sessions)
- libs/plugin-bridge-slack/internal/handlers/tools.go (List commands)


---
**in-testing -> in-docs** (2026-03-10T14:36:50Z):
## Results
- libs/plugin-bridge-slack/internal/config_test.go (13 tests: default config, IsAllowed, IsValid, save/load, missing file, invalid JSON, empty prefix, config path)
- libs/plugin-bridge-slack/internal/types_test.go (15 tests: SocketModeEnvelope, MessageEvent, SlashCommandPayload, InteractionPayload, BlockText, SectionBlock, HeaderBlock, DividerBlock, ButtonElement, ActionsBlock, ContextBlock)
- libs/plugin-bridge-slack/internal/block_helpers_test.go (22 tests: SuccessBlocks, ErrorBlocks, InfoBlocks, WarningBlocks, ToolBlocks, ActionBlocks, PermissionBlocks, PermissionResultBlocks, Truncate, toolEmoji, humanToolName, shortPath, formatToolInput)
- libs/plugin-bridge-slack/internal/router_test.go (9 tests: RouteMessage matching, bot ignore, reject unallowed, no prefix, default handler, slash command routing, slash reject, default/custom prefix)
- libs/plugin-bridge-slack/internal/service_test.go (8 tests: nil/disabled/no-webhook service creation, webhook/bot service creation, nil receiver, webhook delivery, statusEmoji)

All 64 tests pass: `ok github.com/orchestra-mcp/plugin-bridge-slack/internal 1.031s`


---
**in-docs -> in-review** (2026-03-10T14:37:30Z):
## Docs
- docs/slack-bridge.md (new — architecture, setup, Slack app config, MCP tools, bot commands, slash commands, Block Kit format, notifications, access control, Discord comparison)


---
**Review (approved)** (2026-03-10T14:37:46Z): Slack Bridge Plugin approved. 29 source files, 64 tests passing, full documentation.
