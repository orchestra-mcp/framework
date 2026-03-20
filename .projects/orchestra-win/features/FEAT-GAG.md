---
id: FEAT-GAG
kind: feature
priority: P2
project_slug: orchestra-win
status: backlog
title: Toast Notifications — AppNotificationManager (7 channels)
type: feature
---

# Toast Notifications — AppNotificationManager (7 channels)

Implement `Orchestra.Desktop/Services/NotificationService.cs` — Windows Toast Notifications via `Microsoft.Windows.AppNotifications` (Windows App SDK).

**Channels (7):** `build`, `test`, `deploy`, `ai`, `reminder`, `system`, `git`

**`NotificationService` API (services.notifications — 8 tools):**
- `notify_send` — immediate toast with title, body, channel, optional actions
- `notify_schedule` — `ScheduledToastNotification` at future `DateTimeOffset`
- `notify_cancel` — remove scheduled notification by ID
- `notify_list_pending` — list scheduled notifications
- `notify_badge` — set/clear taskbar badge count
- `notify_config` — get/set channel enable/disable per channel
- `notify_history` — list recently sent (last 50)
- `notify_create_channel` — register custom channel with sound + importance

**Toast builder pattern:**
```csharp
new AppNotificationBuilder()
    .AddArgument("channel", channel)
    .AddText(title)
    .AddText(body)
    .SetGroup(channel)
    .AddButton(new AppNotificationButton("View").AddArgument("action", "view"))
    .BuildNotification()
```

**Action dispatch (`NotificationInvoked`):** parse action argument → call corresponding MCP tool

**Sound:** per-channel custom sound via `AppNotificationSoundEvent`

**Focus Assist / Do Not Disturb:** check `FocusAssistConfiguration` before sending non-critical channels

**Platform:** Desktop (Win10 19041+), Xbox, HoloLens