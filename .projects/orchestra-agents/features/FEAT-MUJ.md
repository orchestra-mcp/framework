---
estimate: M
id: FEAT-MUJ
kind: feature
priority: medium
project_slug: orchestra-agents
status: done
title: Pomodoro standalone floating desktop widget with countdown
type: feature
---

# Pomodoro standalone floating desktop widget with countdown

Create a floating pomodoro widget for Flutter desktop. Small always-on-top window: timer countdown (MM:SS), current phase, session count. Controls: start/pause/skip/reset. Minimize to tiny pill. Integrates with existing PomodoroManager. Desktop only.


---
**in-progress -> in-testing** (2026-03-20T18:42:54Z):
## Changes
- apps/flutter/lib/features/pomodoro/pomodoro_floating_widget.dart (new — PomodoroFloatingController with OverlayEntry, draggable overlay, minimized pill mode, expanded card with timer/controls/progress/session count)
- apps/flutter/lib/screens/health/tabs/pomodoro_tab.dart (added Float toggle button to _Controls, desktop-only, imports for platform_utils and floating widget)


---
**in-testing -> in-docs** (2026-03-20T18:43:31Z):
## Results
- apps/flutter/test/features/pomodoro/pomodoro_floating_widget_test.dart (19 tests — controller visibility, timeDisplay formatting, progress calculation, phase durations, isActive checks, labels, copyWith)
- All 19 tests pass: `flutter test test/features/pomodoro/pomodoro_floating_widget_test.dart` → 19/19 passed


---
**in-docs -> in-review** (2026-03-20T18:44:27Z):
## Docs
- docs/health-detail-pages-ux.md (updated — added Float button description to Pomodoro section, added new Pomodoro Floating Widget section with expanded/minimized modes, controls, glass effect, phase colors, controller API)


---
**Review (approved)** (2026-03-20T18:44:46Z): Floating pomodoro widget with expanded/minimized modes, draggable overlay, phase colors, 19 tests passing.
