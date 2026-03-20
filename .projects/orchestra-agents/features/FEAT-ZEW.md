---
estimate: S
id: FEAT-ZEW
kind: feature
priority: P2
project_slug: orchestra-agents
status: done
title: MCP listChanged Tool Notifications
type: feature
---

# MCP listChanged Tool Notifications

Send notifications/tools/list_changed when tools are dynamically added/removed. Set ListChanged:true on MCPToolsCapability. Add OnToolsChanged callback to Router, invoke from RegisterPlugin/RegisterExternal. Add SendToolsListChanged to StdioTransport. Wire in serve.go.

Files: libs/cli/internal/inprocess/router.go, libs/plugin-transport-stdio/internal/handler.go, libs/plugin-transport-stdio/internal/transport.go, libs/cli/internal/inprocess/webgate.go, libs/cli/internal/serve.go


---
**in-progress -> in-testing** (2026-03-20T18:30:57Z):
## Changes
- libs/plugin-transport-stdio/internal/handler.go (set ListChanged:true on MCPToolsCapability)
- libs/plugin-transport-stdio/internal/transport.go (added SendToolsListChanged method)
- libs/plugin-transport-stdio/export.go (exposed SendToolsListChanged on public Transport type)
- libs/cli/internal/inprocess/router.go (added onToolsChanged callback list, OnToolsChanged method, notifyToolsChanged method, invoke from RegisterPlugin and RegisterExternal)
- libs/cli/internal/inprocess/webgate.go (set ListChanged:true, added BroadcastToolsListChanged method)
- libs/cli/internal/serve.go (wired router.OnToolsChanged to transport.SendToolsListChanged and webGate.BroadcastToolsListChanged)


---
**in-testing -> in-docs** (2026-03-20T18:31:30Z):
## Results
- libs/plugin-transport-stdio/internal/transport_test.go (2 new tests: TestInitializeHasListChangedCapability, TestSendToolsListChanged)
- All 45 tests pass: `go test ./... -count=1` → ok github.com/orchestra-mcp/plugin-transport-stdio/internal 0.260s


---
**in-docs -> in-review** (2026-03-20T18:31:47Z):
## Docs
- docs/mcp-listchanged-notifications.md (new — covers protocol, router callbacks, transport methods, wiring)


---
**Review (approved)** (2026-03-20T18:32:04Z): listChanged notifications approved. 2 tests pass, docs complete.
