---
created_at: "2026-03-10T11:45:46Z"
description: |-
    Full Discord integration:

    1. **Discord Bridge Plugin** (libs/plugin-bridge-discord/) — Bot connects to Discord using config from admin settings (client_id, client_secret, bot_token, etc.). Runs Claude Code on the server, responds to users in Discord channels. Commands: chat, stop, watch, mcp, tools, status, ping, permission. Session management, workflow notifications, streaming responses. Only whitelisted users can interact (managed from admin panel).

    2. **Discord OAuth Login** — Login with Discord on the web app. OAuth2 flow (authorization code grant). Shows Discord as connected account in user settings.

    3. **Admin Settings — Discord Config** — Admin panel tab for Discord bot config (bot_token, client_id, client_secret, application_id, guild_id, channel_id, command_prefix, webhook_url, enabled toggle, allowed user IDs/roles).

    4. **User Settings — Connected Accounts** — Discord shows up in connected accounts. Link/unlink Discord account. Shows Discord username/avatar.

    5. **Web Settings — Discord User Management** — Admin can manage which Discord users are allowed to use the bot.
features:
    - FEAT-ZLR
    - FEAT-MWZ
    - FEAT-SCS
id: PLAN-QKM
project_id: orchestra-swift
status: completed
title: Discord Bridge Plugin + OAuth + Web Settings
updated_at: "2026-03-10T14:11:52Z"
version: 4
---

# Discord Bridge Plugin + OAuth + Web Settings

Full Discord integration:

1. **Discord Bridge Plugin** (libs/plugin-bridge-discord/) — Bot connects to Discord using config from admin settings (client_id, client_secret, bot_token, etc.). Runs Claude Code on the server, responds to users in Discord channels. Commands: chat, stop, watch, mcp, tools, status, ping, permission. Session management, workflow notifications, streaming responses. Only whitelisted users can interact (managed from admin panel).

2. **Discord OAuth Login** — Login with Discord on the web app. OAuth2 flow (authorization code grant). Shows Discord as connected account in user settings.

3. **Admin Settings — Discord Config** — Admin panel tab for Discord bot config (bot_token, client_id, client_secret, application_id, guild_id, channel_id, command_prefix, webhook_url, enabled toggle, allowed user IDs/roles).

4. **User Settings — Connected Accounts** — Discord shows up in connected accounts. Link/unlink Discord account. Shows Discord username/avatar.

5. **Web Settings — Discord User Management** — Admin can manage which Discord users are allowed to use the bot.
