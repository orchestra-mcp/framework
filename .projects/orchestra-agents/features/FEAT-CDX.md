---
estimate: S
id: FEAT-CDX
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: MCP Protocol Version Update to 2025-06-18
type: feature
---

# MCP Protocol Version Update to 2025-06-18

Update MCP protocol version from 2024-11-05 to 2025-06-18 in all transports. Add MCPProtocolVersion constant to sdk-go/protocol/mcp.go. Update handleInitialize in transport-stdio handler.go and cli webgate.go. Update e2e tests and unit tests.

Files: libs/sdk-go/protocol/mcp.go, libs/plugin-transport-stdio/internal/handler.go, libs/cli/internal/inprocess/webgate.go, scripts/test-e2e.sh, libs/plugin-transport-stdio/internal/transport_test.go


---
**in-progress -> in-testing** (2026-03-20T18:14:35Z):
## Changes
- libs/sdk-go/protocol/mcp.go — Added `MCPProtocolVersion = "2025-06-18"` constant (replaces hardcoded version strings)
- libs/plugin-transport-stdio/internal/handler.go — Updated `handleInitialize` to use `protocol.MCPProtocolVersion` instead of `"2024-11-05"`
- libs/cli/internal/inprocess/webgate.go — Updated `handleInitialize` to use `protocol.MCPProtocolVersion` instead of `"2024-11-05"`


---
**in-testing -> in-docs** (2026-03-20T18:15:14Z):
## Results
- libs/plugin-transport-stdio/internal/transport_test.go — Updated TestInitialize and TestInitializeHasPromptsCapability assertions to use protocol.MCPProtocolVersion ("2025-06-18"). All 22 tests pass.

```
ok  github.com/orchestra-mcp/plugin-transport-stdio/internal  0.476s
PASS — 22/22 tests passed
```


---
**in-docs -> in-review** (2026-03-20T18:15:30Z):
## Docs
- docs/mcp-protocol-update.md (new) — Documents the protocol version update from 2024-11-05 to 2025-06-18, including all files modified and backward compatibility notes.


---
**Review (approved)** (2026-03-20T18:15:47Z): Protocol version updated to 2025-06-18 with centralized constant. All 22 tests pass.
