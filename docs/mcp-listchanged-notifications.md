# MCP listChanged Tool Notifications

## Overview

Orchestra MCP advertises `listChanged: true` in its tools capability and sends `notifications/tools/list_changed` when the tool list changes dynamically (e.g., when an external plugin connects or disconnects).

## Protocol

The `initialize` response now includes:

```json
{
  "capabilities": {
    "tools": { "listChanged": true }
  }
}
```

When tools are added or removed, the server sends:

```json
{
  "jsonrpc": "2.0",
  "method": "notifications/tools/list_changed"
}
```

Clients should re-fetch `tools/list` after receiving this notification.

## Implementation

### Router Callbacks (libs/cli/internal/inprocess/router.go)

- `OnToolsChanged(fn func())` — registers a callback invoked when tools change
- `notifyToolsChanged()` — invokes all callbacks (called at end of `RegisterPlugin` and `RegisterExternal`, after releasing the lock)

### Stdio Transport (libs/plugin-transport-stdio/)

- `SendToolsListChanged()` — writes the notification to stdout
- Exposed publicly via `Transport.SendToolsListChanged()` in export.go

### WebGate (libs/cli/internal/inprocess/webgate.go)

- `BroadcastToolsListChanged()` — sends the notification to all connected WebSocket clients

### Wiring (libs/cli/internal/serve.go)

Both stdio and WebGate transports are wired to the router callback:

```go
router.OnToolsChanged(func() { transport.SendToolsListChanged() })
router.OnToolsChanged(func() { webGate.BroadcastToolsListChanged() })
```

## When Notifications Fire

- `RegisterPlugin()` — when a new in-process plugin is registered
- `RegisterExternal()` — when an external QUIC plugin connects
