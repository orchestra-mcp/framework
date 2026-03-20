---
id: FEAT-ZLL
kind: feature
priority: P0
project_slug: orchestra-flutter
status: done
title: Flutter terminal emulator with Terminal, SSH, and Claude sessions
type: feature
---

# Flutter terminal emulator with Terminal, SSH, and Claude sessions

Full terminal emulator in the Flutter app with three session types: Terminal (local shell/PTY), SSH (interactive remote shell), and Claude (AI chat). Includes MCP client layer, session management via Riverpod, terminal UI with tab bar, output/input areas, SSH/Claude dialogs, and desktop shell sidebar integration.


---
**in-progress -> in-testing** (2026-03-16T21:12:52Z):
## Changes
- apps/flutter/lib/core/mcp/mcp_client.dart (new - WebSocket JSON-RPC 2.0 client with callTool and callToolStreaming)
- apps/flutter/lib/core/mcp/mcp_provider.dart (new - Riverpod providers for McpClient singleton and connection)
- apps/flutter/lib/features/terminal/terminal_session_model.dart (new - TerminalSessionType, TerminalSessionStatus, TerminalSessionModel)
- apps/flutter/lib/features/terminal/terminal_sessions_provider.dart (new - TerminalSessionsNotifier with create/remove for terminal/SSH/Claude sessions)
- apps/flutter/lib/features/terminal/terminal_controller.dart (new - bridges terminal UI with MCP backend, callback-based output/input)
- apps/flutter/lib/screens/terminal/terminal_screen.dart (new - main screen with tab bar and content area)
- apps/flutter/lib/screens/terminal/widgets/terminal_tab_bar.dart (new - horizontal scrollable session tabs with status dots)
- apps/flutter/lib/screens/terminal/widgets/terminal_content.dart (new - output area + shell/Claude input bars)
- apps/flutter/lib/screens/terminal/widgets/ssh_connect_dialog.dart (new - SSH connection form dialog)
- apps/flutter/lib/screens/terminal/widgets/claude_session_dialog.dart (new - Claude model picker dialog)
- apps/flutter/lib/screens/terminal/widgets/new_session_menu.dart (new - popup menu for Terminal/SSH/Claude)
- apps/flutter/lib/core/router/app_router.dart (modified - added Routes.terminal + GoRoute)
- apps/flutter/lib/screens/shell/desktop_shell.dart (modified - added terminal to sidebar enum, rail destination, title switch, content switch)


---
**in-testing -> in-docs** (2026-03-16T21:15:11Z):
## Results
- apps/flutter/test/features/terminal/terminal_test.dart (30 tests - model construction, equality, copyWith, toString, provider initial states, isolation)
- All 30 tests pass


---
**in-docs -> in-review** (2026-03-16T21:15:50Z):
## Docs
- docs/flutter-terminal.md (new - architecture, file map, session types, MCP tools, lifecycle)


---
**Review (approved)** (2026-03-16T21:16:55Z): 13 files, 30 tests, zero errors. Terminal/SSH/Claude sessions fully integrated.
