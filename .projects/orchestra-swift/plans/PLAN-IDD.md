---
created_at: "2026-03-10T14:18:08Z"
description: |-
    Build full Slack integration mirroring all three Discord features: bridge plugin, OAuth login, and admin settings.

    1. **Slack Bridge Plugin** — `libs/plugin-bridge-slack/` with Slack Events API/Socket Mode, command handlers, MCP tools
    2. **Slack OAuth Login + Connected Account** — Add `slack` provider to OAuth handler, login page, connected accounts
    3. **Admin Slack Bot Settings** — Admin settings key `slack` with bot_token, signing_secret, app_id, channel_id, allowed_users; admin-slack tab in settings UI
features:
    - FEAT-MXX
    - FEAT-QHR
    - FEAT-PWB
id: PLAN-IDD
project_id: orchestra-swift
status: completed
title: Slack Integration (Mirror Discord)
updated_at: "2026-03-10T15:05:19Z"
version: 3
---

# Slack Integration (Mirror Discord)

Build full Slack integration mirroring all three Discord features: bridge plugin, OAuth login, and admin settings.

1. **Slack Bridge Plugin** — `libs/plugin-bridge-slack/` with Slack Events API/Socket Mode, command handlers, MCP tools
2. **Slack OAuth Login + Connected Account** — Add `slack` provider to OAuth handler, login page, connected accounts
3. **Admin Slack Bot Settings** — Admin settings key `slack` with bot_token, signing_secret, app_id, channel_id, allowed_users; admin-slack tab in settings UI
