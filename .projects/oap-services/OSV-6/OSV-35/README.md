# OSV-35: MCP stdio Transport & CLI Entry Point

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want an MCP stdio transport and CLI entry point so that AI agents can connect to Orchestra's MCP server via the standard protocol.

## Acceptance Criteria

- [ ] stdio transport reads JSON-RPC from stdin, writes to stdout
- [ ] CLI entry point bin: orchestr-mcp in package.json
- [ ] Handles tools/list, tools/call, resources/list, resources/read, prompts/list, prompts/get
- [ ] Graceful shutdown on SIGTERM/SIGINT
- [ ] Error responses follow MCP protocol spec
- [ ] Integration test with mock stdin/stdout

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OSV-104 | Implement MCP stdio transport with JSON-RPC protocol | backlog | task |
| OSV-105 | Create CLI entry point bin script for orchestr-mcp | backlog | task |
| OSV-106 | Write integration tests for stdio transport and CLI | backlog | task |
