---
created_at: "2026-03-10T14:18:25Z"
description: Add slack to validKeys in admin_settings.go with defaults (enabled, bot_token, signing_secret, app_id, channel_id, allowed_users, webhook_url). Add admin-slack tab to settings page with full configuration UI. Add sidebar nav item. Mirror Discord admin settings implementation.
estimate: M
id: FEAT-PWB
kind: feature
labels:
    - plan:PLAN-IDD
priority: P1
project_id: orchestra-swift
status: done
title: Admin Slack Bot Settings
updated_at: "2026-03-10T15:05:15Z"
version: 5
---

# Admin Slack Bot Settings

Add slack to validKeys in admin_settings.go with defaults (enabled, bot_token, signing_secret, app_id, channel_id, allowed_users, webhook_url). Add admin-slack tab to settings page with full configuration UI. Add sidebar nav item. Mirror Discord admin settings implementation.


---
**in-progress -> in-testing** (2026-03-10T15:01:57Z):
## Changes
- apps/web/internal/handlers/admin_settings.go (added "slack" to validKeys, added slack defaults with enabled, bot_token, app_token, signing_secret, app_id, channel_id, command_prefix, webhook_url, allowed_users, team_id)
- apps/next/src/app/(app)/settings/page.tsx (added 'admin-slack' to Tab type, added full Slack Bot admin tab with enabled toggle, bot config fields, allowed users textarea, save button)
- apps/next/src/components/layout/sidebar-list-panel.tsx (added Slack Bot nav item with bxl-slack icon)


---
**in-testing -> in-docs** (2026-03-10T15:02:27Z):
## Results
- apps/web/internal/handlers/admin_settings_test.go (added TestValidKeys_IncludesSlack, TestPublicKeys_ExcludesSlack, TestDefaultSettings_Slack — all 3 new tests pass, plus updated TestValidKeys_AllExpected with "slack" in expected list)
- 11 total tests pass including existing Discord + OAuth tests: TestValidKeys_IncludesDiscord, TestValidKeys_AllExpected, TestDefaultSettings_Discord, TestValidKeys_IncludesSlack, TestPublicKeys_ExcludesSlack, TestDefaultSettings_Slack, TestDefaultSettings_UnknownKey, TestExchangeCode_SlackNestedToken, TestFetchUserInfo_SlackNestedUser, TestSlackOAuthStateRoundTrip, TestProviderConfigStruct_Slack


---
**in-docs -> in-review** (2026-03-10T15:02:47Z):
## Docs
- docs/slack-admin-settings.md (new — Slack admin settings reference: fields table, security, frontend location, Slack app setup guide, auto-start behavior)


---
**Review (approved)** (2026-03-10T15:05:15Z): Admin Slack Bot settings page complete — mirrors Discord admin settings with Slack-specific fields (app_token, signing_secret, team_id). All tests pass.
