#!/bin/bash
# Orchestra permission hook — PreToolUse (synchronous/blocking)
# Claude Code reads stdin with tool info and waits for this script to exit.
# Exit 0  → allow the tool call to proceed
# Exit 2 + print JSON {"decision":"deny","reason":"..."} → block the tool call
#
# We forward the permission request to the bridge-claude permission server
# (running at a well-known port while a session is active) and wait for the
# user's decision from the Swift desktop UI.

## ── Guard: only intercept bridge-spawned Claude sessions ──────────────────
# bridge-claude sets ORCHESTRA_BRIDGE_SESSION=1 when spawning `claude -p`.
# If this env var is NOT set, this is the user's own Claude Code session →
# allow everything immediately so it never blocks the user's CLI.
if [ -z "$ORCHESTRA_BRIDGE_SESSION" ]; then
    exit 0
fi

INPUT=$(cat)

# Extract tool name early so we can auto-approve safe tools.
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')

# ── Auto-approve safe (read-only / non-destructive) tools ──────────────────
# These tools cannot modify files or execute commands, so they don't need
# user approval. Only dangerous tools (Bash, Write, Edit, etc.) go through
# the permission server for explicit user approval.
case "$TOOL_NAME" in
    Read|Glob|Grep|WebFetch|WebSearch|AskUserQuestion|TodoWrite|EnterPlanMode|ExitPlanMode)
        exit 0
        ;;
esac

# Permission server port file — bridge-claude writes the port here when active
PORT_FILE="${HOME}/.orchestra/permission-server.port"

# If no permission server is running, allow by default (non-interactive context)
if [ ! -f "$PORT_FILE" ]; then
    exit 0
fi

PORT=$(cat "$PORT_FILE" 2>/dev/null)
if [ -z "$PORT" ]; then
    exit 0
fi

# Build the payload to send to the permission server
PAYLOAD=$(echo "$INPUT" | jq -c '{
    tool_name: (.tool_name // "unknown"),
    tool_input: (.tool_input // {}),
    session_id: (.session_id // ""),
    cwd: (.cwd // "")
}')

# POST to the bridge-claude permission server.
# This call blocks until the user responds (or times out after 5 minutes).
# The server returns {"decision": "approve"} or {"decision": "deny", "reason": "..."}
RESPONSE=$(curl -s -X POST \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD" \
    --max-time 300 \
    "http://127.0.0.1:${PORT}/permission" 2>/dev/null)

if [ $? -ne 0 ] || [ -z "$RESPONSE" ]; then
    # curl failed or timed out — allow by default to avoid blocking Claude forever
    exit 0
fi

DECISION=$(echo "$RESPONSE" | jq -r '.decision // "approve"')

if [ "$DECISION" = "deny" ]; then
    REASON=$(echo "$RESPONSE" | jq -r '.reason // "Permission denied by user"')
    echo "{\"decision\":\"deny\",\"reason\":\"${REASON}\"}"
    exit 2
fi

# approve or any other value → allow
exit 0
