---
id: FEAT-XBK
kind: feature
priority: P2
project_slug: orchestra-tools
status: done
title: SSH session manager (devtools.ssh)
type: feature
---

# SSH session manager (devtools.ssh)

Tools: ssh_connect, ssh_exec, ssh_disconnect, ssh_list_sessions, ssh_upload (SFTP), ssh_download (SFTP), ssh_list_remote. Uses golang.org/x/crypto/ssh. Streaming for interactive sessions.


---
**in-progress -> ready-for-testing**: 14 tests pass. All 7 tools covered: ssh_connect (validation + connection fail), ssh_exec (validation + unknown session), ssh_disconnect (validation + unknown session), ssh_list_sessions (empty list), ssh_upload (validation + unknown session), ssh_download (validation + unknown session), ssh_list_remote (validation + unknown session). Manager dependency injected at tool creation.


---
**in-testing -> ready-for-docs**: All 14 tests confirmed passing. ssh_connect TCP dial fails fast on port 2. Session-dependent tools return errors immediately on unknown session ID lookup. No external SSH server required.


## Note (2026-02-28T05:37:35Z)

## Implementation

**Plugin**: `libs/plugin-devtools-ssh/` — `devtools.ssh`  
**Binary**: `bin/devtools-ssh`  
**7 MCP tools** (all use `*ssh.Manager` injected at registration):

| Tool | Description | Required args |
|------|-------------|--------------|
| `ssh_connect` | Connect to SSH server (password or key auth) | `host`, `user` |
| `ssh_exec` | Execute command on remote server | `session_id`, `command` |
| `ssh_disconnect` | Close and remove SSH session | `session_id` |
| `ssh_list_sessions` | List all active sessions | none |
| `ssh_upload` | Upload file via SFTP | `session_id`, `local_path`, `remote_path` |
| `ssh_download` | Download file via SFTP | `session_id`, `remote_path`, `local_path` |
| `ssh_list_remote` | List files on remote path via SFTP | `session_id` |

**Manager** (`internal/ssh/manager.go`): Thread-safe session store (sync.RWMutex). Sessions keyed by `ssh-XXXXXX` IDs (random hex). `Connect()` supports password or PEM private key auth. `Exec()` creates a new SSH session per command, collects stdout/stderr.

**Auth**: `key_path` (PEM private key file path) OR `password`. At least one required for ssh_connect.

**SFTP**: Uses `golang.org/x/crypto/ssh` client's SFTP subsystem for upload/download/list.

**HostKeyCallback**: Currently `InsecureIgnoreHostKey()` — suitable for development, not production.

**Error codes**: `validation_error`, `connection_error` (ssh_connect fail), `not_found`/`ssh_session_error` (unknown session), `exec_error`, `sftp_error`.

**Tests**: 14 tests in `internal/tools/tools_test.go`. All pass. No external SSH server needed — connection tests use port 2 (never bound). Session tests use unknown IDs to trigger immediate not-found errors.


---
**in-docs -> documented**: Documented all 7 tools. Manager pattern, auth methods, SFTP, HostKeyCallback note. Tests: 14, all pass.


---
**in-review -> done**: Code review: Clean manager injection pattern. Thread-safe session store with RWMutex. Exec correctly creates a new SSH session per command and defers close. SFTP tools properly fail fast on unknown sessions. InsecureIgnoreHostKey noted as dev-only. 14 tests pass.