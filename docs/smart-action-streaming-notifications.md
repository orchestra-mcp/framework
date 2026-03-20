# Smart Action Streaming UX + Real Notifications

## Overview

Replaced the blocking AI generation in the Smart Action dialog with a real-time streaming UX, and wired WebSocket sync/presence broadcast events into the Flutter notification system.

## Part 1: Streaming AI Generation

### Before
The Smart Action dialog called `mcp.callTool('ai_prompt', {wait: true})` which blocked the UI with a spinner until the entire response was generated. Users had no feedback on progress.

### After
The dialog calls `mcp.callToolStreaming('ai_prompt_stream', {...})` which:
1. Returns an initial response with a `stream_id`
2. Streams text chunks via the MCP notification channel (`stream/chunk` events)
3. Renders chunks progressively in a scrollable output area
4. Shows a "Generating..." indicator with a small spinner while streaming
5. On completion (`stream/end`), shows "Use Result" and "Discard" buttons

### Key Files
- `apps/flutter/lib/widgets/smart_action_dialog.dart` — Streaming state management, progressive rendering, Use Result/Discard flow

### Streaming Protocol
The `McpTcpClient.callToolStreaming()` sends a JSON-RPC request with `streaming: true`. The server responds with `{stream_id: "..."}` and then sends notifications:
- `stream/chunk` — base64-encoded UTF-8 bytes in `params.data`
- `stream/end` — signals completion, triggers "Use Result" button

### Fallback
If the server doesn't return a `stream_id` (non-streaming backend), the dialog extracts text directly from the response using the existing `content[0].text` pattern.

## Part 2: Sync Broadcast Events

### New WebSocket Event Types
Two new event classes added to the sealed `WsEvent` union:

| Type | Class | Fields |
|------|-------|--------|
| `sync` | `SyncBroadcastEvent` | entityType, entityId, action, userId, timestamp |
| `presence` | `PresenceEvent` | userId, action (online/offline), timestamp |

These correspond to the Go backend's `broadcastSync()` helper (from FEAT-CPX) and `broadcastPresence()` in the WebSocket hub.

### Notification Wiring
- `NotificationListener._onWsEvent()` now handles `SyncBroadcastEvent` in addition to `McpEvent`
- Only `delete` actions trigger local notifications (to avoid notification spam from every upsert)
- Entity types mapped to human-readable labels: Feature, Note, Agent, Workflow, Skill, Doc, Plan, Project
- `NotificationStore.addSyncEvent()` persists sync notifications to SharedPreferences

### Notification IDs
| ID | Constant | Usage |
|----|----------|-------|
| 11000 | mcpToolCall | MCP tool call events |
| 11001 | mcpAgentSpawn | Agent spawn events |
| 11002 | mcpNotification | MCP notification events |
| 11003 | mcpGeneric | Generic MCP events |
| 11004 | mcpSync | Sync broadcast events (new) |

## Testing
- 28 widget tests: UniversalActionType enum, SmartActionType compat, extractText contract, streaming state machine, type metadata
- 55 unit tests: SyncBroadcastEvent, PresenceEvent, WsEvent routing (all 12 types), AppNotification serialization, McpEvent subtypes, all sync entity event types
