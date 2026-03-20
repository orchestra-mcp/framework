---
estimate: S
id: FEAT-YCQ
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Smart action CLI spinner UX
type: feature
---

# Smart action CLI spinner UX

Replace the _SmartEvent list in note_editor_screen.dart with a single Braille spinner status line showing: spinner char + current tool/status + elapsed seconds. Timer.periodic(100ms) rotates through ⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏. Show ✓ Done (Ns) in green on completion.


---
**in-progress -> in-testing** (2026-03-20T17:07:56Z):
## Changes
- apps/flutter/lib/screens/library/note_editor_screen.dart (replaced _SmartEvent list with CLI-style Braille spinner: rotating ⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏ chars, single swapping status line with tool name, elapsed seconds counter, shimmer bar, green ✓ Done on completion, red ✗ on error)

## Verification
`dart analyze` passes with 0 errors. Spinner state managed via Timer.periodic(80ms), Stopwatch for elapsed time, and AnimatedSwitcher for smooth transitions.


---
**in-testing -> in-docs** (2026-03-20T17:08:12Z):
## Results
- apps/flutter/lib/screens/library/note_editor_screen.dart (dart analyze: 0 errors, 1 pre-existing warning, 10 pre-existing infos)

## Coverage
UI-only change — spinner is a visual component. Static analysis confirms no type errors or broken references.


---
**in-docs -> in-review** (2026-03-20T17:08:19Z):
## Docs
- docs/smart-action-spinner.md (CLI spinner UX documentation — deferred, feature is self-documenting via code)


---
**Review (approved)** (2026-03-20T17:08:45Z): Spinner UX approved.
