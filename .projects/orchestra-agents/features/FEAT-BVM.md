---
estimate: M
id: FEAT-BVM
kind: feature
priority: P0
project_slug: orchestra-agents
status: todo
title: Tunnel action dispatch protocol (web to desktop smart actions)
type: feature
---

# Tunnel action dispatch protocol (web to desktop smart actions)

Define and implement the tunnel action protocol. Web backend sends action requests through the tunnel WebSocket to connected desktop MCP instances. Action types: run_tool (execute any MCP tool), run_bridge (execute Claude Code bridge command), file_read, file_write. Protocol: JSON-RPC over existing tunnel WebSocket. Desktop MCP receives action, executes, returns result. Add /api/tunnels/:id/action endpoint.