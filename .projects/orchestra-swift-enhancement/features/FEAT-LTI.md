---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    Permissions are auto-accepted even in manual mode. The `spawn_session` and `ai_prompt` handlers in bridge-claude had `SetAutoApprove(true)` for `wait=true` mode. While this was removed in recent fixes, the blocking `send_message` path in tools-sessions may still not properly surface permission requests to the Swift UI.

    ## Current State
    - `libs/plugin-bridge-claude/internal/tools/session.go` — `SetAutoApprove(true)` was removed but permission flow may not work in blocking mode
    - `libs/plugin-bridge-claude/internal/process.go` — `handleControlRequest` puts requests on `PermissionCh`
    - Swift polls `get_pending_permission` but timing/race conditions may cause misses
    - `libs/plugin-bridge-claude/internal/tools/prompt.go` — permission events added to EventCh but only used in streaming path

    ## Requirements
    1. Verify `spawn_session(wait=true)` does NOT auto-approve any tools
    2. Permission requests must reliably appear in `get_pending_permission` polling
    3. Swift must show permission dialog with tool name, input, and reason
    4. User approve/deny must reach Claude CLI via `respond_permission` → `WritePermission()`
    5. Handle race condition: permission request arrives before Swift polls
    6. Add timeout handling — if user doesn't respond within configurable time, deny by default

    ## Affected Files
    - `libs/plugin-bridge-claude/internal/tools/session.go`
    - `libs/plugin-bridge-claude/internal/tools/prompt.go`
    - `libs/plugin-bridge-claude/internal/process.go`
    - `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift`
estimate: M
id: FEAT-LTI
kind: bug
labels:
    - plan:PLAN-YST
priority: P0
project_id: orchestra-swift-enhancement
status: backlog
title: Fix Permission System — Manual Mode Still Auto-Accepts
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# Fix Permission System — Manual Mode Still Auto-Accepts

## Problem
Permissions are auto-accepted even in manual mode. The `spawn_session` and `ai_prompt` handlers in bridge-claude had `SetAutoApprove(true)` for `wait=true` mode. While this was removed in recent fixes, the blocking `send_message` path in tools-sessions may still not properly surface permission requests to the Swift UI.

## Current State
- `libs/plugin-bridge-claude/internal/tools/session.go` — `SetAutoApprove(true)` was removed but permission flow may not work in blocking mode
- `libs/plugin-bridge-claude/internal/process.go` — `handleControlRequest` puts requests on `PermissionCh`
- Swift polls `get_pending_permission` but timing/race conditions may cause misses
- `libs/plugin-bridge-claude/internal/tools/prompt.go` — permission events added to EventCh but only used in streaming path

## Requirements
1. Verify `spawn_session(wait=true)` does NOT auto-approve any tools
2. Permission requests must reliably appear in `get_pending_permission` polling
3. Swift must show permission dialog with tool name, input, and reason
4. User approve/deny must reach Claude CLI via `respond_permission` → `WritePermission()`
5. Handle race condition: permission request arrives before Swift polls
6. Add timeout handling — if user doesn't respond within configurable time, deny by default

## Affected Files
- `libs/plugin-bridge-claude/internal/tools/session.go`
- `libs/plugin-bridge-claude/internal/tools/prompt.go`
- `libs/plugin-bridge-claude/internal/process.go`
- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift`
