# MCP Logging Capability

## Overview

Orchestra MCP now supports the MCP logging capability, allowing connected IDE clients (Claude Code Desktop, Cursor, etc.) to receive structured log notifications from the server.

## Protocol

The logging capability is advertised in the `initialize` response:

```json
{
  "capabilities": {
    "tools": {},
    "prompts": {},
    "logging": {}
  }
}
```

### logging/setLevel

Clients can set the minimum log level threshold. Only messages at or above this level are sent.

**Request:**
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "logging/setLevel",
  "params": { "level": "info" }
}
```

**Response:**
```json
{ "jsonrpc": "2.0", "id": 1, "result": {} }
```

**Valid levels** (RFC 5424 severity order):
| Level | Severity |
|-------|----------|
| debug | 0 |
| info | 1 |
| notice | 2 |
| warning | 3 (default) |
| error | 4 |
| critical | 5 |
| alert | 6 |
| emergency | 7 |

Invalid levels return an `InvalidParams` error.

### notifications/message

Server-to-client log notifications. Sent as JSON-RPC notifications (no `id`, no response expected).

```json
{
  "jsonrpc": "2.0",
  "method": "notifications/message",
  "params": {
    "level": "error",
    "logger": "tools.features",
    "data": "tool call failed: validation error"
  }
}
```

## Implementation

### Types (libs/sdk-go/protocol/mcp.go)

- `MCPLoggingCapability` — empty struct, signals logging support
- `MCPLogLevel` — string type with 8 constants (debug through emergency)
- `LogLevelSeverity(level)` — returns numeric severity (0-7), -1 for unknown

### Stdio Transport (libs/plugin-transport-stdio/)

- `StdioTransport.logLevel` — per-connection threshold, defaults to `warning`
- `handleLoggingSetLevel()` — validates level, stores on transport
- `SendLogNotification(level, logger, data)` — sends notification if level >= threshold

### WebGate (libs/cli/internal/inprocess/webgate.go)

- `wsConn.logLevel` — per-WebSocket-connection threshold, defaults to `warning`
- `handleLoggingSetLevel()` — validates level, stores on connection

## Default Behavior

The default log level is `warning`. Clients that never call `logging/setLevel` will only receive warnings and above. Clients can lower the threshold to `debug` to see all messages.
