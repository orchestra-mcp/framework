# Flutter Terminal Emulator

Full terminal emulator in the Flutter app with three session types: **Terminal** (local shell/PTY), **SSH** (interactive remote shell), and **Claude** (AI chat).

## Architecture

```
TerminalScreen
├── TerminalTabBar          (session tabs + "+" button)
│   └── NewSessionMenu      (Terminal / SSH / Claude popup)
└── TerminalContent          (output area + input bar per session)
    └── TerminalController   (MCP bridge: connect, sendInput, resize)
```

### State Management (Riverpod)

- **`terminalSessionsProvider`** — `NotifierProvider<TerminalSessionsNotifier, List<TerminalSessionModel>>`. Manages session lifecycle via MCP tool calls.
- **`activeTerminalIdProvider`** — `NotifierProvider<_ActiveTerminalId, String?>`. Tracks the currently visible tab.

### Session Types

| Type | MCP Tools Used | Output Pattern |
|------|---------------|----------------|
| Terminal | `create_terminal`, `send_input`, `terminal_stream`, `resize_terminal`, `close_terminal` | Streaming via notifications |
| SSH | `ssh_connect`, `ssh_interactive_open`, `ssh_interactive_send`, `ssh_interactive_stream`, `ssh_interactive_close`, `ssh_disconnect` | Streaming via notifications |
| Claude | `spawn_session`, `chat_stream`, `kill_session` | Request/response per message |

## Files

### Feature Layer (`lib/features/terminal/`)

| File | Purpose |
|------|---------|
| `terminal_session_model.dart` | Immutable model with type, status, SSH/Claude fields, `copyWith` |
| `terminal_sessions_provider.dart` | Riverpod notifier — create/remove sessions via MCP |
| `terminal_controller.dart` | Per-session bridge: connect, sendInput, resize, dispose |

### Screens (`lib/screens/terminal/`)

| File | Purpose |
|------|---------|
| `terminal_screen.dart` | Main screen with empty state, tab bar, and content area |
| `widgets/terminal_tab_bar.dart` | Scrollable horizontal tabs with status dots and close buttons |
| `widgets/terminal_content.dart` | Monospace output area + shell/Claude input bars |
| `widgets/new_session_menu.dart` | PopupMenuButton with Terminal/SSH/Claude options |
| `widgets/ssh_connect_dialog.dart` | SSH connection form (host, user, port, auth method) |
| `widgets/claude_session_dialog.dart` | Claude model picker (haiku, sonnet, opus) |

### MCP Client (`lib/core/mcp/`)

| File | Purpose |
|------|---------|
| `mcp_client.dart` | WebSocket JSON-RPC 2.0 client for web/mobile access |
| `mcp_provider.dart` | Riverpod providers for McpClient singleton |

### Integration

| File | Change |
|------|--------|
| `core/router/app_router.dart` | Added `Routes.terminal` + `GoRoute` |
| `screens/shell/desktop_shell.dart` | Added terminal to sidebar enum, rail destination, switch cases |

## MCP Backend

The terminal relies on two Go plugins bundled in `orchestra serve`:

- **devtools.terminal** — 7 tools (6 PTY + 1 streaming)
- **devtools.ssh** — 11 tools (7 original + 4 interactive)

Both use subscriber fan-out for real-time output streaming. The Flutter `TerminalController` subscribes to MCP notifications filtered by session ID.

## Session Lifecycle

1. User clicks "+" → selects session type
2. `TerminalSessionsNotifier.createXxxSession()` → MCP tool call → session added to state
3. `TerminalController.connect()` → subscribes to output notifications
4. User types → `sendInput()` → MCP tool call → output arrives via notification
5. User closes tab → `removeSession()` → MCP cleanup tool call → session removed
