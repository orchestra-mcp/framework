---
estimate: M
id: FEAT-ILP
kind: feature
priority: P1
project_slug: orchestra-flutter
status: todo
title: Desktop-only settings — Orchestrator status, Terminal config and Workspace Manager
type: feature
---

# Desktop-only settings — Orchestrator status, Terminal config and Workspace Manager

Create 3 desktop-only settings screens. desktop_orchestrator_settings.dart: status row showing Running green badge or Stopped red badge and binary version string. Start / Stop / Restart GlassButton row calling OrchestratorLauncher methods. Auto-start on login Toggle using launch_at_startup package calling LaunchAtStartup.instance.enable() and disable(). Update available Banner when OrchestraDetector.hasUpdate true showing vX.Y.Z and Update Now button triggering installer flow inline with InstallProgress LinearProgressIndicator. desktop_terminal_settings.dart: default shell DropdownButton with zsh/bash/fish on macOS/Linux or PowerShell/CMD on Windows. Enabled providers CheckboxListTile list: local shell, SSH, Docker, AI agents. Font size NumberStepper 8-24pt default 14. Working directory default TextField with folder picker button. workspace_manager_screen.dart: full screen Scaffold, ListView of workspace tiles from ~/.orchestra/workspaces.json each showing name bold and primary folder path muted and last used relative time. FAB opens folder picker dialog via file_picker package, validates selected folder contains .git or pubspec.yaml or package.json or go.mod or Cargo.toml, on validate calls WorkspaceManager.addWorkspace(path, name) writing to workspaces.json. Swipe left delete with confirm dialog calling removeWorkspace(id). Tap switches active workspace calling switchWorkspace(id) which updates SharedPreferences and calls MCPTcpClient.restartSubprocess(newWorkspacePath).
