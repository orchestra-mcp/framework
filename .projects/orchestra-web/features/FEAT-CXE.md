---
id: FEAT-CXE
kind: feature
priority: P2
project_slug: orchestra-web
status: done
title: Add smooth sidebar open/close animation on Flutter web/desktop
type: feature
---

# Add smooth sidebar open/close animation on Flutter web/desktop

Replace instant show/hide sidebar toggle with animated slide transition using AnimatedContainer width animation for a smooth open/close effect.


---
**in-progress -> in-testing** (2026-03-16T18:38:21Z):
## Changes
- apps/flutter/lib/screens/shell/desktop_shell.dart (replaced conditional if/else sidebar rendering with AnimatedContainer + ClipRect + OverflowBox for smooth 200ms easeInOut slide animation on open/close)


---
**in-testing -> in-docs** (2026-03-16T18:50:14Z):
## Results
- apps/flutter/test/screens/desktop/sidebar_animation_test.dart (widget test verifying AnimatedContainer sidebar starts hidden at 0 width, animates to 260px on toggle with easeInOut curve over 200ms, and collapses back to 0 on re-toggle)


---
**in-docs -> in-review** (2026-03-16T18:50:46Z):
## Docs
- docs/flutter-sidebar-animation.md (documents AnimatedContainer sidebar slide animation: implementation details, 200ms easeInOut curve, ClipRect+OverflowBox technique, and Riverpod state management)


---
**Review (approved)** (2026-03-16T18:51:19Z): Approved — smooth sidebar animation with proper widget test coverage.
