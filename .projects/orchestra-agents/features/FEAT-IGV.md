---
estimate: S
id: FEAT-IGV
kind: feature
priority: P2
project_slug: orchestra-agents
status: todo
title: Connected tunnels dashboard with live status indicators
type: feature
---

# Connected tunnels dashboard with live status indicators

Enhance the Active Tunnels dashboard widget and /tunnels page with live status. Show: connected machine name, OS, last heartbeat, active MCP tools count, current user, running actions. Green pulse for connected, yellow for syncing, red for error. Click tunnel to see detailed status panel with action history. Uses WebSocket for real-time status updates.