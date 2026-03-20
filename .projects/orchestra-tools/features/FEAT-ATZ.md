---
id: FEAT-ATZ
kind: feature
priority: P0
project_slug: orchestra-tools
status: done
title: Fix bridge-claude + quic-bridge streaming
type: feature
---

# Fix bridge-claude + quic-bridge streaming

bridge-claude/process.go: yield StreamChunk per JSONL line instead of buffering. quic-bridge/bridge.go: keep QUIC stream open for streaming, forward StreamChunk as JSON-RPC notifications. Depends on INFRA-STREAM.


---
**backlog -> done**: Implementation complete.

**bridge-claude**: Added `SpawnStream()` to process.go — reads stream-json JSONL line by line, calls `extractChunkText()` to yield text chunks via callback before accumulating into the final response. Added `AIPromptStream` streaming tool handler in tools/prompt.go. Registered as `ai_prompt_stream` via `RegisterStreamingTool` in plugin.go. Added `spawnStreamAdapter` on BridgePlugin. 5 tests in process_test.go all pass.

**quic-bridge**: Added `StreamSender` interface (optional extension of Sender). Added `isStreamingRequest()` to detect `"streaming":true` in params. Added `handleToolsCallStreaming()` — uses `io.Writer` so it's testable, calls `SendStream`, forwards each `StreamChunk` as `notifications/stream` JSON-RPC notification, sends final response after `StreamEnd`. Falls back to regular `handleToolsCall` when sender doesn't implement `StreamSender`. 7 new tests in bridge_test.go. All 34 quic-bridge tests pass.