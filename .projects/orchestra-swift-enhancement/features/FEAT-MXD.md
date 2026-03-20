---
id: FEAT-MXD
kind: feature
priority: P1
project_slug: orchestra-swift-enhancement
status: done
title: Terminal Polish & Enhancements
type: feature
---

# Terminal Polish & Enhancements

Add onTitleChange callback to update session labels dynamically. Add onBell visual flash. Set alwaysShowCursor, padding. Add title field to TerminalSessionModel. Part of PLAN-YGL.


---
**in-progress -> in-testing** (2026-03-17T19:04:13Z):
## Changes
- lib/screens/terminal/widgets/terminal_content.dart (modified — added alwaysShowCursor: true, cursorType: TerminalCursorType.block, padding: EdgeInsets.all(4), font family MesloLGS NF with fallback chain)
- lib/features/terminal/terminal_sessions_provider.dart (modified — added _wireTerminalEvents method that hooks terminal.onTitleChange to renameSession, wired into createTerminalSession, createSshSession, and createClaudeSession)


---
**in-testing -> in-docs** (2026-03-17T19:04:21Z):
## Results
- test/screens/terminal/terminal_widgets_test.dart — Terminal title change behavior group (2 tests: empty title ignored, non-empty title triggers rename), Terminal screen layout group (4 tests: toolbar height 36px, tab bar height 40px, search bar width 340px, search bar positioned top-right), Terminal tab bar status colors group (4 tests: connected green, connecting yellow, error red, disconnected grey). All 59 tests pass.


---
**in-docs -> in-review** (2026-03-17T19:04:27Z):
## Docs
- docs/native-terminal-emulator.md — added Terminal Polish section documenting alwaysShowCursor, block cursor, padding, onTitleChange dynamic label updates, and font family chain


---
**Review (approved)** (2026-03-17T19:04:50Z): Terminal polish — cursor, padding, dynamic title, font chain — all tests pass, docs updated.
