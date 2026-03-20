---
id: FEAT-OAA
kind: bug
priority: P0
project_slug: orchestra-swift-enhancement
status: done
title: Unicode Width Fix for Terminal
type: feature
---

# Unicode Width Fix for Terminal

Fix Unicode/emoji rendering misalignment in Claude CLI terminal output. xterm.dart v4 uses Unicode 11 wcwidth tables that don't cover modern emoji. Try Terminal(platform: web) first, else apply targeted width override. Part of PLAN-YGL.


---
**in-progress -> in-testing** (2026-03-17T19:02:06Z):
## Changes
- lib/features/terminal/claude_terminal_backend.dart (modified — added _sanitizeUnicode static method that strips variation selectors U+FE0E/U+FE0F and zero-width joiners U+200D from PTY output before writing to terminal buffer, wired into output listener)


---
**in-testing -> in-review** (2026-03-17T19:02:31Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T19:03:45Z): Unicode sanitization fix for variation selectors and ZWJ — 12 tests pass.
