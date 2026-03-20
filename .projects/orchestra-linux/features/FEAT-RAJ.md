---
id: FEAT-RAJ
kind: feature
priority: P2
project_slug: orchestra-linux
status: backlog
title: D-Bus notifications (org.freedesktop.Notifications)
type: feature
---

# D-Bus notifications (org.freedesktop.Notifications)

Implement services.notifications tools using D-Bus org.freedesktop.Notifications interface. notify_send(): bus call Notify with app_name="Orchestra", icon="dev.orchestra.desktop", urgency hint (low=0, normal=1, critical=2), desktop-entry hint, timeout. Returns notification ID (uint32). Action callbacks: listen for ActionInvoked signal, map to MCP tool calls. GNotification fallback on GNOME for richer integration (add_button with app. actions). notify_schedule(): GLib timeout_add() + persist to SQLite. notify_badge(): set counter badge via org.freedesktop.portal.Notification (GNOME 44+). Channels: build, test, deploy, ai, reminder, system, git.