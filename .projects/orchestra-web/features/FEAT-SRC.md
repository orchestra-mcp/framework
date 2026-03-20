---
estimate: XL
id: FEAT-SRC
kind: feature
priority: P3
project_slug: orchestra-web
status: todo
title: Chrome extension for browser awareness and control
type: feature
---

# Chrome extension for browser awareness and control

Create a Chrome extension in apps/chrome/ that connects to the MCP via the Go backend. The extension captures browser state (URL, DOM, console), takes screenshots, and allows the AI to control the browser (navigate, click, type). Connected via a Go backend handler that bridges MCP tools to the extension via WebSocket.