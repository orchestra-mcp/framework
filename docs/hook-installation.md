# Hook Installation on Orchestra Init

## Overview

When `orchestra init` runs in a project, it automatically installs two hook scripts into `.claude/hooks/`. These hooks integrate Claude Code with the Orchestra MCP server for real-time event streaming and permission management.

## Installed Hooks

### orchestra-mcp-hook.sh

Async hook that pipes Claude Code events to the MCP server via `receive_hook_event`. Events are logged to SQLite, published to the EventBus for desktop streaming, and trigger desktop notifications + TTS for attention-requiring events.

**Flow:** Claude Code hook fires → stdin JSON → jq transforms to JSON-RPC → pipes to `orchestra-mcp` binary → `receive_hook_event` tool processes it.

### orchestra-permission-hook.sh

Synchronous PreToolUse hook for bridge-spawned Claude sessions. When `ORCHESTRA_BRIDGE_SESSION=1` is set, it forwards permission requests to a local HTTP server controlled by the desktop app, allowing users to approve/deny tool calls from the UI.

**Guard:** If `ORCHESTRA_BRIDGE_SESSION` is not set (user's own CLI session), the hook exits immediately with code 0 (allow all).

## Implementation

Hook scripts are embedded as Go string constants in `libs/cli/internal/bundled.go` and written to disk by `InstallBundledContent()`. Files are created with mode `0755` (executable).

## Files

| File | Purpose |
|------|---------|
| `libs/cli/internal/bundled.go` | `InstallBundledContent()` + embedded hook constants |
| `libs/cli/internal/bundled_test.go` | 3 tests verifying hook creation, permissions, and content |
| `.claude/hooks/orchestra-mcp-hook.sh` | Installed async event hook |
| `.claude/hooks/orchestra-permission-hook.sh` | Installed sync permission hook |
