# Session Handoff — 2026-03-20

## Pending Requests (implement in order)

### REQ-GGG: Smart action UX polish + refresh button + note redirect (P1)

1. **Smart action redirect**: In `apps/flutter/lib/screens/library/note_editor_screen.dart`, after AI creates note via MCP `create_note` tool, extract note ID from response (pattern: `note-XXXXXX`) and call `context.go('/library/notes/$noteId')` instead of populating the editor with thinking text.

2. **Claude Code CLI spinner**: Replace the current `_SmartEvent` status display with a single-line spinner using Braille characters (⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏) + tool name + elapsed time. Timer.periodic every 100ms rotates the spinner character. Format: `⠋ Reading file... (12s)`. Keep AnimatedSwitcher for tool transitions.

3. **Desktop refresh button**: In `apps/flutter/lib/screens/shell/desktop_shell.dart` header, add an IconButton with `Icons.refresh_rounded` that calls:
   ```dart
   ref.invalidate(workspaceScanProvider);
   ref.invalidate(workspaceBridgeReadyProvider);
   ref.invalidate(projectsProvider);
   ```

### REQ-RNY: Fix webgate streaming chunks (P1)

**Problem**: `libs/cli/internal/inprocess/webgate.go` `handleStreaming()` sends chunks via `conn.writeJSON()` but they arrive at the Flutter WebSocket as `{"jsonrpc":"2.0","result":{"method":"notifications/events","params":[...]}}` — NOT as the direct chunk format.

**Current state**: The Go-side change to use `method: "notifications/stream_chunk"` format is saved in webgate.go but the CLI can't rebuild because `github.com/orchestra-mcp/plugin-tools-hooks` repo doesn't exist yet. Either create the repo or remove the import from `libs/cli/internal/serve.go:50`.

**Events ARE arriving** via the existing notification pathway (confirmed in logs). The Flutter side at `_onMessage` now forwards all no-id messages to the notification stream. The smart action listener parses `result.method == 'notifications/events'` and shows tool_start/tool_end events.

### REQ-EDM: Smart Action streaming UX + real notifications (P0)

**Streaming**: The bridge events DO arrive at the Flutter WebSocket — confirmed by `[MCP-WS] No-ID message:` logs showing `tool_start`, `tool_end`, `text_chunk` events. The listener in note_editor_screen.dart already handles them. Main issue: the `ai_prompt wait:true` response contains Claude's "thinking" text, not the actual note content (which was saved via `create_note` MCP tool).

**Notifications**: `apps/flutter/lib/core/notifications/notification_store.dart` is created with real store backed by SharedPreferences. The notifications screen (`notifications_screen.dart`) is updated to use it. MCP event listener wired in. Need to add more event sources (health alerts from health managers, sync events).

## Key File Locations

| Component | File |
|-----------|------|
| Smart action | `apps/flutter/lib/screens/library/note_editor_screen.dart` (~1000 lines) |
| MCP TCP client | `apps/flutter/lib/core/api/mcp_tcp_client.dart` (message handler at `_onMessage`) |
| Notification store | `apps/flutter/lib/core/notifications/notification_store.dart` |
| Notifications screen | `apps/flutter/lib/screens/notifications/notifications_screen.dart` |
| Workspace bridge | `apps/flutter/lib/core/workspace/workspace_bridge.dart` |
| Bridge provider | `apps/flutter/lib/core/workspace/workspace_bridge_provider.dart` |
| Desktop shell | `apps/flutter/lib/screens/shell/desktop_shell.dart` (~2000 lines) |
| Webgate (Go) | `libs/cli/internal/inprocess/webgate.go` (handleStreaming at line 679) |
| Project detail | `apps/flutter/lib/screens/projects/project_detail_screen.dart` |

## Architecture Notes

- Flutter desktop connects to `ws://localhost:9201` (webgate)
- Events from Claude bridge arrive as: `{"jsonrpc":"2.0","result":{"method":"notifications/events","params":[{"type":"tool_start","tool_name":"Read",...}]}}`
- `_onMessage` forwards all no-id messages with `result` to `_notificationController`
- `callToolStreaming()` sends `streaming: true` at params level for webgate streaming handler
- `callTool` default timeout is 10 minutes (changed from 30s)
