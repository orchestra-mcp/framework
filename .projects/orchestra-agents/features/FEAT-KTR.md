---
id: FEAT-KTR
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: MCP Command Registry - list search get MCP tools
type: feature
---

# MCP Command Registry - list search get MCP tools

Add 3 MCP tools to tools-features plugin: list_mcp_tools (paginated, filterable by plugin), search_mcp_tools (fuzzy search by name/description), get_mcp_tool (full schema for one tool). Depends on Router catalog methods. Plan: PLAN-ZRP


---
**in-progress -> in-testing** (2026-03-17T08:32:01Z):
## Changes

- libs/sdk-go/plugin/catalog.go (new file: CatalogEntry struct, ToolCatalog interface)
- libs/plugin-tools-features/internal/tools/catalog.go (new file: ListMCPTools, SearchMCPTools, GetMCPTool handlers with schemas)
- libs/plugin-tools-features/internal/features.go (added Catalog field to FeaturesPlugin, registered 3 catalog tools)
- libs/plugin-tools-features/export.go (refactored to use RegisterOption pattern, added WithCatalog option)
- libs/cli/internal/serve.go (pass router as catalog via WithCatalog)


---
**in-testing -> in-docs** (2026-03-17T08:33:25Z):
## Results

- libs/plugin-tools-features/internal/tools/catalog_test.go (9 tests: TestListMCPTools_AllTools, TestListMCPTools_FilterByPlugin, TestListMCPTools_Pagination, TestSearchMCPTools_Found, TestSearchMCPTools_NoResults, TestSearchMCPTools_MissingQuery, TestGetMCPTool_Found, TestGetMCPTool_NotFound, TestGetMCPTool_MissingToolName — all PASS)


---
**in-docs -> in-review** (2026-03-17T08:33:58Z):
## Docs

- docs/mcp-command-registry.md (updated: added MCP tool parameter tables for list_mcp_tools, search_mcp_tools, get_mcp_tool; added ToolCatalog interface reference)


---
**Review (approved)** (2026-03-17T08:34:17Z): MCP command registry tools implemented with full test coverage
