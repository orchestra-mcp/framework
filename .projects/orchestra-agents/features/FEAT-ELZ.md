---
id: FEAT-ELZ
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: MCP Command Registry - Router plugin-to-tool mapping
type: feature
---

# MCP Command Registry - Router plugin-to-tool mapping

Augment Router to track toolName to pluginID mapping. Add ToolCatalogEntry struct with Name, Description, Schema, PluginID, Category (tool/ai/stream). Expose ListCatalog() and SearchCatalog(query) methods on Router. Plan: PLAN-ZRP


---
**in-progress -> in-testing** (2026-03-17T08:25:21Z):
## Changes

- libs/cli/internal/inprocess/router.go (added ToolCategory type, CatalogEntry struct, toolPluginMap/toolCategoryMap/toolProvidersMap fields, updated RegisterPlugin and RegisterExternal to populate catalog maps, added ListCatalog/SearchCatalog/GetCatalogEntry/ListPluginIDs/CatalogCount methods with buildCatalog/findToolDef helpers)


---
**in-testing -> in-docs** (2026-03-17T08:26:42Z):
## Results

- libs/cli/internal/inprocess/router_catalog_test.go (14 tests: TestListCatalog_AllTools, TestListCatalog_FilterByPlugin, TestListCatalog_Pagination, TestCatalogCount, TestSearchCatalog_ByName, TestSearchCatalog_ByDescription, TestSearchCatalog_ExactMatchFirst, TestSearchCatalog_CaseInsensitive, TestSearchCatalog_NoResults, TestGetCatalogEntry_Found, TestGetCatalogEntry_NotFound, TestListPluginIDs, TestCatalog_AITools, TestCatalog_ExternalPluginTools — all PASS)


---
**in-docs -> in-review** (2026-03-17T08:27:03Z):
## Docs

- docs/mcp-command-registry.md (new file: architecture, CatalogEntry schema, Router methods reference, MCP tools overview)


---
**Review (approved)** (2026-03-17T08:27:21Z): Router catalog mapping implemented with full test coverage
