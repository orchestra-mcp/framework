---
id: FEAT-LWG
kind: feature
priority: P1
project_slug: orchestra-win
status: backlog
title: DevTools plugin — container + sub-plugin routing
type: feature
---

# DevTools plugin — container + sub-plugin routing

Implement `Orchestra.Desktop/Plugins/DevToolsPlugin/` — the DevTools section container that hosts 10 sub-plugins with a secondary navigation rail.

**`DevToolsPage.xaml`** — split layout:
- Left rail (48px): icon-only `ListView` for sub-plugin selection (File Explorer, Terminal, SSH, Services, Docker, Debugger, Test Runner, Log Viewer, Database, DevOps)
- Right: `Frame` navigating to the selected sub-plugin page

**Sub-plugin registration** — each DevTools sub-plugin implements `IOrchestraPlugin` with `Section = AppSection.DevTools`. `DevToolsPage` reads `PluginRegistry.DevToolPlugins` to build the rail dynamically.

**Built-in DevTools sub-plugins (registered in Phase 3):**
- `FileExplorerPlugin` (`\uE8B7` Files) → `FileExplorerPage`
- `TerminalPlugin` (`\uE756` CommandPrompt) → `TerminalPage`
- `SSHPlugin` (`\uE8CB` Globe) → `SSHPage`
- `ServicesPlugin` (`\uE9F5` Processing) → `ServicesPage`
- `DockerPlugin` (`\uECAA` Container) → `DockerPage`
- `DebuggerPlugin` (`\uEBE8` Bug) → `DebuggerPage`
- `TestRunnerPlugin` (`\uE73E` CheckboxChecked) → `TestRunnerPage`
- `LogViewerPlugin` (`\uF000` Script) → `LogViewerPage`
- `DatabasePlugin` (`\uF1C7` Database) → `DatabasePage`
- `DevOpsPlugin` (`\uEDB7` CloudUpload) → `DevOpsPage`

**Platform:** Desktop, HoloLens