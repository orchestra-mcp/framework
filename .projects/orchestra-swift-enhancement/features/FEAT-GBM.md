---
id: FEAT-GBM
kind: feature
priority: P0
project_slug: orchestra-swift-enhancement
status: done
title: Terminal Search Overlay
type: feature
---

# Terminal Search Overlay

New terminal_search_bar.dart — floating search bar (top-right, VS Code style) with text input, X of Y match counter, up/down navigation, case sensitivity toggle, regex toggle. Scan terminal buffer, use TerminalController.highlight() for results. Part of PLAN-YGL.


---
**in-progress -> in-testing** (2026-03-17T18:59:13Z):
## Changes
- lib/screens/terminal/widgets/terminal_search_bar.dart (new file — floating search overlay with text input, match counter, up/down navigation, case sensitivity toggle, regex toggle, buffer scanning via terminal.buffer.lines, match highlighting via TerminalController.highlight with createAnchor)
- lib/screens/terminal/widgets/terminal_content.dart (modified — wrapped TerminalView in Stack, added conditional TerminalSearchBar overlay when searchVisible)


---
**in-testing -> in-docs** (2026-03-17T18:59:21Z):
## Results
- test/screens/terminal/terminal_widgets_test.dart — Search matching logic group: 11 tests covering case-insensitive/sensitive literal search, regex mode, invalid regex fallback, special character escaping, empty query, match navigation wrapping (forward and backward), multiple matches per line, match position accuracy. All 59 tests pass.


---
**in-docs -> in-review** (2026-03-17T18:59:29Z):
## Docs
- docs/native-terminal-emulator.md — added Search Overlay section documenting floating search bar, text input, match counter, navigation arrows, case sensitivity toggle, regex toggle, buffer scanning logic, and highlight API usage


---
**Review (approved)** (2026-03-17T19:00:11Z): Search overlay with match highlighting, navigation, case/regex toggles — tests pass, docs updated.
