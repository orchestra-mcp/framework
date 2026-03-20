---
id: FEAT-OBD
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Notification Settings & Socket Push Delivery
type: feature
---

# Notification Settings & Socket Push Delivery

Add GetConfigPrefix helper to globaldb, expand notify_config with voice/socket/per-event settings, fix voice_config persistence via globaldb, add speed/volume to TTS exec layer, make tts_speak read prefs from globaldb, add socket push delivery in hook event dispatcher, and make notify_send socket-aware.


---
**in-progress -> in-testing** (2026-03-18T17:38:16Z):
## Changes
- libs/sdk-go/globaldb/globaldb.go (added GetConfigPrefix helper — queries all config keys matching a prefix)
- libs/plugin-services-notifications/internal/tools/notify_config.go (expanded schema with voice_name, voice_speed, voice_volume, socket_push_enabled, event_overrides; refactored into handleGetConfig/handleSetConfig; reads per-event overrides via GetConfigPrefix)
- libs/plugin-services-voice/internal/tools/voice_config.go (rewritten to persist via globaldb with action get/set, speed, volume support)
- libs/plugin-services-voice/internal/tts/exec.go (added speed and volume params to Speak — macOS -r flag, Linux espeak -s/-a flags)
- libs/plugin-services-voice/internal/tools/tts_speak.go (added speed/volume to schema, falls back to globaldb prefs when not provided)
- libs/plugin-tools-hooks/internal/tools/receive_hook.go (added socket push via EventBus topic "notifications", per-event toggles via eventToggle, quiet hours check via isQuietHours)
- libs/plugin-services-notifications/internal/tools/notify_send.go (added Sender interface and socket push to EventBus after OS notification)
- libs/plugin-services-notifications/internal/plugin.go (added Sender field, pass to NotifySend)
- libs/plugin-services-notifications/export.go (added Sender param to Register, matching hooks plugin pattern)
- libs/cli/internal/serve.go (pass router to servicesnotifications.Register)
- libs/plugin-services-notifications/internal/tools/tools_test.go (updated NotifySend calls to pass nil sender)


---
**in-testing -> in-docs** (2026-03-18T17:39:45Z):
## Results
- libs/sdk-go/globaldb/globaldb_test.go — 8/8 PASS (existing tests still pass with new GetConfigPrefix)
- libs/plugin-services-notifications/internal/tools/tools_test.go — 23/23 PASS (NotifySend tests updated to pass nil sender)
- libs/plugin-services-voice/internal/tools/tools_test.go — 19/19 PASS (voice_config tests work with new globaldb-backed handler)
- libs/plugin-tools-hooks/internal/tools/receive_hook_test.go — 4/4 PASS (TestReceiveHookEvent_NotificationDispatch updated: verifies 4 calls including socket push Publish to "notifications" topic)
- libs/plugin-tools-hooks/internal/tools/hook_log_test.go — 5/5 PASS


---
**in-docs -> in-review** (2026-03-18T17:40:53Z):
## Docs
- docs/ai-notification-settings.md (updated existing doc: expanded settings map with all new keys, added socket push delivery section, per-event toggles, quiet hours, architecture diagram, globaldb helper reference, complete file list)


---
**Review (approved)** (2026-03-18T17:41:35Z): All 7 steps implemented and tested. 55 tests pass across 4 plugins. User approved.
