---
id: FEAT-DZZ
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: System tray (StatusNotifierItem)
type: feature
---

# System tray (StatusNotifierItem)

TrayIcon using libappindicator3 (AppIndicator.Indicator). Icon: dev.orchestra.desktop symbolic. Status: ACTIVE when connected, ATTENTION when disconnected. Context menu (GtkMenu): Show Orchestra (activate main window), Open Spirit (show floating chat), Connected/Disconnected label (non-clickable), Separator, Quit. On GNOME: requires AppIndicator GNOME Shell extension (show AdwToast guiding user on first run). On KDE/XFCE/Sway: works natively via StatusNotifierItem protocol. Badge count via icon overlay when AI response is ready.