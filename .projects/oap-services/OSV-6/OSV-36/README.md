# OSV-36: Migrate Existing MCP Tools & Documentation

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want all existing MCP tools migrated to use registerTool and documentation written so that the migration is complete and the API is well-understood.

## Acceptance Criteria

- [ ] All existing tools from extensions/mcp/src/main/tools/ migrated as registerTool calls
- [ ] Project, epic, story, task, PRD, workflow tools all registered dynamically
- [ ] Notification tool registered dynamically
- [ ] No hardcoded tool definitions remain in MCP server
- [ ] docs/core-services/mcp-server.md with API reference, tool authoring guide

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-107 | Migrate existing MCP tools to dynamic registerTool calls | backlog | task |
| OSV-108 | Write MCP Server documentation and barrel exports | backlog | task |
