# Notification Settings & Socket Push Delivery

## Overview

The notification system provides unified control over OS-level push notifications, TTS voice alerts, and socket push delivery to connected desktop/mobile apps. All settings are stored in globaldb under the `notify.*` key prefix and checked by the hooks plugin before dispatching.

## Settings Map

| globaldb Key | Type | Default | Purpose |
|---|---|---|---|
| `notify.ai_push_enabled` | bool | `true` | OS-level desktop push notifications |
| `notify.ai_voice_enabled` | bool | `true` | TTS voice alerts |
| `notify.socket_push_enabled` | bool | `true` | Push to apps via TCP EventBus |
| `notify.quiet_hours_start` | string | `""` | HH:MM quiet hours start |
| `notify.quiet_hours_end` | string | `""` | HH:MM quiet hours end |
| `notify.default_channel` | string | `"system"` | Default notification channel |
| `notify.voice_name` | string | `""` | Selected TTS voice (e.g. "Samantha") |
| `notify.voice_speed` | string | `""` | TTS speed in words per minute |
| `notify.voice_volume` | string | `""` | TTS volume 0.0-1.0 (Linux espeak only; macOS `say` does not support volume) |
| `notify.event.<Type>.push` | bool | `true` | Per-event-type push toggle |
| `notify.event.<Type>.voice` | bool | `true` | Per-event-type voice toggle |

## MCP Tools

### `notify_config`

Central tool for reading and writing all notification settings.

**Get all settings:**
```json
{"action": "get"}
```

Returns all settings including per-event-type overrides collected via `GetConfigPrefix("notify.event.")`.

**Set settings:**
```json
{
  "action": "set",
  "voice_name": "Samantha",
  "voice_speed": "180",
  "socket_push_enabled": true,
  "event_overrides": {
    "Notification": {"push": true, "voice": false}
  }
}
```

### `voice_config`

Convenience alias for voice-specific settings (reads/writes the same globaldb keys as `notify_config`).

```json
{"action": "set", "default_voice": "Samantha", "speed": "180", "volume": "0.8"}
```

Auto-detects `action: "set"` if any set-fields are provided without an explicit action.

### `tts_speak`

Reads stored preferences from globaldb (`notify.voice_name`, `notify.voice_speed`, `notify.voice_volume`) when `voice`, `speed`, or `volume` are not provided in the request. Explicit args override stored values.

### `notify_send`

Sends OS-level notification and, if `notify.socket_push_enabled` is not `"false"`, also publishes to EventBus topic `"notifications"` for connected apps. Requires a Sender (wired in `serve.go`).

## Socket Push Delivery

When a Claude Code hook event triggers a notification, `receive_hook_event` publishes to EventBus with:

- **Topic:** `"notifications"`
- **EventType:** `"push"`
- **Payload:** `{type, title, body, sound, event_type, notification_type, quiet_hours}`

Desktop apps connected via TCP receive this via `SubscribeAll()` in `tcpserver.go` and filter on topic `"notifications"` to render native notifications.

During quiet hours, socket push still fires (with `quiet_hours: true` in payload) so apps can show a badge silently. OS-level push and TTS are suppressed during quiet hours.

## Per-Event-Type Toggles

Individual event types can have push and voice independently disabled:

```json
{
  "action": "set",
  "event_overrides": {
    "Notification": {"push": true, "voice": false},
    "TaskComplete": {"push": false, "voice": false}
  }
}
```

Stored as `notify.event.Notification.push`, `notify.event.Notification.voice`, etc. Defaults to `true` when not set.

## Quiet Hours

When `notify.quiet_hours_start` and `notify.quiet_hours_end` are both set (HH:MM 24h format), during that window:
- OS push notifications are suppressed
- TTS voice alerts are suppressed
- Socket push still fires with `quiet_hours: true` (app renders badge silently)

Supports midnight-wrapping ranges (e.g. 22:00-08:00).

## Architecture

```
Claude Code hook event
  -> orchestra-mcp-hook.sh
    -> receive_hook_event (tools.hooks plugin)
      -> Log to SQLite (hook_events table)
      -> Publish to EventBus topic "hooks"
      -> dispatchNotifications():
          1. Check per-event toggles (notify.event.<Type>.push/voice)
          2. Check quiet hours (notify.quiet_hours_start/end)
          3. OS push via notify_send (if ai_push_enabled && !quietHours)
          4. TTS via tts_speak (if ai_voice_enabled && !quietHours)
          5. Socket push via EventBus topic "notifications" (if socket_push_enabled)
```

## globaldb Helper

`globaldb.GetConfigPrefix(prefix string) map[string]string` — returns all config key-value pairs where the key starts with the given prefix. Used by `notify_config get` to collect per-event overrides.

## Files

| File | Role |
|------|------|
| `libs/sdk-go/globaldb/globaldb.go` | `GetConfigPrefix()` helper |
| `libs/plugin-services-notifications/internal/tools/notify_config.go` | Central settings get/set |
| `libs/plugin-services-notifications/internal/tools/notify_send.go` | OS notification + socket push |
| `libs/plugin-services-notifications/internal/plugin.go` | Plugin registration with Sender |
| `libs/plugin-services-notifications/export.go` | Public Register with Sender param |
| `libs/plugin-services-voice/internal/tools/voice_config.go` | Voice settings via globaldb |
| `libs/plugin-services-voice/internal/tools/tts_speak.go` | TTS with globaldb fallback prefs |
| `libs/plugin-services-voice/internal/tts/exec.go` | Platform TTS with speed/volume |
| `libs/plugin-tools-hooks/internal/tools/receive_hook.go` | Hook dispatcher with socket push, toggles, quiet hours |
| `libs/cli/internal/serve.go` | Wires router to notifications plugin |
| `apps/flutter/lib/screens/settings/tabs/notifications_settings_tab.dart` | UI toggles |
