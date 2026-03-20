# Hooks Plugin (tools.hooks)

## Overview

The hooks plugin receives Claude Code hook events, logs them to SQLite, publishes them to the EventBus for real-time desktop streaming, and dispatches desktop notifications + TTS for attention-requiring events.

## Tools

### receive_hook_event

Receives and processes a Claude Code hook event.

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| event_type | string | Yes | Hook event type (e.g., Notification, post_tool_use, user_prompt_submit) |
| session_id | string | No | Claude Code session ID |
| tool_name | string | No | Tool name for tool-related events |
| agent_type | string | No | Agent type for agent-related events |
| data | object | No | Additional event payload |

**Behavior:**
1. Validates `event_type` is present
2. Logs the event to SQLite (`hook_events` table via globaldb)
3. Publishes to EventBus (topic: `hooks`) for real-time streaming to desktop clients
4. For `Notification` events: calls `notify_send` (desktop notification) and `tts_speak` (text-to-speech)
   - Sound: `agent-permission` for permission prompts, `agent-question` for idle prompts
5. Prunes events to keep last 10,000 in background

**Returns:** `{stored: true, event_type: "..."}`

### get_hook_events

Queries logged hook events from the database.

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| event_type | string | No | Filter by event type |
| session_id | string | No | Filter by session ID |
| limit | number | No | Max events to return (default: 100) |

**Returns:** `{events: [...], count: N}`

## Database Schema

The `hook_events` table is created in globaldb (`~/.orchestra/db/global.db`):

```sql
CREATE TABLE IF NOT EXISTS hook_events (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  event_type  TEXT NOT NULL,
  session_id  TEXT,
  tool_name   TEXT,
  agent_type  TEXT,
  payload     TEXT,  -- JSON blob
  created_at  TEXT NOT NULL DEFAULT (datetime('now'))
);
```

Indexed on `event_type`, `session_id`, and `created_at`.

## Cross-Plugin Integration

The hooks plugin calls two service plugins via the router:

- **services.notifications** (`notify_send`) — OS desktop notification with title, body, and sound
- **services.voice** (`tts_speak`) — Text-to-speech to speak the notification message

These are registered in serve.go alongside the hooks plugin.

## Hook File

The `.claude/hooks/orchestra-mcp-hook.sh` script pipes Claude Code events to this tool via JSON-RPC. It extracts `hook_event_name`, `session_id`, `tool_name`, and `agent_type` from the Claude Code hook payload.

## Future: Backend Sync

The `hook_events` table is designed for future sync to the backend API, enabling team owners to see member activity (which tools agents use, session patterns, etc.).
