---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    When a permission dialog appears, it breaks the chat layout. Needs smooth animation.

    ## Requirements
    1. Permission card slides in from the bottom of the chat area with spring animation
    2. Chat content dims slightly (0.3 opacity overlay) when permission is active
    3. Permission card has: tool name, tool input preview, reason text
    4. Two clear buttons: 'Allow' (green) and 'Deny' (red)
    5. 'Allow Always' option for recurring tool approvals
    6. Card dismisses with slide-out animation after response
    7. Multiple pending permissions stack as a count badge, shown one at a time
    8. Timeout indicator: circular progress showing time until auto-deny

    ## Affected Files
    - NEW: `apps/swift/Shared/Sources/Shared/Components/PermissionCardView.swift`
    - `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift`
estimate: M
id: FEAT-HXI
kind: feature
labels:
    - plan:PLAN-YST
priority: P1
project_id: orchestra-swift-enhancement
status: backlog
title: Permission View Animation — Fix Layout Breaking
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# Permission View Animation — Fix Layout Breaking

## Problem
When a permission dialog appears, it breaks the chat layout. Needs smooth animation.

## Requirements
1. Permission card slides in from the bottom of the chat area with spring animation
2. Chat content dims slightly (0.3 opacity overlay) when permission is active
3. Permission card has: tool name, tool input preview, reason text
4. Two clear buttons: 'Allow' (green) and 'Deny' (red)
5. 'Allow Always' option for recurring tool approvals
6. Card dismisses with slide-out animation after response
7. Multiple pending permissions stack as a count badge, shown one at a time
8. Timeout indicator: circular progress showing time until auto-deny

## Affected Files
- NEW: `apps/swift/Shared/Sources/Shared/Components/PermissionCardView.swift`
- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift`
