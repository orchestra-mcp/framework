---
id: FEAT-RVR
kind: feature
priority: P0
project_slug: orchestra-swift-enhancement
status: done
title: Terminal Toolbar
type: feature
---

# Terminal Toolbar

New terminal_toolbar.dart — compact 36px toolbar with: search toggle, font size +/-, copy, paste, clear buffer, kill process buttons. Integrate into terminal_screen.dart as Column between tab bar and content. Part of PLAN-YGL.


---
**in-progress -> in-testing** (2026-03-17T18:43:39Z):
## Changes
- apps/flutter/lib/screens/terminal/widgets/terminal_toolbar.dart (new — 36px toolbar with search toggle, font size +/-, copy, paste, clear buffer, kill/interrupt buttons)
- apps/flutter/lib/screens/terminal/terminal_screen.dart (integrated TerminalToolbar in Column above TerminalContent)


---
**in-testing -> in-docs** (2026-03-17T18:57:17Z):
## Results
- test/screens/terminal/terminal_widgets_test.dart — 59 tests all passing, covering toolbar structure, platform-specific modifier keys (macOS ⌘ vs Ctrl+), font size controls, search visibility toggle, context menu actions, ANSI escape sequences, session model CRUD, and layout dimensions


---
**in-docs -> in-review** (2026-03-17T18:58:04Z):
## Docs
- docs/native-terminal-emulator.md — added Toolbar section documenting all 8 toolbar buttons with icons, actions, and keyboard shortcuts


---
**Review (approved)** (2026-03-17T18:58:21Z): Toolbar with search, font size, copy/paste, clear, kill — 59 tests pass, docs updated.
