# Flutter Desktop MCP Event Listener

## Overview

The Flutter desktop app listens for MCP hook events via WebSocket and auto-refreshes relevant screens when data changes.

## Architecture

Claude Code hook script → POST /api/hooks/events → Go backend persists to mcp_event_logs and broadcasts via WebSocket (type: "mcp") → Flutter WsManager receives → McpEventHandler dispatches provider invalidations → UI auto-refreshes.

## Event Types

| WS Action | Dart Class | Description |
|-----------|------------|-------------|
| tool_called | McpToolCalledEvent | A Claude Code tool was executed |
| agent_spawned | McpAgentSpawnedEvent | A sub-agent was spawned |
| notification | McpNotificationEvent | Requires user attention |
| (other) | McpGenericEvent | Fallback for future action types |

## Files

- lib/core/ws/ws_event.dart — MCP event type definitions
- lib/features/hooks/mcp_event_handler.dart — Event handler and providers
- lib/screens/summary/summary_screen.dart — Wires mcpRealtimeProvider
