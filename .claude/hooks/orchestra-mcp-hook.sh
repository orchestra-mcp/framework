#!/bin/bash
# Orchestra MCP hook — pipes Claude Code events to MCP server
# Called by Claude Code for all configured hook events (async, never blocks)
set -e

INPUT=$(cat)

# Build the MCP messages: initialize handshake + tool call
INIT='{"jsonrpc":"2.0","id":0,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"orchestra-hook","version":"1.0.0"}}}'
INITIALIZED='{"jsonrpc":"2.0","method":"notifications/initialized","params":{}}'

TOOL_CALL=$(echo "$INPUT" | jq -c '{
  jsonrpc: "2.0", id: 1, method: "tools/call",
  params: {
    name: "receive_hook_event",
    arguments: {
      event_type: (.hook_event_name // "unknown"),
      session_id: (.session_id // ""),
      tool_name: (.tool_name // ""),
      agent_type: (.agent_type // ""),
      data: .
    }
  }
}')

# Send all three messages (init handshake + tool call) to orchestra via stdio
printf '%s\n%s\n%s\n' "$INIT" "$INITIALIZED" "$TOOL_CALL" \
  | orchestra --workspace "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null \
  | head -2 > /dev/null

exit 0
