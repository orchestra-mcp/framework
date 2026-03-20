---
id: FEAT-WIN
kind: feature
priority: P1
project_slug: orchestra-win
status: backlog
title: Spirit window — floating CompactOverlay mini chat
type: feature
---

# Spirit window — floating CompactOverlay mini chat

Implement `Orchestra.Desktop/Windows/SpiritWindow.xaml/.cs` — always-on-top floating mini chat.

**Window config:**
- Size: 420×640px, `AppWindowPresenterKind.CompactOverlay`
- Extended style: `WS_EX_TOOLWINDOW` (no taskbar button) via `SetWindowLong` P/Invoke
- Acrylic background, `Opacity=0.95`, `CornerRadius=12`
- Frameless: `ExtendsContentIntoTitleBar=true`, custom 32px drag region at top
- Drag region: colored dot + "Spirit" label — `PointerPressed` → `DragMove()`

**Layout (3 rows):**
1. Custom drag title bar (32px) — session name + minimize-to-bubble button
2. `SpiritChatView` (remaining) — compact chat message list (no session sidebar), provider + model badge
3. `ChatInputControl` (auto-height, compact mode) — single-line `TextBox` + send button

**`WindowModeManager.cs`** — manages transitions between Embedded/Floating/Bubble. `CycleMode()` called from global hotkey. State persisted to settings.

**Animations:** slide-in from bottom-right on show (150ms ease-out `TranslationTransition`)

**Platform:** Desktop only