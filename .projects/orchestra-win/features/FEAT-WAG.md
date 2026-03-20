---
id: FEAT-WAG
kind: feature
priority: P2
project_slug: orchestra-win
status: backlog
title: Jump Lists — recent projects + quick actions
type: feature
---

# Jump Lists — recent projects + quick actions

Implement `Orchestra.Desktop/Services/JumpListService.cs` — Windows taskbar Jump List populated with recent projects and quick actions.

**Jump List structure (`JumpList.LoadCurrentAsync`):**
- **"Recent Projects" group** — last 5 opened projects, each as `JumpListItem.CreateWithArguments($"--project {slug}", name)` with project icon
- **"Actions" group:**
  - "New AI Chat" → `--new-chat`
  - "Open Spirit" → `--spirit`
  - "Open Bubble" → `--bubble`

**Launch argument handling (`App.OnLaunched`):**
- Parse `AppInstance.GetActivatedEventArgs()` for `LaunchActivatedEventArgs.Arguments`
- `--project {slug}` → navigate to Projects → open that project
- `--new-chat` → navigate to Chat → create new session
- `--spirit` → `WindowModeManager.SetMode(Floating)`
- `--bubble` → `WindowModeManager.SetMode(Bubble)`

**Update trigger:** call `UpdateJumpListAsync()` whenever the user opens a project or creates a chat session

**Platform:** Windows 7+ (`JumpList` API), Desktop only