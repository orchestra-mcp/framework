# Terminal & SSH Plugin Bundling

## Overview

Both `devtools.terminal` (7 tools) and `devtools.ssh` (11 tools) are registered as in-process plugins in `libs/cli/internal/serve.go`. They are always available when `orchestra serve` is running.

## Registration Pattern

Both plugins follow the standard in-process registration pattern:

```go
{
    b := plugin.New("devtools.terminal")
    devtoolsterminal.Register(b)
    ep := b.Export()
    router.RegisterPlugin(ep)
}
```

## Available Tools

### devtools.terminal (7 tools)
- `create_terminal` — create a PTY terminal session
- `send_input` — write input to terminal stdin
- `get_output` — poll accumulated output
- `resize_terminal` — change terminal dimensions
- `list_terminals` — list active sessions
- `close_terminal` — close a session
- `terminal_stream` — stream real-time output (streaming)

### devtools.ssh (11 tools)
- `ssh_connect` — connect to SSH server
- `ssh_exec` — execute one-shot command
- `ssh_disconnect` — close SSH connection
- `ssh_list_sessions` — list connections
- `ssh_upload` / `ssh_download` — SFTP file transfer
- `ssh_list_remote` — list remote directory
- `ssh_interactive_open` — open interactive shell with PTY
- `ssh_interactive_send` — write to interactive session
- `ssh_interactive_stream` — stream interactive output (streaming)
- `ssh_interactive_close` — close interactive session

## Access

All tools are accessible via:
- **stdio transport** — MCP clients (Claude Code, Cursor, etc.)
- **TCP server** — desktop apps (Swift, Windows, Linux)
- **WebGate** — browser/mobile clients via WebSocket JSON-RPC
- **Reverse tunnel** — remote clients via cloud relay
