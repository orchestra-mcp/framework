# OSV-34: IMcpServerService Interface & Tool Registry

**Type**: Story | **Status**: done | **Points**: 8

As a developer, I want a typed IMcpServerService so that extensions can dynamically register MCP tools, resources, and prompts with schema validation and namespacing.

## Acceptance Criteria

- [ ] IMcpServerService interface in src/app/MCP/IMcpServerService.ts
- [ ] McpServerService implements registerTool/registerResource/registerPrompt/unregisterTool/getRegisteredTools
- [ ] registerTool returns Disposable
- [ ] Tool namespacing: extension.toolName format enforced
- [ ] JSON Schema validation on tool inputs
- [ ] Dynamic runtime registration and unregistration
- [ ] Unit tests for registration, namespacing, and schema validation

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-101 | Define IMcpServerService interface and MCP types | backlog | task |
| OSV-102 | Implement McpServerService with tool registry and schema validation | backlog | task |
| OSV-103 | Write unit tests for McpServerService | backlog | task |
