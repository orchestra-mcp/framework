---
id: FEAT-PZS
kind: bug
priority: P1
project_slug: orchestra-agents
status: done
title: Notification icon and click-to-open app
type: feature
---

# Notification icon and click-to-open app

Add Orchestra icon to hook-dispatched notifications and open the app when notification is clicked. macOS: use terminal-notifier with -appIcon and -activate, fallback to osascript. Linux: notify-send --icon with xdg-open action. Install notification icon to ~/.orchestra/notification-icon.png.


---
**in-progress -> in-testing** (2026-03-18T17:54:17Z):
## Changes
- libs/plugin-services-notifications/internal/notify/exec.go (rewrote Send — macOS: uses `tell application id "com.orchestramcp.orchestra"` so notification shows Orchestra icon and clicking opens the app, with fallback to plain osascript; Linux: uses `notify-send --icon=<path> --app-name=Orchestra`; embeds notification-icon.png via go:embed, installs to ~/.orchestra/notification-icon.png)
- libs/plugin-services-notifications/internal/notify/notification-icon.png (new file — embedded icon asset copied from arts/notification-icon.png)


---
**in-testing -> in-review** (2026-03-18T17:54:34Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T17:58:00Z): Notification icon and click-to-open working. User approved.
