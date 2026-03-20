---
id: FEAT-DOQ
kind: feature
priority: P1
project_slug: orchestra-win
status: backlog
title: Screenshot plugin — Windows.Graphics.Capture
type: feature
---

# Screenshot plugin — Windows.Graphics.Capture

Implement `Orchestra.Desktop/Services/ScreenCaptureService.cs` — screen and window capture via `Windows.Graphics.Capture` (Win10 19041+).

**`ScreenCaptureService` API:**
```csharp
Task<SoftwareBitmap> CaptureScreenAsync()         // picker → capture primary display
Task<SoftwareBitmap> CaptureWindowAsync(IntPtr hwnd)   // specific window by HWND
Task<SoftwareBitmap> CaptureRegionAsync(RectInt32 rect) // bounding rect crop
Task<string> SaveCaptureAsync(SoftwareBitmap bmp)  // save to %LOCALAPPDATA%\Orchestra\captures\{timestamp}.png
Task<string> CaptureInteractiveAsync()            // user picks window/region via GraphicsCapturePicker
IReadOnlyList<CaptureInfo> ListCaptures()
```

**Implementation:**
- `GraphicsCapturePicker` for interactive selection
- `GraphicsCaptureItem.CreateFromWindowHandle(hwnd)` for window capture
- `Direct3D11CaptureFramePool` → `CaptureSession.StartCapture()` → get one frame → `SoftwareBitmap`
- `BitmapEncoder` (PNG) to save captures

**ai.screenshot MCP tools (6):** `capture_screen`, `capture_region`, `capture_window`, `capture_interactive`, `annotate_screenshot`, `list_captures`

**UI integration:** toolbar button in Spirit window and main window header to trigger capture → auto-attach to current chat message

**Platform:** Desktop (Win10 19041+). Xbox/HoloLens: not supported, graceful hide.