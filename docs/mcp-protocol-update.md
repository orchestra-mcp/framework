# MCP Protocol Version Update

## Overview

Updated Orchestra MCP from protocol version `2024-11-05` to `2025-06-18` (the latest stable MCP specification).

## Changes

- Added `MCPProtocolVersion` constant in `libs/sdk-go/protocol/mcp.go` to centralize the version string
- Updated `handleInitialize` in both stdio transport and WebGate to use the constant
- All transports now advertise `protocolVersion: "2025-06-18"` in initialize responses

## Impact

- Claude Code Desktop App, Claude Code CLI, and all MCP-compatible IDEs receive the updated protocol version
- Backward compatible: older clients that send `2024-11-05` in their initialize request still work (server advertises its version, client adapts)
- Enables support for resources, logging, and structured tool output capabilities added in the 2025-06-18 spec

## Files Modified

| File | Change |
|------|--------|
| `libs/sdk-go/protocol/mcp.go` | Added `MCPProtocolVersion = "2025-06-18"` constant |
| `libs/plugin-transport-stdio/internal/handler.go` | Use constant in `handleInitialize` |
| `libs/cli/internal/inprocess/webgate.go` | Use constant in `handleInitialize` |
| `libs/plugin-transport-stdio/internal/transport_test.go` | Updated test assertions |
