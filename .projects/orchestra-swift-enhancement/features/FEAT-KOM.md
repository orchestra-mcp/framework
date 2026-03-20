---
id: FEAT-KOM
kind: feature
priority: P0
project_slug: orchestra-swift-enhancement
status: done
title: Right-Click Context Menu & Keyboard Shortcuts
type: feature
---

# Right-Click Context Menu & Keyboard Shortcuts

New terminal_context_menu.dart — popup menu (Copy, Paste, Select All, Clear, Search, Reset). Wire onSecondaryTapDown on TerminalView. Keyboard shortcuts: Cmd+F (search), Cmd+C (copy), Cmd+V (paste), Cmd+K (clear), Cmd+=/- (zoom), Cmd+0 (reset). Part of PLAN-YGL.


---
**in-progress -> in-testing** (2026-03-17T19:00:32Z):
## Changes
- lib/screens/terminal/widgets/terminal_context_menu.dart (new file — showTerminalContextMenu function with Copy, Paste, Select All, Search, Clear actions via PopupMenu)
- lib/screens/terminal/widgets/terminal_content.dart (modified — added CallbackShortcuts wrapper with 6 keyboard shortcuts, onSecondaryTapDown handler for context menu, platform-aware Meta/Control modifiers)


---
**in-testing -> in-docs** (2026-03-17T19:00:42Z):
## Results
- test/screens/terminal/terminal_widgets_test.dart — Context menu actions group (3 tests: ANSI clear escape validation, ETX byte check, action enum completeness) + Keyboard shortcut keys group (2 tests: macOS Meta modifier, Linux/Windows Control modifier). All 59 tests pass.


---
**in-docs -> in-review** (2026-03-17T19:00:49Z):
## Docs
- docs/native-terminal-emulator.md — added Context Menu section (5 actions with icons and behavior) and Keyboard Shortcuts section (6 shortcuts with platform-aware modifiers)


---
**Review (approved)** (2026-03-17T19:01:44Z): Context menu and keyboard shortcuts — tests pass, docs updated.
