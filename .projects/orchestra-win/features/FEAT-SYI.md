---
id: FEAT-SYI
kind: feature
priority: P1
project_slug: orchestra-win
status: backlog
title: Global hotkey — Win+Shift+O via RegisterHotKey
type: feature
---

# Global hotkey — Win+Shift+O via RegisterHotKey

Implement `Orchestra.Desktop/Services/GlobalHotkeyService.cs` — system-wide hotkey to cycle window modes.

**Win32 P/Invoke:**
```csharp
[LibraryImport("user32.dll")]
private static partial bool RegisterHotKey(IntPtr hWnd, int id, uint fsModifiers, uint vk);

[LibraryImport("user32.dll")]
private static partial bool UnregisterHotKey(IntPtr hWnd, int id);
```

**Registration:** `Win+Shift+O` → `MOD_WIN | MOD_SHIFT`, vk=`0x4F` (O), hotkey ID=9001

**Message dispatch:** hook `MainWindow`'s `WndProc` via `WinRT.Interop.WindowNative.GetWindowHandle` + subclass. On `WM_HOTKEY` (0x0312) with wParam=9001 → call `WindowModeManager.CycleMode()`

**Cycle:** Embedded → Floating (Spirit) → Bubble → Embedded

**Configurable:** hotkey combination editable in Settings → Windows section. Unregister old + register new on change.

**Conflict handling:** if `RegisterHotKey` returns false, show `InfoBar` warning "Hotkey already in use by another app. Please choose a different combination."

**Cleanup:** `IDisposable.Dispose()` calls `UnregisterHotKey`

**Platform:** Desktop only (Win32 API)