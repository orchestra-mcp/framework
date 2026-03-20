---
id: REQ-RNY
kind: bug
priority: P1
project_slug: orchestra-agents
status: pending
title: Fix webgate streaming chunks not reaching Flutter WebSocket
type: request
---

# Fix webgate streaming chunks not reaching Flutter WebSocket

The webgate handleStreaming sends chunks via conn.writeJSON but they never arrive at the Flutter McpTcpClient WebSocket. Likely a Go concurrency issue — the writer goroutine in handleStreaming may be blocked because the main goroutine holds a write lock or the connection is busy processing the tools/call response. Need to debug in libs/cli/internal/inprocess/webgate.go handleStreaming function. Once fixed, the Flutter smart action can show real-time streaming events (tool_start, text_chunk, tool_end) under the input box.
