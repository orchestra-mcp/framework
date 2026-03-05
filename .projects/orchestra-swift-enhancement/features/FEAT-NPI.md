---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    When exporting code/tables as images, the background should be configurable.

    ## Requirements
    1. Settings panel section for 'Export Appearance'
    2. Background options: solid color picker, gradient presets, transparent
    3. Preset gradients: Ocean, Sunset, Forest, Night, Carbon, Minimal
    4. Custom gradient: two-color picker with angle control
    5. Padding control: small/medium/large
    6. Corner radius: none/small/medium/large
    7. Shadow: none/subtle/prominent
    8. Live preview in settings
    9. Persist settings via UserDefaults

    ## Affected Files
    - `apps/swift/Shared/Sources/Shared/Services/ExportService.swift`
    - `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift` (settings section)
    - NEW: `apps/swift/Shared/Sources/Shared/Models/ExportSettings.swift`
estimate: M
id: FEAT-NPI
kind: feature
labels:
    - plan:PLAN-YST
priority: P3
project_id: orchestra-swift-enhancement
status: backlog
title: Configurable Image Export Background in Settings
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# Configurable Image Export Background in Settings

## Problem
When exporting code/tables as images, the background should be configurable.

## Requirements
1. Settings panel section for 'Export Appearance'
2. Background options: solid color picker, gradient presets, transparent
3. Preset gradients: Ocean, Sunset, Forest, Night, Carbon, Minimal
4. Custom gradient: two-color picker with angle control
5. Padding control: small/medium/large
6. Corner radius: none/small/medium/large
7. Shadow: none/subtle/prominent
8. Live preview in settings
9. Persist settings via UserDefaults

## Affected Files
- `apps/swift/Shared/Sources/Shared/Services/ExportService.swift`
- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift` (settings section)
- NEW: `apps/swift/Shared/Sources/Shared/Models/ExportSettings.swift`
