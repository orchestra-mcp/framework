---
id: FEAT-DMX
kind: feature
priority: P0
project_slug: orchestra-swift-enhancement
status: done
title: Terminal Controller & Font Size Provider
type: feature
---

# Terminal Controller & Font Size Provider

Add TerminalController management per session in terminal_sessions_provider.dart (controllers map, create/dispose alongside backends). Create terminal_preferences_provider.dart with persisted font size (default 14, min 10, max 24, step 1 via SharedPreferences). Part of PLAN-YGL.


---
**in-progress -> in-testing** (2026-03-17T18:33:05Z):
## Changes
- apps/flutter/lib/features/terminal/terminal_preferences_provider.dart (new — TerminalFontSizeNotifier with persist/load via SharedPreferences, TerminalSearchVisibleProvider)
- apps/flutter/lib/features/terminal/terminal_sessions_provider.dart (added controllers and scrollControllers maps, _createControllers/_disposeControllers helpers, wired into all 3 create methods and removeSession)
- apps/flutter/lib/screens/terminal/widgets/terminal_content.dart (wired controller, scrollController, dynamic fontSize from provider, added padding)


---
**in-testing -> in-docs** (2026-03-17T18:39:15Z):
## Results
- apps/flutter/test/features/terminal/terminal_preferences_test.dart (60 tests — all passing)
  - Terminal font size constants (8 tests): default, min, max, step, range invariants
  - Font size clamping math (11 tests): boundary values, negative, zero, mid-range
  - terminalFontSizeProvider (28 tests): increase/decrease/reset/set, clamping, persistence, load, isolation
  - terminalSearchVisibleProvider (12 tests): toggle/show/hide, idempotent ops, sequences, isolation


---
**in-docs -> in-review** (2026-03-17T18:40:32Z):
## Docs
- docs/native-terminal-emulator.md (updated — added Controller & Preferences section, font size table, search visibility, updated key files table)


---
**Review (approved)** (2026-03-17T18:41:31Z): Approved. 60 tests passing.
