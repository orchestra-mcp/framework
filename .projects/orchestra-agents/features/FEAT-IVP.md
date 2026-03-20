---
estimate: M
id: FEAT-IVP
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: MCP Logging Capability
type: feature
---

# MCP Logging Capability

Add MCP logging support: logging/setLevel handler, notifications/message log notifications, MCPLoggingCapability type, MCPLogLevel constants (debug through emergency). Add logLevel field to StdioTransport with default warning. Mirror in webgate with per-connection log level.

Files: libs/sdk-go/protocol/mcp.go, libs/plugin-transport-stdio/internal/handler.go, libs/plugin-transport-stdio/internal/transport.go, libs/cli/internal/inprocess/webgate.go


---
**in-progress -> in-testing** (2026-03-20T18:20:37Z):
## Changes
- libs/sdk-go/protocol/mcp.go (added MCPLoggingCapability struct, MCPLogLevel type with 8 constants, LogLevelSeverity function, Logging field on MCPServerCapabilities)
- libs/plugin-transport-stdio/internal/handler.go (added handleLoggingSetLevel handler, updated handleInitialize to include Logging capability)
- libs/plugin-transport-stdio/internal/transport.go (added logLevel field with default warning, logging/setLevel dispatch case, SendLogNotification method)
- libs/cli/internal/inprocess/webgate.go (added logLevel to wsConn, handleLoggingSetLevel method, logging/setLevel dispatch, updated initialize capability)


---
**in-testing -> in-docs** (2026-03-20T18:21:54Z):
## Results
- libs/plugin-transport-stdio/internal/transport_test.go (8 new tests: TestInitializeHasLoggingCapability, TestLoggingSetLevelValid, TestLoggingSetLevelInvalid, TestLoggingSetLevelPersists, TestSendLogNotificationAboveThreshold, TestSendLogNotificationBelowThreshold, TestSendLogNotificationAtThreshold, TestLogLevelSeverity)
- All 35 tests pass: `go test ./... -v -count=1` → PASS ok github.com/orchestra-mcp/plugin-transport-stdio/internal 0.537s


---
**in-docs -> in-review** (2026-03-20T18:22:15Z):
## Docs
- docs/mcp-logging-capability.md (new — covers protocol, types, handlers, default behavior)


---
**Review (approved)** (2026-03-20T18:23:11Z): Logging capability approved. 8 tests pass, docs complete.
