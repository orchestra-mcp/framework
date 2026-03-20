---
estimate: M
id: FEAT-FHJ
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: MCP Resources Capability
type: feature
---

# MCP Resources Capability

Expose project features/notes/docs as MCP resources. Add resources/list, resources/read, resources/templates/list handlers. Resource URIs: orchestra://features/{id}, orchestra://notes/{id}, orchestra://docs/{path}. Route through existing StorageList/StorageRead. Add MCPResourcesCapability, MCPResource, MCPResourceTemplate, MCPResourceContent types.

Files: libs/sdk-go/protocol/mcp.go, libs/plugin-transport-stdio/internal/handler.go, libs/plugin-transport-stdio/internal/transport.go, libs/plugin-transport-stdio/internal/translator.go, libs/cli/internal/inprocess/webgate.go


---
**in-progress -> in-testing** (2026-03-20T18:26:22Z):
## Changes
- libs/sdk-go/protocol/mcp.go (added MCPResourcesCapability, MCPResource, MCPResourceTemplate, MCPResourceContent types, Resources field on MCPServerCapabilities)
- libs/plugin-transport-stdio/internal/handler.go (added handleResourcesList, handleResourcesRead, handleResourceTemplatesList handlers with resourcePrefixes config, updated initialize capabilities)
- libs/plugin-transport-stdio/internal/transport.go (added resources/list, resources/read, resources/templates/list dispatch cases)
- libs/cli/internal/inprocess/webgate.go (added handleResourcesList, handleResourcesRead, handleResourceTemplatesList with resourcePrefixesWG, updated initialize capabilities, added dispatch cases)


---
**in-testing -> in-docs** (2026-03-20T18:27:10Z):
## Results
- libs/plugin-transport-stdio/internal/transport_test.go (8 new tests: TestInitializeHasResourcesCapability, TestResourcesList, TestResourcesRead, TestResourcesReadMissingURI, TestResourcesReadBadScheme, TestResourcesReadUnknownType, TestResourceTemplatesList)
- All 43 tests pass: `go test ./... -v -count=1` → PASS ok github.com/orchestra-mcp/plugin-transport-stdio/internal 0.606s


---
**in-docs -> in-review** (2026-03-20T18:27:34Z):
## Docs
- docs/mcp-resources-capability.md (new — covers resource types, URI scheme, all 3 methods, storage routing)


---
**Review (approved)** (2026-03-20T18:27:49Z): Resources capability approved. 7 tests pass, docs complete.
