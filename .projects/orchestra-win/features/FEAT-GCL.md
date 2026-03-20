---
id: FEAT-GCL
kind: feature
priority: P0
project_slug: orchestra-win
status: backlog
title: System tray — H.NotifyIcon.WinUI
type: feature
---

# System tray — H.NotifyIcon.WinUI

Implement `Orchestra.Desktop/TrayIcon/TrayIconService.cs` — system tray icon with context menu using `H.NotifyIcon.WinUI` NuGet package.

**Tray icon:** `orchestra-tray.ico` (16/32/48px variants), ToolTip "Orchestra MCP"

**Context menu (`MenuFlyout`):**
- "Open Orchestra" → `mainWindow.Activate()`
- "Spirit Mode" → `WindowModeManager.SetMode(Floating)`
- "Bubble Mode" → `WindowModeManager.SetMode(Bubble)`
- Separator
- "⬤ Connected" / "○ Disconnected" (non-interactive status, updates on `QUICConnection.StateChanged`)
- Separator
- "Check for Updates"
- "Quit" → `Application.Current.Exit()`

**Double-click:** restore main window

**Badge:** show pending notification count as tray badge (Windows 11)

**Platform:** Desktop only (`WindowsPlatform.Desktop`)