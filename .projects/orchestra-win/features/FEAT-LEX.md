---
id: FEAT-LEX
kind: feature
priority: P1
project_slug: orchestra-win
status: backlog
title: Bubble window — always-on-top circular overlay
type: feature
---

# Bubble window — always-on-top circular overlay

Implement `Orchestra.Desktop/Windows/BubbleWindow.xaml/.cs` — minimal 56×56 always-on-top chat trigger.

**Window config:**
- Size: 56×56px fixed, non-resizable, `AppWindowPresenterKind.CompactOverlay`
- Position: bottom-right of primary display work area (display.WorkArea.Width - 80, Height - 80), saved to settings
- No title bar, no taskbar button (`WS_EX_TOOLWINDOW`), `ExtendsContentIntoTitleBar=true`
- Draggable: `PointerPressed` → `DragMove()` → save new position on `PointerReleased`

**Visual:**
- 56×56 purple circle (`Ellipse`, Fill=#A900FF), white waveform icon glyph center
- Pulse animation (`ScaleTransform` 1.0→1.08→1.0, 2s loop) when AI is processing
- Notification badge (`InfoBadge`, top-right) when unread messages

**Interactions:**
- Single click → open Spirit window, hide Bubble
- Right-click → `MenuFlyout` (Open Orchestra / Quit)
- Scroll up → expand to Spirit; scroll down → stay Bubble

**Platform:** Desktop only