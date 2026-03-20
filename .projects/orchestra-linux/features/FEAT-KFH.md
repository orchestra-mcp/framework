---
id: FEAT-KFH
kind: feature
priority: P0
project_slug: orchestra-linux
status: backlog
title: AdwApplication entry point and main window
type: feature
---

# AdwApplication entry point and main window

Orchestra.Application subclassing Adw.Application (app-id: dev.orchestra.desktop). Register actions: quit, preferences, cycle-window (Ctrl+Shift+O), search (Ctrl+K), about. Startup: load GSettings, init theme, register built-in plugins. Activate: create Orchestra.Window, connect to orchestrator async. Orchestra.Window with AdwNavigationSplitView: sidebar (AdwNavigationPage) + content (AdwNavigationPage). Sidebar uses GtkListBox with AdwActionRow per plugin. Show initial "chat" plugin on launch.