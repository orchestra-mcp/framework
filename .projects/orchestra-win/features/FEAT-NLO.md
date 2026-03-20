---
id: FEAT-NLO
kind: feature
priority: P2
project_slug: orchestra-win
status: backlog
title: SSH sub-plugin — remote sessions + SFTP
type: feature
---

# SSH sub-plugin — remote sessions + SFTP

Implement `Orchestra.Desktop/Plugins/DevToolsPlugin/SSH/` — SSH remote session management and SFTP file transfer.

**`SSHPage.xaml`** — split layout:
- Left: `ConnectionList` — saved SSH connections (`ListView`) with add/edit/delete. Connection: alias, host, port, user, auth method (password/key/agent), identity file path
- Right: active session — embedded `TerminalControl` (xterm.js) for interactive shell, plus toolbar: SFTP file transfer, port forward, disconnect

**`SSHService.cs`** — wraps `ssh.exe` (OpenSSH built into Windows 10+) via `Process`, or optionally `SSH.NET` NuGet for programmatic control. Stored connections encrypted via `CredentialService` (PasswordVault)

**SFTP panel:** `TreeView` remote file browser + local `TreeView`, drag-to-transfer, progress `ProgressBar`

**MCP tools called:** `ssh_connect`, `ssh_execute`, `ssh_disconnect`, `ssh_list_sessions`, `sftp_list`, `sftp_upload`, `sftp_download`

**Platform:** Desktop, HoloLens