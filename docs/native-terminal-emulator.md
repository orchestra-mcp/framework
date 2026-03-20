# Native Terminal Emulator

## Overview

The Flutter app includes a native terminal emulator using C/FFI for direct PTY access. MCP is **not** used for terminal I/O — only for Claude AI chat sessions.

## Architecture

```
Local Terminal:  Keystrokes → xterm Terminal → flutter_pty (C FFI) → /bin/bash
SSH:             Keystrokes → xterm Terminal → dartssh2 → remote server
Claude:          Input bar  → xterm Terminal ← MCP chat_stream response
```

### Backend Strategy Pattern

All terminal types share one abstract interface:

```
TerminalBackend (abstract)
├── PtyTerminalBackend      — flutter_pty, desktop only
├── SshTerminalBackend      — dartssh2, desktop + mobile
└── ClaudeTerminalBackend   — MCP, all platforms
```

## Packages

| Package | Version | Purpose |
|---------|---------|---------|
| `xterm` | ^4.0.0 | Terminal emulator widget (ANSI, colors, cursor, scrollback) |
| `flutter_pty` | ^0.4.2 | Native C FFI PTY (forkpty/openpty). Desktop only. |
| `dartssh2` | ^2.9.3 | Pure Dart SSH client. Desktop + mobile. |

## Controller & Preferences

Each session gets its own `TerminalController` and `ScrollController`, managed by `TerminalSessionsNotifier`:

```
TerminalSessionsNotifier
├── backends: Map<String, TerminalBackend>       — xterm Terminal instances
├── controllers: Map<String, TerminalController>  — selection, search highlights
└── scrollControllers: Map<String, ScrollController> — scroll navigation
```

Controllers are created at session start and disposed on removal.

### Font Size Preferences

`terminalFontSizeProvider` — persisted via SharedPreferences.

| Property | Value |
|----------|-------|
| Default | 14.0 |
| Min | 10.0 |
| Max | 24.0 |
| Step | 1.0 |
| Storage key | `terminal_font_size` |

Methods: `increase()`, `decrease()`, `reset()`, `set(double)`.

### Search Visibility

`terminalSearchVisibleProvider` — toggleable boolean for the search overlay.

## Toolbar

`TerminalToolbar` — compact 36px row above the terminal content area.

| Button | Icon | Action | Shortcut |
|--------|------|--------|----------|
| Search | search | Toggle search overlay | Cmd/Ctrl+F |
| Font - | remove | Decrease font size | Cmd/Ctrl+- |
| Font display | (tap) | Reset to default (14) | Cmd/Ctrl+0 |
| Font + | add | Increase font size | Cmd/Ctrl+= |
| Copy | copy | Copy selection to clipboard | Cmd/Ctrl+C |
| Paste | paste | Paste from clipboard | Cmd/Ctrl+V |
| Clear | clear_all | Send ANSI clear (ESC[2J ESC[H]) | Cmd/Ctrl+K |
| Kill | stop_circle | Send ETX (Ctrl+C / 0x03) | — |

## Search Overlay

`TerminalSearchBar` — floating overlay positioned top-right (VS Code style), 340px wide.

Features:
- Text input with instant search on keystroke
- "X of Y" match counter
- Up/down arrow navigation between matches
- Case sensitivity toggle (Aa button)
- Regex toggle (.*) button
- Close button (also Escape key)

Search logic scans `terminal.buffer.lines[y].toString()` and uses `TerminalController.highlight()` with `buffer.createAnchor(x, y)` for match visualization. Current match uses stronger alpha (0.5 vs 0.2).

## Context Menu

Right-click (secondary tap) on the terminal shows a popup menu:

| Action | Icon | Behavior |
|--------|------|----------|
| Copy | copy | Copy selection to clipboard (disabled when no selection) |
| Paste | paste | Paste clipboard text into terminal |
| Select All | select_all | Select entire buffer via `buffer.createAnchor()` |
| Search | search | Open search overlay |
| Clear | clear_all | Send ANSI clear escape |

## Keyboard Shortcuts

Platform-aware: macOS uses Meta (Cmd), Linux/Windows uses Control.

| Shortcut | Action |
|----------|--------|
| Cmd/Ctrl+F | Toggle search overlay |
| Cmd/Ctrl+K | Clear terminal buffer |
| Cmd/Ctrl+= | Increase font size |
| Cmd/Ctrl+- | Decrease font size |
| Cmd/Ctrl+0 | Reset font size to default |
| Escape | Close search overlay |

Implemented via `CallbackShortcuts` + `SingleActivator` wrapping the terminal view.

## Unicode Width Fix

xterm.dart v4.0.0 uses Unicode 11 `wcwidth` tables that don't handle modern emoji correctly. Variation selectors (U+FE0E text, U+FE0F emoji) and zero-width joiners (U+200D) cause character width miscalculation, leading to text misalignment.

Fix: `ClaudeTerminalBackend._sanitizeUnicode()` strips these characters from PTY output before writing to the terminal buffer. This preserves base emoji rendering while fixing alignment.

## Terminal Polish

- `alwaysShowCursor: true` — cursor always visible
- `cursorType: TerminalCursorType.block` — block cursor style
- `padding: EdgeInsets.all(4)` — breathing room around content
- `onTitleChange` callback wired to `renameSession()` — session tab label updates dynamically when the shell sets a window title (e.g., showing current directory or running command)
- Font family: MesloLGS NF with fallbacks (JetBrains Mono, SF Mono, Menlo, Consolas, monospace)

## Key Files

| File | Description |
|------|-------------|
| `lib/features/terminal/terminal_backend.dart` | Abstract base class |
| `lib/features/terminal/pty_terminal_backend.dart` | Local shell via flutter_pty |
| `lib/features/terminal/ssh_terminal_backend.dart` | Remote shell via dartssh2 |
| `lib/features/terminal/claude_terminal_backend.dart` | AI chat via MCP + Unicode sanitization |
| `lib/features/terminal/terminal_sessions_provider.dart` | Riverpod notifier + backend/controller registry + title events |
| `lib/features/terminal/terminal_preferences_provider.dart` | Font size + search visibility state |
| `lib/features/terminal/terminal_session_model.dart` | Session model (type, status, SSH/Claude fields) |
| `lib/screens/terminal/widgets/terminal_toolbar.dart` | Compact toolbar with search, font, copy/paste, clear, kill |
| `lib/screens/terminal/widgets/terminal_search_bar.dart` | Floating search overlay with match highlighting |
| `lib/screens/terminal/widgets/terminal_context_menu.dart` | Right-click popup menu |
| `lib/screens/terminal/widgets/terminal_content.dart` | xterm TerminalView with shortcuts, context menu, search stack |
| `lib/screens/terminal/terminal_screen.dart` | Toolbar + content layout |

## Platform Behavior

| Platform | Terminal | SSH | Claude |
|----------|----------|-----|--------|
| macOS | Yes | Yes | Yes |
| Windows | Yes | Yes | Yes |
| Linux | Yes | Yes | Yes |
| iOS | No | Yes | Yes |
| Android | No | Yes | Yes |
| Web | No | No | Yes |

The "Terminal" option is hidden in the new session menu on non-desktop platforms. The default session type on desktop is Terminal; on mobile it's Claude.
