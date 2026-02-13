# OSV-7: Fast WebSocket Server

**Type**: Epic | **Status**: done | **Priority**: high

Extract WebSocket bridge from packages/desktop/src/main/services/websocketBridgeService.ts into src/app/Socket/. Provides IWebSocketService with registerHandler/publish/subscribe API. Channel-based pub/sub, token-based auth, binary message support, reconnection with exponential backoff, offline message queue, and extension handler registration.

## Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| OSV-37 | IWebSocketService Interface & Core Server | done | high |
| OSV-38 | WebSocket Reconnection, Message Queue & Documentation | done | high |
