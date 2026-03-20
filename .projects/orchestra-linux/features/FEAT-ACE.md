---
id: FEAT-ACE
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: XDG autostart
type: feature
---

# XDG autostart

Autostart support via XDG autostart spec. Write ~/.config/autostart/dev.orchestra.desktop.desktop when autostart enabled in settings. Desktop file contents: [Desktop Entry], Type=Application, Name=Orchestra, Exec=orchestra-desktop --background, Icon=dev.orchestra.desktop, X-GNOME-Autostart-enabled=true, Comment=Orchestra MCP AI-agentic IDE. --background flag: start minimized to tray without showing main window. Remove autostart file when disabled. Toggle in Settings → General → Start at login.