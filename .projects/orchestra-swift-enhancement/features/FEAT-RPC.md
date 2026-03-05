---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    The response waits for ALL tool executions to complete before displaying anything. User sees nothing for potentially minutes while Claude works. Should stream text chunks, tool starts/ends, and thinking events incrementally.

    ## Current State
    - Streaming path (`chat_stream`) is disabled — `sendMessage()` always calls `sendMessageBlocking()`
    - `chat_stream` was disabled because: (a) auto-approve was enabled, (b) bidirectional TCP protocol doesn't support permission responses back
    - `libs/plugin-bridge-claude/internal/tools/prompt.go` — ChatStream handler exists with EventCh-based streaming
    - TCP protocol is unidirectional (server→client StreamChunk messages)

    ## Requirements
    1. Re-enable streaming path with proper permission handling
    2. Implement bidirectional TCP protocol: StreamChunk (server→client) + StreamResponse (client→server) for permission answers
    3. Text chunks appear immediately as they arrive
    4. Tool start events create a 'running' tool card immediately
    5. Tool end events update the card to success/error state
    6. Thinking events show in a dedicated thinking section
    7. Permission events pause the stream and show permission dialog
    8. User permission response sent back through TCP StreamResponse
    9. Graceful degradation: if streaming fails, fall back to blocking mode
    10. Cancel button to abort streaming response

    ## Affected Files
    - `libs/plugin-bridge-claude/internal/tools/prompt.go` (ChatStream handler)
    - `libs/cli/internal/inprocess/tcpserver.go` (bidirectional protocol)
    - `apps/swift/OrchestraKit/Sources/OrchestraKit/Services/OrchestraClient.swift`
    - `apps/swift/OrchestraKit/Sources/OrchestraKit/Services/ToolService.swift`
    - `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift`
estimate: XL
id: FEAT-RPC
kind: feature
labels:
    - plan:PLAN-YST
priority: P0
project_id: orchestra-swift-enhancement
status: backlog
title: Streaming Incremental Response — Messages and Tools Appear in Real-Time
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# Streaming Incremental Response — Messages and Tools Appear in Real-Time

## Problem
The response waits for ALL tool executions to complete before displaying anything. User sees nothing for potentially minutes while Claude works. Should stream text chunks, tool starts/ends, and thinking events incrementally.

## Current State
- Streaming path (`chat_stream`) is disabled — `sendMessage()` always calls `sendMessageBlocking()`
- `chat_stream` was disabled because: (a) auto-approve was enabled, (b) bidirectional TCP protocol doesn't support permission responses back
- `libs/plugin-bridge-claude/internal/tools/prompt.go` — ChatStream handler exists with EventCh-based streaming
- TCP protocol is unidirectional (server→client StreamChunk messages)

## Requirements
1. Re-enable streaming path with proper permission handling
2. Implement bidirectional TCP protocol: StreamChunk (server→client) + StreamResponse (client→server) for permission answers
3. Text chunks appear immediately as they arrive
4. Tool start events create a 'running' tool card immediately
5. Tool end events update the card to success/error state
6. Thinking events show in a dedicated thinking section
7. Permission events pause the stream and show permission dialog
8. User permission response sent back through TCP StreamResponse
9. Graceful degradation: if streaming fails, fall back to blocking mode
10. Cancel button to abort streaming response

## Affected Files
- `libs/plugin-bridge-claude/internal/tools/prompt.go` (ChatStream handler)
- `libs/cli/internal/inprocess/tcpserver.go` (bidirectional protocol)
- `apps/swift/OrchestraKit/Sources/OrchestraKit/Services/OrchestraClient.swift`
- `apps/swift/OrchestraKit/Sources/OrchestraKit/Services/ToolService.swift`
- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift`
