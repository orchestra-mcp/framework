---
id: FEAT-TKP
kind: feature
priority: P1
project_slug: orchestra-hooks
status: done
title: AI agent notification settings (push + voice toggles)
type: feature
---

# AI agent notification settings (push + voice toggles)

Add settings to control AI push notifications and voice alerts. Persist via globaldb, check in dispatchNotifications, expose in Flutter UI.


---
**in-progress -> in-testing** (2026-03-17T15:53:33Z):
## Changes
- libs/plugin-services-notifications/internal/tools/notify_config.go (added ai_push_enabled / ai_voice_enabled fields, persisted via globaldb.GetConfig/SetConfig, added configBool helper)
- libs/plugin-tools-hooks/internal/tools/receive_hook.go (added globaldb import, check notify.ai_push_enabled before calling notify_send, check notify.ai_voice_enabled before calling tts_speak)
- apps/flutter/lib/core/providers/settings_provider.dart (added aiNotificationSettingsProvider that calls notify_config via MCP)
- apps/flutter/lib/screens/settings/tabs/notifications_settings_tab.dart (added AI Agent section with push and voice toggles, _toggleAi method, _AiNotificationSection widget)


---
**in-testing -> in-docs** (2026-03-17T15:55:10Z):
## Results
- libs/plugin-services-notifications/internal/tools/tools_test.go (updated TestNotifyConfig_GetAction for JSON response format, added TestNotifyConfig_SetAiToggles — all 6 notify config tests pass)
- libs/plugin-tools-hooks/internal/tools/receive_hook_test.go (existing 5 tests pass — globaldb check is backwards-compatible)


---
**in-docs -> in-review** (2026-03-17T15:55:30Z):
## Docs
- docs/ai-notification-settings.md (new — documents the AI notification settings feature, config keys, data flow, and file locations)


---
**Review (approved)** (2026-03-17T15:55:56Z): AI notification settings — globaldb-persisted toggles for push + voice, checked in hooks dispatch, Flutter UI with AI Agent section.
