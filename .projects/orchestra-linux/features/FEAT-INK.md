---
id: FEAT-INK
kind: feature
priority: P2
project_slug: orchestra-linux
status: backlog
title: SSH client sub-tool
type: feature
---

# SSH client sub-tool

SSH sub-tool. Connection list sidebar: saved SSH connections (host, user, port) stored in GSettings. Connect dialog: AdwDialog (host, username, port, key path, use password). On connect: calls ssh_connect tool → shows VTE terminal for remote session. SFTP panel: file browser for remote filesystem via ssh_list_remote, ssh_upload, ssh_download. Disconnect button and session status indicator. Calls devtools.ssh tools: ssh_connect, ssh_exec, ssh_disconnect, ssh_list_sessions, ssh_upload, ssh_download, ssh_list_remote.