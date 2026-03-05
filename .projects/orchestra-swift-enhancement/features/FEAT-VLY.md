---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    When Claude sends an `AskUserQuestion` event, it appears in the Swift UI as an unknown/unhandled permission type. The user cannot answer the question, which blocks the entire Claude workflow.

    ## Current State
    - `libs/plugin-bridge-claude/internal/process.go` — emits `question` event type to EventCh
    - `apps/swift/OrchestraKit/Sources/OrchestraKit/Models/Models.swift` — has `.question` in ChatEventType enum
    - `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift` — has `.question` case in streaming handler but streaming is disabled
    - The blocking path (`send_message`) doesn't surface question events at all

    ## Requirements
    1. Surface `AskUserQuestion` events in the blocking `send_message` path
    2. Render a dedicated Question Card UI with the question text and options
    3. Support single-select and multi-select question types
    4. User's answer must be sent back via `respond_permission` with the answer text
    5. Question card must show option descriptions if provided
    6. Support free-text 'Other' option input
    7. Question must block further Claude execution until answered

    ## Affected Files
    - `libs/plugin-bridge-claude/internal/process.go`
    - `libs/plugin-tools-sessions/internal/tools/message.go`
    - `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift`
    - NEW: `apps/swift/Shared/Sources/Shared/Components/QuestionCardView.swift`
estimate: M
id: FEAT-VLY
kind: bug
labels:
    - plan:PLAN-YST
priority: P0
project_id: orchestra-swift-enhancement
status: backlog
title: AskUserQuestion Displays as Unknown Permission Type
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# AskUserQuestion Displays as Unknown Permission Type

## Problem
When Claude sends an `AskUserQuestion` event, it appears in the Swift UI as an unknown/unhandled permission type. The user cannot answer the question, which blocks the entire Claude workflow.

## Current State
- `libs/plugin-bridge-claude/internal/process.go` — emits `question` event type to EventCh
- `apps/swift/OrchestraKit/Sources/OrchestraKit/Models/Models.swift` — has `.question` in ChatEventType enum
- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift` — has `.question` case in streaming handler but streaming is disabled
- The blocking path (`send_message`) doesn't surface question events at all

## Requirements
1. Surface `AskUserQuestion` events in the blocking `send_message` path
2. Render a dedicated Question Card UI with the question text and options
3. Support single-select and multi-select question types
4. User's answer must be sent back via `respond_permission` with the answer text
5. Question card must show option descriptions if provided
6. Support free-text 'Other' option input
7. Question must block further Claude execution until answered

## Affected Files
- `libs/plugin-bridge-claude/internal/process.go`
- `libs/plugin-tools-sessions/internal/tools/message.go`
- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift`
- NEW: `apps/swift/Shared/Sources/Shared/Components/QuestionCardView.swift`
