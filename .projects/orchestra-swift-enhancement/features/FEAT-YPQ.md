---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    Browser context service only polls Chrome tabs. Should detect and list tabs from all open browsers.

    ## Current State
    - `apps/swift/Shared/Sources/Shared/Services/BrowserContextService.swift` — Chrome tab polling via `ai.browser-context` MCP tool
    - Only supports Chrome, no Safari/Firefox/Arc/Brave/Edge support
    - No UI to display or select browser tabs

    ## Requirements
    1. Detect all running browsers: Chrome, Safari, Firefox, Arc, Brave, Edge, Opera
    2. List open tabs from each browser with: title, URL, favicon
    3. Tab picker UI accessible from input bar (globe icon or @ trigger)
    4. Select a tab to include its URL/content as context in the message
    5. Option to capture tab screenshot for visual context
    6. Tab search/filter within the picker
    7. Group tabs by browser
    8. Use AppleScript for Safari, Chrome DevTools Protocol for Chromium-based, accessibility APIs as fallback

    ## Affected Files
    - `apps/swift/Shared/Sources/Shared/Services/BrowserContextService.swift`
    - NEW: `apps/swift/Shared/Sources/Shared/Components/BrowserTabPicker.swift`
    - `apps/swift/Shared/Sources/Shared/Components/InputBarContent.swift`
estimate: L
id: FEAT-YPQ
kind: feature
labels:
    - plan:PLAN-YST
priority: P2
project_id: orchestra-swift-enhancement
status: backlog
title: Browser Vision — Get Tabs from All Open Browsers
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# Browser Vision — Get Tabs from All Open Browsers

## Problem
Browser context service only polls Chrome tabs. Should detect and list tabs from all open browsers.

## Current State
- `apps/swift/Shared/Sources/Shared/Services/BrowserContextService.swift` — Chrome tab polling via `ai.browser-context` MCP tool
- Only supports Chrome, no Safari/Firefox/Arc/Brave/Edge support
- No UI to display or select browser tabs

## Requirements
1. Detect all running browsers: Chrome, Safari, Firefox, Arc, Brave, Edge, Opera
2. List open tabs from each browser with: title, URL, favicon
3. Tab picker UI accessible from input bar (globe icon or @ trigger)
4. Select a tab to include its URL/content as context in the message
5. Option to capture tab screenshot for visual context
6. Tab search/filter within the picker
7. Group tabs by browser
8. Use AppleScript for Safari, Chrome DevTools Protocol for Chromium-based, accessibility APIs as fallback

## Affected Files
- `apps/swift/Shared/Sources/Shared/Services/BrowserContextService.swift`
- NEW: `apps/swift/Shared/Sources/Shared/Components/BrowserTabPicker.swift`
- `apps/swift/Shared/Sources/Shared/Components/InputBarContent.swift`
