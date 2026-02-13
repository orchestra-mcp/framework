# OSV-6: Dynamic MCP Server

**Type**: Epic | **Status**: done | **Priority**: high

Extract MCP server from extensions/mcp/src/main/ into src/app/MCP/. Provides IMcpServerService with registerTool/registerResource/registerPrompt API. Tool namespacing, schema validation, stdio transport, CLI entry point (orchestr-mcp), dynamic runtime registration/unregistration, and migration of all existing MCP tools as registrations.

## Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| OSV-34 | IMcpServerService Interface & Tool Registry | done | high |
| OSV-35 | MCP stdio Transport & CLI Entry Point | done | high |
| OSV-36 | Migrate Existing MCP Tools & Documentation | done | high |
