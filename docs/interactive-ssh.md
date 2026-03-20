# Interactive SSH Sessions

## Overview

The `devtools.ssh` plugin now supports interactive SSH sessions with PTY allocation, enabling real-time terminal emulation over SSH connections. This builds on the existing `ssh_connect` one-shot execution model by adding persistent interactive shells with streaming output.

## Architecture

```
Flutter App ──WebSocket──> WebGate ──JSON-RPC──> devtools.ssh plugin
                                                    │
                                        ┌───────────┴───────────┐
                                        │   InteractiveManager  │
                                        │  ┌─────────────────┐  │
                                        │  │ InteractiveSession│  │
                                        │  │  SSH PTY session  │  │
                                        │  │  stdin pipe       │  │
                                        │  │  subscriber fan-out│ │
                                        │  └─────────────────┘  │
                                        └───────────────────────┘
```

## New Tools (4)

### `ssh_interactive_open`

Opens an interactive SSH shell with PTY allocation on an existing SSH connection.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `session_id` | string | yes | SSH session ID from `ssh_connect` |
| `cols` | number | no | Terminal width (default: 80) |
| `rows` | number | no | Terminal height (default: 24) |

Returns: `{ interactive_id, ssh_session_id, cols, rows }`

### `ssh_interactive_send`

Writes input to an interactive session's stdin.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `interactive_id` | string | yes | Interactive session ID |
| `input` | string | yes | Input text (include `\n` for Enter) |

### `ssh_interactive_stream` (streaming)

Streams real-time output from an interactive SSH session via the WebGate streaming protocol. Subscribes to the session's stdout fan-out and pushes chunks until the context is cancelled or the session closes.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `interactive_id` | string | yes | Interactive session ID |

### `ssh_interactive_close`

Closes an interactive SSH session and releases resources.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `interactive_id` | string | yes | Interactive session ID |

## Subscriber Fan-Out

Interactive sessions use the same fan-out pattern as terminal PTY streaming:

- Each session maintains a `map[int]chan []byte` of subscriber channels
- A background goroutine reads SSH stdout and copies data to all subscribers
- Non-blocking sends prevent slow consumers from blocking others
- Channels are auto-closed when the SSH session ends
- `Subscribe()` returns a read channel and an unsubscribe callback

## Usage Flow

1. `ssh_connect` → get `session_id`
2. `ssh_interactive_open(session_id)` → get `interactive_id`
3. `ssh_interactive_stream(interactive_id)` → streaming output
4. `ssh_interactive_send(interactive_id, "command\n")` → send input
5. `ssh_interactive_close(interactive_id)` → cleanup

## PTY Configuration

Interactive sessions use `xterm-256color` terminal type with:
- Echo enabled (`ECHO: 1`)
- 14400 baud I/O speed
- Configurable dimensions via `cols`/`rows` params
- Runtime resize via `InteractiveManager.Resize()`
