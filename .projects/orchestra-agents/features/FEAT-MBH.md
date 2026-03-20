---
estimate: M
id: FEAT-MBH
kind: feature
priority: P1
project_slug: orchestra-agents
status: todo
title: Claude Code bridge response handler (desktop executes, returns to web)
type: feature
---

# Claude Code bridge response handler (desktop executes, returns to web)

Desktop-side handler for tunnel action dispatch. When MCP receives a bridge action via tunnel: spawn Claude Code session (via bridge-claude plugin), stream progress updates back through tunnel WebSocket, return final result (created files, action output) to web. Web stores action result in action_log table. Support for long-running actions with progress callbacks.