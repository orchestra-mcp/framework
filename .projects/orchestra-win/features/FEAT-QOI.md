---
id: FEAT-QOI
kind: feature
priority: P3
project_slug: orchestra-win
status: backlog
title: HoloLens / Mixed Reality — spatial workspace layout
type: feature
---

# HoloLens / Mixed Reality — spatial workspace layout

Implement HoloLens-specific adaptations for holographic multi-window spatial workspace.

**Detection:** `AnalyticsInfo.VersionInfo.DeviceFamily == "Windows.Holographic"`

**Layout strategy:**
- Each plugin opens as a separate `AppWindow` positioned in 3D space via `SpatialLocator` / `CoreWindow` APIs
- Chat window: floats at arm's length, 800×600px virtual
- Projects window: left panel, 640×900px virtual
- Notes window: right panel, 640×900px virtual
- DevTools: lower panel, 1200×400px virtual

**Input:** Gaze + Air Tap (primary), hand ray, voice commands via STT (`stt_listen` → command dispatch), optional clicker

**`HoloLensInputService.cs`:**
- `GazeInputSourcePreview` for gaze tracking
- `SpatialInteractionManager` for hand tracking
- Voice command grammar: "Open Chat", "New Feature", "Show Projects", "Ask Claude [query]"

**`SpatialWindowManager.cs`:**
- Saves window positions to settings (restored on next launch)
- "Reset Layout" voice command snaps all windows to default positions
- Window resize via hand pinch-drag

**Plugin set (HoloLens):** Chat (full), Projects (full), Notes (full), DevTools (File Explorer + Terminal only), Settings (subset). No Docker, no screenshot, no tray.

**Platform:** HoloLens 2 (Windows.Holographic, Windows App SDK 1.5+)