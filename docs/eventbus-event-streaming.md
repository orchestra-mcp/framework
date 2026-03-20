# EventBus & Event Streaming

## Overview

The EventBus is an in-memory pub/sub system that enables real-time event delivery from the orchestrator to connected desktop clients (Flutter, Swift, Windows, Linux) and IDE clients (Claude Code, Cursor).

## Architecture

```
Tool call succeeds → Router.autoPublishToolEvent() → EventBus.Publish()
                                                        ├→ TCPServer pushes PluginResponse{EventDelivery} to desktop apps
                                                        └→ StdioTransport pushes JSON-RPC notification to IDE clients
```

## EventBus API

| Method | Description |
|--------|-------------|
| `Subscribe(topic)` | Subscribe to events on a specific topic. Returns (id, channel). |
| `SubscribeAll()` | Subscribe to events on ALL topics. Returns (id, channel). |
| `Unsubscribe(id)` | Remove subscription, close channel. |
| `Publish(topic, eventType, payload, sourcePlugin)` | Fan out event to matching subscribers. |
| `Close()` | Close all subscriptions. |

Channels are buffered (capacity 64). If a subscriber's channel is full, the event is dropped with a warning log.

## Auto-Published Events

The router automatically publishes events after successful mutating tool calls:

| Topic | Tools |
|-------|-------|
| `features` | create_feature, advance_feature, update_feature, submit_review, set_current_feature, reject_feature, delete_feature, unlock_feature |
| `projects` | create_project, update_project, delete_project |
| `plans` | create_plan, update_plan, approve_plan, complete_plan, breakdown_plan, delete_plan |
| `notes` | create_note, update_note, delete_note, pin_note, save_feature_note |
| `persons` | create_person, update_person, delete_person |
| `hooks` | receive_hook_event |

## Transport Push

### TCP (Desktop Apps)
Each TCP connection automatically subscribes to all events. EventDelivery messages are pushed as unsolicited `PluginResponse` Protobuf messages.

### Stdio (IDE Clients)
Events are pushed as JSON-RPC notifications (no `id` field):
```json
{"jsonrpc":"2.0","method":"notifications/event","params":{"topic":"features","event_type":"create_feature","source":"router","payload":{...}}}
```

## Hook → WebSocket Bridge (Go Backend)

The Go backend provides an HTTP bridge that receives MCP hook events and broadcasts them to connected Flutter clients via WebSocket.

### API

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| POST | `/api/hooks/events` | Yes | Receive and broadcast MCP event |
| GET | `/api/hooks/events` | Yes | List recent event logs (last 100) |

### Event Type Mapping

| Hook Event | WS Action | Entity Type |
|------------|-----------|-------------|
| `tool_use_start/end` | `tool_called` | `tool` |
| `notification` | `notification` | `notification` |
| `subagent_start/end` | `agent_spawned` | `agent` |

### Backend Files

- `apps/web/internal/handlers/hook_events.go` — HookEventHandler (Receive + List)
- `apps/web/internal/models/mcp_event_log.go` — MCPEventLog persistence model
- `apps/web/internal/hub/event.go` — Event struct with MCP fields (ToolName, SessionID, AgentType)

## Files

- `libs/cli/internal/inprocess/eventbus.go` — EventBus implementation
- `libs/cli/internal/inprocess/router.go` — EventBus wiring, auto-publish, toolTopicMap
- `libs/cli/internal/inprocess/tcpserver.go` — TCP event push per connection
- `libs/plugin-transport-stdio/internal/transport.go` — Stdio event push goroutine
- `libs/plugin-transport-stdio/export.go` — WithEventChannel option
- `libs/cli/internal/serve.go` — Wires EventBus to StdioTransport
