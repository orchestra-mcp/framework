---
id: FEAT-HPR
kind: bug
priority: P1
project_slug: orchestra-agents
status: done
title: Fix sidebar item styling: active state, colored icon bg, label centering, note switching
type: feature
---

# Fix sidebar item styling: active state, colored icon bg, label centering, note switching

4 issues: (1) Sidebar items need colored background on icon using entity customization color (2) Notes/Projects sidebars don't pass isSelected so no active indication (3) When no subtitle, label should be vertically centered with icon (4) Clicking a note in sidebar while viewing another note should navigate


---
**in-progress -> in-testing** (2026-03-17T11:11:11Z):
## Changes
- apps/flutter/lib/screens/shell/desktop_shell.dart (_SidebarItem: added iconColor param, 28x28 rounded icon container with colored background, label centered when no subtitle, isSelected with route matching for Notes and Projects sidebars, iconColor passed at all 4 sidebar call sites)


---
**in-testing -> in-review** (2026-03-17T11:14:04Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T11:15:42Z): User approved. Sidebar items now have colored icon backgrounds, active state highlighting, proper label centering, and working note switching.
