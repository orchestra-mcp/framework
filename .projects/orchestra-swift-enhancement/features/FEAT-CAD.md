---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    All trigger dropdowns (/, @, #, !) open below the input bar, which is at the bottom of the screen. They should open above the input bar.

    ## Current State
    - `apps/swift/Shared/Sources/Shared/Components/InputBarContent.swift` (887 lines) — all popovers use `arrowEdge: .bottom` which makes the popover appear below

    ## Requirements
    1. Change all `.popover(arrowEdge: .bottom)` to `.popover(arrowEdge: .top)` for input bar triggers
    2. Slash commands (/) dropdown opens above input
    3. @ mentions (files/agents) dropdown opens above input
    4. # memory/context dropdown opens above input
    5. ! commands dropdown opens above input
    6. Ensure dropdowns don't clip at the top of the window
    7. Maximum height constraint with scroll for long lists
    8. Proper keyboard navigation (up/down arrows) in correct visual order

    ## Affected Files
    - `apps/swift/Shared/Sources/Shared/Components/InputBarContent.swift`
estimate: S
id: FEAT-CAD
kind: bug
labels:
    - plan:PLAN-YST
priority: P1
project_id: orchestra-swift-enhancement
status: backlog
title: 'Dropdowns (/ @ # !) Open on Top Instead of Bottom'
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# Dropdowns (/ @ # !) Open on Top Instead of Bottom

## Problem
All trigger dropdowns (/, @, #, !) open below the input bar, which is at the bottom of the screen. They should open above the input bar.

## Current State
- `apps/swift/Shared/Sources/Shared/Components/InputBarContent.swift` (887 lines) — all popovers use `arrowEdge: .bottom` which makes the popover appear below

## Requirements
1. Change all `.popover(arrowEdge: .bottom)` to `.popover(arrowEdge: .top)` for input bar triggers
2. Slash commands (/) dropdown opens above input
3. @ mentions (files/agents) dropdown opens above input
4. # memory/context dropdown opens above input
5. ! commands dropdown opens above input
6. Ensure dropdowns don't clip at the top of the window
7. Maximum height constraint with scroll for long lists
8. Proper keyboard navigation (up/down arrows) in correct visual order

## Affected Files
- `apps/swift/Shared/Sources/Shared/Components/InputBarContent.swift`
