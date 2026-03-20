---
estimate: M
id: FEAT-GNQ
kind: bug
priority: P0
project_slug: orchestra-web
status: todo
title: Fix session breaking on tool/command usage
type: feature
---

# Fix session breaking on tool/command usage

When the AI uses MCP tools during a session, the connection breaks (Error: disconnected). Investigate if this is a timeout issue, session lock issue, or bridge-claude process dying. Fix the root cause so multi-tool responses work reliably.