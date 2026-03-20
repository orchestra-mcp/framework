# WebGate Streaming Fix: Chunks Before Response

## Problem

The `chat_stream` and `ai_prompt_stream` streaming tools send real-time chunks over the WebSocket connection, but they were never reaching the Flutter UI. The Smart Action Dialog showed nothing instead of streamed text.

## Root Cause

The `handleStreaming` function in `libs/cli/internal/inprocess/webgate.go` sends ALL chunks as `notifications/stream_chunk` messages BEFORE returning the final JSON-RPC response. This is by design — the writer goroutine drains the chunks channel, then the handler returns.

The Flutter `McpTcpClient.callToolStreaming()` method `await`s the final response. The `smart_action_dialog.dart` was doing:

```dart
// BUG: chunks already gone by the time this await completes
final result = await mcp.callToolStreaming('ai_prompt_stream', {...});

// Too late — chunks are gone from the broadcast stream
_chunkSubscription = mcp.notifications.listen(...);
```

Since `mcp.notifications` is a broadcast stream, events that arrive before the listener is registered are lost.

## Fix

### Flutter: Subscribe Before Call

`smart_action_dialog.dart` now subscribes to `mcp.notifications` BEFORE initiating the streaming call, buffers all `notifications/stream_chunk` messages, and applies them once the stream_id is known (from the final response).

Key changes:
- Subscribe to notifications first, buffer chunks with unknown `stream_id`
- Call `callToolStreaming` (still await — final response arrives after all chunks)
- Apply buffered chunks matching the resolved `stream_id`
- Handle raw text chunks with `_applyChunk()`: parses `ChatEvent` JSON, extracts `text_chunk` events

### Go: Add stream_id to Final Response

`webgate.go` `handleStreaming` now includes `stream_id` and `chunks_sent` in the final response:

```json
{
  "stream_id": "gate-st-42",
  "chunks_sent": 15,
  "content": [{"type": "text", "text": "[streamed 15 chunks]"}]
}
```

### Chunk Format

Chunks arrive as:
```json
{
  "jsonrpc": "2.0",
  "method": "notifications/stream_chunk",
  "params": {
    "stream_id": "gate-st-{request_id}",
    "sequence": 0,
    "data": "{\"type\":\"text_chunk\",\"text\":\"Hello\",\"session_id\":\"...\"}"
  }
}
```

The `data` field is a JSON-encoded `ChatEvent` struct — NOT base64. `_applyChunk()` parses this and extracts `text_chunk` events for display.

## What Changed

| File | Change |
|------|--------|
| `apps/flutter/lib/widgets/smart_action_dialog.dart` | Subscribe-before-call pattern, buffer+apply chunks, `_applyChunk()` helper |
| `libs/cli/internal/inprocess/webgate.go` | Add `stream_id` and `chunks_sent` to final streaming response |
| `libs/cli/internal/inprocess/webgate_test.go` | 3 new tests: chunks-before-response, fallthrough, stream_id format |

## Tests

Three new tests in `webgate_test.go`:

1. `TestWebGateStreamingChunksArriveBefore` — verifies all chunks arrive BEFORE final response, checks `notifications/stream_chunk` message format and `ChatEvent` JSON structure
2. `TestWebGateStreamingFallsThrough` — verifies `streaming: true` on a non-streaming tool falls through to regular handler
3. `TestWebGateStreamingStreamIDFormat` — verifies the `stream_id` format `gate-st-{requestID}` is consistent between chunks and final response
