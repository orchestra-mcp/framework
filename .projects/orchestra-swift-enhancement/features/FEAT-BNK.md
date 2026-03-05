---
created_at: "2026-03-04T15:44:25Z"
description: '## Problem\nThe app open animation shows a rounded logo animation expanding outward, but the close animation doesn''t mirror it. The close animation must show the logo rounding back and collapsing to the right (toward the tray icon), matching the open animation in reverse.\n\n## Requirements\n1. **Open animation**: Logo circle expands from tray icon position → full panel (already partially working)\n2. **Close animation**: Must mirror the open — panel shrinks into a rounded logo circle animating to the right toward the tray icon\n3. Both animations should use matched geometry effect or spring animation\n4. Animation duration: ~0.3s with spring damping\n5. Logo should scale down and become circular during close\n6. Position should animate from current panel position toward tray icon location\n7. Opacity fade during the last 30% of close animation\n\n## Affected Files\n- `apps/swift/Shared/Sources/Shared/Components/SmartInputWindowManager.swift` (or similar window manager)\n- `apps/swift/Apps/macOS/OrchestraApp.swift` (window show/hide logic)'
id: FEAT-BNK
kind: bug
priority: P1
project_id: orchestra-swift-enhancement
status: backlog
title: App Open/Close Animation — Rounded Logo Transition Both Directions
updated_at: "2026-03-04T15:44:25Z"
version: 0
---

# App Open/Close Animation — Rounded Logo Transition Both Directions

## Problem\nThe app open animation shows a rounded logo animation expanding outward, but the close animation doesn't mirror it. The close animation must show the logo rounding back and collapsing to the right (toward the tray icon), matching the open animation in reverse.\n\n## Requirements\n1. **Open animation**: Logo circle expands from tray icon position → full panel (already partially working)\n2. **Close animation**: Must mirror the open — panel shrinks into a rounded logo circle animating to the right toward the tray icon\n3. Both animations should use matched geometry effect or spring animation\n4. Animation duration: ~0.3s with spring damping\n5. Logo should scale down and become circular during close\n6. Position should animate from current panel position toward tray icon location\n7. Opacity fade during the last 30% of close animation\n\n## Affected Files\n- `apps/swift/Shared/Sources/Shared/Components/SmartInputWindowManager.swift` (or similar window manager)\n- `apps/swift/Apps/macOS/OrchestraApp.swift` (window show/hide logic)
