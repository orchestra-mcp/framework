---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    The mini floating panel (bubble mode) can only show chat. Should have a toggle to switch between all available plugins.

    ## Current State
    - `apps/swift/Shared/Sources/Shared/ContentView.swift` — three-column macOS layout with sidebar plugin switching
    - `SmartFloatingContent` shows only chat in mini/bubble mode
    - Other plugins (Projects, Notes, Wiki, DevTools) are only accessible in full window mode

    ## Requirements
    1. Bottom tab bar or top segmented control in mini panel
    2. Icons for: Chat (message bubble), Projects (kanban), Notes (sticky note), Wiki (book), DevTools (wrench)
    3. Smooth crossfade animation when switching
    4. Remember last selected plugin per panel mode
    5. Each plugin renders its compact/mini view variant
    6. Badge indicators on tabs (e.g., unread messages on chat, active tasks on projects)
    7. Swipe gesture support for switching between plugins
    8. Double-tap to expand mini panel to full window

    ## Affected Files
    - `apps/swift/Shared/Sources/Shared/ContentView.swift`
    - `apps/swift/Shared/Sources/Shared/Components/SmartFloatingContent.swift` (or similar)
    - NEW: `apps/swift/Shared/Sources/Shared/Components/MiniPanelTabBar.swift`
estimate: M
id: FEAT-WGA
kind: feature
labels:
    - plan:PLAN-YST
priority: P2
project_id: orchestra-swift-enhancement
status: backlog
title: Mini Panel Toggle — Switch Between Chat/Projects/Notes/Wiki/DevTools
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# Mini Panel Toggle — Switch Between Chat/Projects/Notes/Wiki/DevTools

## Problem
The mini floating panel (bubble mode) can only show chat. Should have a toggle to switch between all available plugins.

## Current State
- `apps/swift/Shared/Sources/Shared/ContentView.swift` — three-column macOS layout with sidebar plugin switching
- `SmartFloatingContent` shows only chat in mini/bubble mode
- Other plugins (Projects, Notes, Wiki, DevTools) are only accessible in full window mode

## Requirements
1. Bottom tab bar or top segmented control in mini panel
2. Icons for: Chat (message bubble), Projects (kanban), Notes (sticky note), Wiki (book), DevTools (wrench)
3. Smooth crossfade animation when switching
4. Remember last selected plugin per panel mode
5. Each plugin renders its compact/mini view variant
6. Badge indicators on tabs (e.g., unread messages on chat, active tasks on projects)
7. Swipe gesture support for switching between plugins
8. Double-tap to expand mini panel to full window

## Affected Files
- `apps/swift/Shared/Sources/Shared/ContentView.swift`
- `apps/swift/Shared/Sources/Shared/Components/SmartFloatingContent.swift` (or similar)
- NEW: `apps/swift/Shared/Sources/Shared/Components/MiniPanelTabBar.swift`
