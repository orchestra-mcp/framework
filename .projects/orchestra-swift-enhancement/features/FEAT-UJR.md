---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    Agent ops metadata (context window, tokens in/out, total cost) is not displaying correctly or is incomplete.

    ## Current State
    - `ChatMessage` has `tokensIn`, `tokensOut`, `costUSD`, `modelUsed`, `durationMs` fields
    - These come from the `result` event type at end of Claude execution
    - Values may not be populated correctly from the blocking `send_message` path

    ## Requirements
    1. Show context window usage (tokens used / max context) as a progress bar
    2. Display input tokens and output tokens separately
    3. Show total cost formatted as USD (e.g., $0.0342)
    4. Show model name used (e.g., claude-opus-4-6)
    5. Show response duration
    6. Cumulative session totals in a session header bar: total tokens, total cost, message count
    7. Per-message metadata badge (collapsed by default, expandable)
    8. Data must come through reliably in blocking path via `send_message` response
    9. Cost calculation should account for cached input tokens if available

    ## Affected Files
    - `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift`
    - `libs/plugin-tools-sessions/internal/tools/message.go`
    - `libs/plugin-bridge-claude/internal/tools/session.go`
    - NEW: `apps/swift/Shared/Sources/Shared/Components/AgentOpsView.swift`
estimate: M
id: FEAT-UJR
kind: bug
labels:
    - plan:PLAN-YST
priority: P1
project_id: orchestra-swift-enhancement
status: backlog
title: Agent Ops Data — Show CTX, All Tokens, Total Cost Correctly
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# Agent Ops Data — Show CTX, All Tokens, Total Cost Correctly

## Problem
Agent ops metadata (context window, tokens in/out, total cost) is not displaying correctly or is incomplete.

## Current State
- `ChatMessage` has `tokensIn`, `tokensOut`, `costUSD`, `modelUsed`, `durationMs` fields
- These come from the `result` event type at end of Claude execution
- Values may not be populated correctly from the blocking `send_message` path

## Requirements
1. Show context window usage (tokens used / max context) as a progress bar
2. Display input tokens and output tokens separately
3. Show total cost formatted as USD (e.g., $0.0342)
4. Show model name used (e.g., claude-opus-4-6)
5. Show response duration
6. Cumulative session totals in a session header bar: total tokens, total cost, message count
7. Per-message metadata badge (collapsed by default, expandable)
8. Data must come through reliably in blocking path via `send_message` response
9. Cost calculation should account for cached input tokens if available

## Affected Files
- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift`
- `libs/plugin-tools-sessions/internal/tools/message.go`
- `libs/plugin-bridge-claude/internal/tools/session.go`
- NEW: `apps/swift/Shared/Sources/Shared/Components/AgentOpsView.swift`
