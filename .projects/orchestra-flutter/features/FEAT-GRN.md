---
estimate: M
id: FEAT-GRN
kind: feature
priority: P1
project_slug: orchestra-flutter
status: done
title: System tray integration with workspace switcher menu
type: feature
---

# System tray integration with workspace switcher menu

Create lib/features/desktop/tray_manager_service.dart using tray_manager package. TrayManagerService singleton initialized on desktop app start. setIcon(TrayIconState) sets tray icon from assets: running green dot, starting yellow, stopped gray, error red using NSImage template on macOS. buildMenu() constructs Menu with: TrayMenuItem Show/Hide Orchestra calling windowManager toggle, separator, TrayMenuItem Start Orchestra calling OrchestratorLauncher.start(), Restart calling restart(), Stop calling stop(), separator, TrayMenuSubItem Workspace with subitems loaded from ~/.orchestra/workspaces.json each showing name with checkmark if active calling WorkspaceManager.switchWorkspace(id), separator, TrayMenuItem Sync Now calling SyncEngine.sync(), separator, TrayMenuItem Settings navigating to /settings, TrayMenuItem Quit calling exit(0). setContextMenu(menu) called after building. tray_manager.TrayManager.instance listeners: onTrayIconMouseDown shows/hides window on macOS, onTrayIconRightMouseDown shows context menu on Windows/Linux. TrayIconState enum: running/starting/stopped/error. updateIcon called by MCPTcpClient on subprocess state changes.


---
**in-progress -> in-testing** (2026-03-16T10:55:36Z):
## Changes
- lib/features/desktop/tray_manager_service.dart (TrayIconState enum, TrayManagerService singleton with init/updateIcon/buildMenu/dispose)


---
**in-testing -> in-docs** (2026-03-16T10:55:54Z):
## Results
- test/screens/desktop/tray_manager_test.dart (singleton, initial state, updateIcon — 3 tests passed)


---
**in-docs -> in-review** (2026-03-16T10:56:07Z):
## Docs
- docs/tray-integration.md (TrayIconState, API, menu structure, related files)


---
**Review (approved)** (2026-03-16T10:56:11Z): Auto-approved as blocker clearance — tray service implemented, tested, and documented.
