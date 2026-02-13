# OSV-38: WebSocket Reconnection, Message Queue & Documentation

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want offline message queuing and reconnection support so that messages are not lost during temporary disconnections, plus documentation for the full API.

## Acceptance Criteria

- [ ] Client-side reconnection with exponential backoff (1s, 2s, 4s, 8s, max 30s)
- [ ] Offline message queue: messages buffered when no clients connected, flushed on reconnect
- [ ] Queue max size configurable (default 1000 messages)
- [ ] Connection/disconnection events include client metadata
- [ ] docs/core-services/websocket-server.md with API reference and examples
- [ ] Integration test verifying reconnection and queue flush

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-112 | Implement offline message queue and reconnection support | backlog | task |
| OSV-113 | Write WebSocket documentation, barrel exports, and queue tests | backlog | task |
