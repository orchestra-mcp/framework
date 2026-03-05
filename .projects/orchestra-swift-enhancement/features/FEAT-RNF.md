---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    Screenshot capture works (`ScreenshotService.swift`) but there's no UI integration to send screenshots to AI for analysis.

    ## Current State
    - `apps/swift/Shared/Sources/Shared/Services/ScreenshotService.swift` — capture works via `SCScreenshotManager`
    - No button/flow to attach screenshots to chat messages
    - No integration with AI vision tools (`ai.vision`, `ai.screenshot` plugins)

    ## Requirements
    1. Screenshot button in input bar (camera icon)
    2. Click to capture: region select, window select, full screen
    3. Paste image from clipboard (CMD+V with image data)
    4. Drag and drop images into chat
    5. Image preview thumbnail in input bar before sending
    6. Image sent to AI vision plugin for analysis
    7. AI can reference image content in its response
    8. Image displayed inline in the message bubble
    9. Click image to view full size in a modal
    10. Multiple images per message supported

    ## Affected Files
    - `apps/swift/Shared/Sources/Shared/Services/ScreenshotService.swift`
    - `apps/swift/Shared/Sources/Shared/Components/InputBarContent.swift`
    - `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift`
    - NEW: `apps/swift/Shared/Sources/Shared/Components/ImagePreviewView.swift`
estimate: L
id: FEAT-RNF
kind: feature
labels:
    - plan:PLAN-YST
priority: P2
project_id: orchestra-swift-enhancement
status: backlog
title: AI Vision — Screenshot Integration with Chat
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# AI Vision — Screenshot Integration with Chat

## Problem
Screenshot capture works (`ScreenshotService.swift`) but there's no UI integration to send screenshots to AI for analysis.

## Current State
- `apps/swift/Shared/Sources/Shared/Services/ScreenshotService.swift` — capture works via `SCScreenshotManager`
- No button/flow to attach screenshots to chat messages
- No integration with AI vision tools (`ai.vision`, `ai.screenshot` plugins)

## Requirements
1. Screenshot button in input bar (camera icon)
2. Click to capture: region select, window select, full screen
3. Paste image from clipboard (CMD+V with image data)
4. Drag and drop images into chat
5. Image preview thumbnail in input bar before sending
6. Image sent to AI vision plugin for analysis
7. AI can reference image content in its response
8. Image displayed inline in the message bubble
9. Click image to view full size in a modal
10. Multiple images per message supported

## Affected Files
- `apps/swift/Shared/Sources/Shared/Services/ScreenshotService.swift`
- `apps/swift/Shared/Sources/Shared/Components/InputBarContent.swift`
- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift`
- NEW: `apps/swift/Shared/Sources/Shared/Components/ImagePreviewView.swift`
