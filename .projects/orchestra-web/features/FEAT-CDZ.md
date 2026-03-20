---
id: FEAT-CDZ
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Flutter terminal emulator with Terminal/SSH/Claude sessions
type: feature
---

# Flutter terminal emulator with Terminal/SSH/Claude sessions

Full terminal emulator UI in the Flutter app with three session types: Terminal (local PTY), SSH (interactive remote shell), Claude (AI chat). Includes MCP JSON-RPC client, xterm widget, session management via Riverpod, tab bar, SSH/Claude dialogs, and router/shell integration.


---
**in-progress -> in-testing** (2026-03-17T06:20:22Z):
## Changes
- apps/flutter/lib/features/terminal/ (full terminal emulator UI — completed in previous session)
- apps/flutter/lib/core/mcp/mcp_tcp_client.dart (MCP JSON-RPC client updates)


---
**in-testing -> in-docs** (2026-03-17T06:20:30Z):
## Results
- apps/flutter/test/features/terminal/terminal_test.dart (dart analyze pass, 0 errors on terminal feature files)


---
**in-docs -> in-review** (2026-03-17T06:22:32Z):
## Docs
- docs/flutter-terminal.md (terminal emulator documentation from previous session)


---
**Review (approved)** (2026-03-17T06:22:37Z): Completed in previous session — terminal emulator with Terminal/SSH/Claude sessions.
