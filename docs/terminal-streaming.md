# Terminal Streaming Architecture

## Overview

The `devtools-terminal` plugin provides real-time PTY output streaming via a subscriber fan-out mechanism on top of the existing poll-based `get_output` tool.

## Streaming Tool: `terminal_stream`

A `StreamingToolHandler` that subscribes to a terminal session's PTY output and pushes each chunk through the WebGate streaming channel.

**Parameters:**
- `terminal_id` (string, required): ID of the terminal session to stream from

**Protocol:** When called via WebGate with `streaming: true`, the client receives JSON-RPC notifications with `stream_id`, `sequence`, and `data` fields containing raw PTY output bytes.

## Subscriber Fan-Out

The PTY manager's `Session` struct supports multiple concurrent subscribers via `Subscribe(id) -> (<-chan []byte, unsub func(), error)`.

- Each subscriber gets a buffered channel (capacity 64)
- Non-blocking send: slow subscribers have frames dropped (prevents blocking the PTY reader)
- Channels are automatically closed when the terminal session closes or the PTY process exits
- The `unsub` function is safe to call multiple times
- Backward compatible: the existing poll-based `get_output` tool continues to work alongside streaming subscribers

## Usage from Flutter

```
ws.send(JSON.stringify({
  jsonrpc: "2.0", id: 1,
  method: "tools/call",
  params: { name: "terminal_stream", arguments: { terminal_id: "term-a1b2c3" }, streaming: true }
}))
// Receives: { result: { stream_id: "gate-st-1", sequence: 0, data: "$ " } }
// Receives: { result: { stream_id: "gate-st-1", sequence: 1, data: "echo hello\r\nhello\r\n$ " } }
```
