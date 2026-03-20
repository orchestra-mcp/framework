---
id: FEAT-DQA
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: Spirit window (floating mini chat)
type: feature
---

# Spirit window (floating mini chat)

SpiritWindow subclassing Adw.Window (420x640). Always-on-top via Gdk.ToplevelSurface state. On Wayland: use gtk4-layer-shell (GtkLayerShell.Layer.OVERLAY). On X11: GDK _NET_WM_STATE_ABOVE hint. Semi-transparent background via CSS (alpha(@orchestra_bg, 0.92)), rounded corners (border-radius: 16px), border 1px @orchestra_border. Compact ChatView variant showing only ChatBox (no session sidebar). AdwHeaderBar with hide titlebar, close button hides (not quits). Draggable by window background. Remembers position in GSettings (spirit-x, spirit-y).