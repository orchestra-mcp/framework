# Flutter Desktop Sidebar Animation

## Overview

The desktop shell sidebar uses an `AnimatedContainer` with `ClipRect` + `OverflowBox` for a smooth slide-in/slide-out effect when toggling the sidebar panel.

## Implementation

- **File:** `apps/flutter/lib/screens/shell/desktop_shell.dart`
- **Animation:** 200ms `easeInOut` curve
- **Width:** Transitions between `0.0` (closed) and `260.0` (open)
- **Technique:** `ClipRect` wraps an `OverflowBox` with fixed `maxWidth: 260` so the sidebar content doesn't reflow during animation — it slides in/out like a drawer.

## State Management

The `sidebarVisibleProvider` (Riverpod `Notifier<bool>`) controls open/close state. Rail icon taps toggle it via `ref.read(sidebarVisibleProvider.notifier).toggle()`.
