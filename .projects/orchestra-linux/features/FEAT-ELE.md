---
id: FEAT-ELE
kind: feature
priority: P1
project_slug: orchestra-linux
status: backlog
title: Bubble overlay window (always-on-top circular)
type: feature
---

# Bubble overlay window (always-on-top circular)

BubbleWindow: 56x56px non-resizable window. On Wayland: gtk4-layer-shell OVERLAY layer, anchored to bottom-right with 20px margins, exclusive zone -1. On X11: override-redirect or _NET_WM_STATE_ABOVE + _NET_WM_STATE_SKIP_TASKBAR. Circular shape via CSS (border-radius: 50%). Shows Orchestra logo SVG. Click opens Spirit window. Right-click shows context menu (Open Main, Open Spirit, Quit). CSS glow pulse animation when AI is processing.