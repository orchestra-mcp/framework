---
id: FEAT-RUJ
kind: feature
priority: P3
project_slug: orchestra-win
status: backlog
title: Windows IoT — headless/kiosk dashboard mode
type: feature
---

# Windows IoT — headless/kiosk dashboard mode

Headless and kiosk-mode support for Windows IoT Enterprise and IoT Core.

Detection: `AnalyticsInfo.VersionInfo.DeviceFamily == "Windows.IoT"`

Features:
- `IoTKioskWindow.cs` — full-screen kiosk layout (no chrome), auto-start on boot
- `HeadlessOrchestraService.cs` — Windows Service wrapper for headless operation
- `NotificationRelayService.cs` — forward Toast notifications to remote endpoints (HTTP POST)
- `KioskLockdownPolicy.cs` — restrict navigation to allowed plugins only (Projects + AI Chat)
- Assigned Shell Access (ASSA) configuration for kiosk mode via PowerShell
- Auto-reconnect QUIC connection with exponential backoff for IoT environments
- Remote management via REST API exposed on local network (port 7890)
- Minimal plugin set: AI Chat, Projects, Notifications relay, Health check
- `WatchdogService.cs` — restart QUIC connection + plugin stack on failure
- `IoTHealthPlugin.cs` — expose /health endpoint for monitoring systems
- Package as Windows IoT Runtime Image component (wim-based deployment)