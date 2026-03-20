---
id: FEAT-ILW
kind: feature
priority: P2
project_slug: orchestra-win
status: backlog
title: Services sub-plugin — Windows services via sc.exe + PowerShell
type: feature
---

# Services sub-plugin — Windows services via sc.exe + PowerShell

Implement `Orchestra.Desktop/Plugins/DevToolsPlugin/Services/ServicesPage.xaml/.cs` — Windows Service Manager equivalent of macOS launchctl.

**`ServicesPage.xaml`:**
- `AutoSuggestBox` filter + `ComboBox` status filter (All/Running/Stopped/Disabled)
- `ListView` of services: display name, service name, status dot, startup type badge, description
- Right-click context menu + toolbar: Start, Stop, Restart, Open in Event Viewer
- Detail flyout: full service info, dependencies list, recovery actions

**macOS → Windows mapping:**
- `launchctl list` → `Get-Service` / `sc.exe query type= all state= all`
- `launchctl start` → `Start-Service` / `sc.exe start`
- `launchctl stop` → `Stop-Service` / `sc.exe stop`
- `launchctl load` → `New-Service` / `sc.exe create`

**`ServiceManagerService.cs`** — uses `System.Management.Automation` PowerShell runspace; falls back to `sc.exe` subprocess. Also surfaces Docker containers as pseudo-services when Docker Desktop is running.

**MCP tools called:** `services_list`, `services_start`, `services_stop`, `services_restart`, `services_enable`, `services_disable`

**Platform:** Desktop only