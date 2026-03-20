---
id: FEAT-BEU
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: Window mode cycling (Ctrl+Shift+O)
type: feature
---

# Window mode cycling (Ctrl+Shift+O)

WindowModeManager cycling between three modes: Main (primary AdwApplicationWindow 1280x860), Floating (SpiritWindow 420x640), Bubble (BubbleWindow 56x56). Ctrl+Shift+O global shortcut via xdg-desktop-portal GlobalShortcuts portal (Wayland-safe) with X11 XGrabKey fallback. app.cycle-window action triggers mode change. Current mode persisted to GSettings window-mode key. Mode transitions: hide current window, show next. Main→Floating→Bubble→Main cycle.