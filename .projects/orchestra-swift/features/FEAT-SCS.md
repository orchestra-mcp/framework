---
created_at: "2026-03-10T13:13:04Z"
description: 'Add Discord admin settings tab in apps/next/ settings page: (1) New admin-discord tab with fields for bot_token, client_id, client_secret, application_id, guild_id, channel_id, command_prefix, webhook_url, enabled toggle, (2) Allowed users management — admin can add/remove Discord user IDs or roles that are permitted to use the bot, (3) Go backend admin API endpoints for reading/writing discord settings, (4) Bot auto-starts when web server starts if enabled in settings.'
estimate: M
id: FEAT-SCS
kind: feature
labels:
    - plan:PLAN-QKM
priority: P1
project_id: orchestra-swift
status: done
title: Admin Discord Bot Settings + User Management UI
updated_at: "2026-03-10T14:11:44Z"
version: 5
---

# Admin Discord Bot Settings + User Management UI

Add Discord admin settings tab in apps/next/ settings page: (1) New admin-discord tab with fields for bot_token, client_id, client_secret, application_id, guild_id, channel_id, command_prefix, webhook_url, enabled toggle, (2) Allowed users management — admin can add/remove Discord user IDs or roles that are permitted to use the bot, (3) Go backend admin API endpoints for reading/writing discord settings, (4) Bot auto-starts when web server starts if enabled in settings.


---
**in-progress -> in-testing** (2026-03-10T14:09:24Z):
## Changes
- apps/web/internal/handlers/admin_settings.go (added 'discord' to validKeys, added default discord settings with bot_token, application_id, client_id, client_secret, guild_id, channel_id, command_prefix, webhook_url, enabled, allowed_users)
- apps/next/src/app/(app)/settings/page.tsx (added 'admin-discord' to Tab type, added full Admin Discord Bot settings panel with enabled toggle, bot config fields, OAuth credentials, allowed users textarea)
- apps/next/src/components/layout/sidebar-list-panel.tsx (added 'admin-discord' nav item with bxl-discord-alt icon to admin sidebar)


---
**in-testing -> in-docs** (2026-03-10T14:09:52Z):
## Results
- apps/web/internal/handlers/admin_settings_test.go (5 tests: ValidKeys includes discord, all expected keys present, public keys excludes discord, discord defaults with all fields, unknown key returns empty map)

All 5 tests PASS — `go test ./internal/handlers/ -run "TestValidKeys|TestPublicKeys|TestDefaultSettings" -v` completed with 0 failures.


---
**in-docs -> in-review** (2026-03-10T14:10:12Z):
## Docs
- docs/discord-admin-settings.md (new — settings key, configuration fields table, security notes, frontend location, auto-start behavior)


---
**Review (approved)** (2026-03-10T14:11:44Z): Admin Discord settings complete.
