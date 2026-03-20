---
id: FEAT-UVY
kind: feature
priority: P0
project_slug: orchestra-swift-enhancement
status: done
title: Native terminal emulator: flutter_pty + xterm + dartssh2
type: feature
---

# Native terminal emulator: flutter_pty + xterm + dartssh2

Replace MCP-based terminal with native PTY via C/FFI. Uses flutter_pty for local shell, dartssh2 for SSH, xterm widget for rendering. MCP only used for Claude chat sessions.


---
**in-progress -> in-testing** (2026-03-17T06:22:45Z):
## Changes
- apps/flutter/pubspec.yaml (added xterm ^3.6.0, flutter_pty ^0.4.2, dartssh2 ^2.9.3)
- apps/flutter/lib/features/terminal/terminal_session_model.dart (removed MCP IDs, added sshPassword/sshKeyFile)
- apps/flutter/lib/features/terminal/terminal_backend.dart (new — abstract base class)
- apps/flutter/lib/features/terminal/pty_terminal_backend.dart (new — flutter_pty C FFI local shell)
- apps/flutter/lib/features/terminal/ssh_terminal_backend.dart (new — dartssh2 remote shell)
- apps/flutter/lib/features/terminal/claude_terminal_backend.dart (new — MCP Claude chat)
- apps/flutter/lib/features/terminal/terminal_sessions_provider.dart (rewritten — native backend registry)
- apps/flutter/lib/screens/terminal/widgets/terminal_content.dart (rewritten — xterm TerminalView)
- apps/flutter/lib/screens/terminal/widgets/new_session_menu.dart (platform guard for Terminal option)
- apps/flutter/lib/screens/terminal/terminal_screen.dart (platform-aware default session)
- apps/flutter/lib/features/terminal/terminal_controller.dart (deleted — replaced by backends)


---
**in-testing -> in-docs** (2026-03-17T06:25:50Z):
## Results
- apps/flutter/test/features/terminal/terminal_test.dart (31 tests, all passing)
  - TerminalSessionType: 1 test
  - TerminalSessionStatus: 1 test  
  - TerminalSessionModel: 18 tests (construction, equality, copyWith, toString)
  - TerminalSessionsNotifier: 3 tests (initial state, isolation)
  - ActiveTerminalId: 5 tests (null init, set, clear, overwrite, isolation)
- Fixed xterm version compatibility: upgraded from ^3.6.0 to ^4.0.0


---
**in-docs -> in-review** (2026-03-17T06:26:14Z):
## Docs
- docs/native-terminal-emulator.md (architecture, packages, key files, platform matrix)


---
**Review (approved)** (2026-03-17T06:26:45Z): Native terminal emulator approved. Replaces MCP-based approach with flutter_pty (C FFI) + xterm + dartssh2.
