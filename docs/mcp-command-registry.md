# MCP Command Registry

The MCP Command Registry provides a searchable catalog of all registered MCP tools across all plugins (in-process, AI bridges, and external QUIC plugins).

## Architecture

The Router (`libs/cli/internal/inprocess/router.go`) tracks tool-to-plugin membership via three internal maps:

- `toolPluginMap` — maps `toolName → pluginID`
- `toolCategoryMap` — maps `toolName → ToolCategory` (tool, ai, stream, external)
- `toolProvidersMap` — maps `toolName → []provider` (for AI bridge tools)

These maps are populated automatically during `RegisterPlugin()` and `RegisterExternal()` calls at startup.

## CatalogEntry

Each tool is represented as a `CatalogEntry`:

| Field | Type | Description |
|-------|------|-------------|
| Name | string | Tool name (e.g. `create_feature`) |
| Description | string | Human-readable description |
| PluginID | string | Source plugin (e.g. `tools.features`) |
| Category | ToolCategory | `tool`, `ai`, `stream`, or `external` |
| Providers | []string | AI providers (empty for generic tools) |
| Schema | string | JSON Schema (only in detail view) |

## Router Methods

### ListCatalog(pluginFilter, offset, limit)

Returns paginated catalog entries sorted alphabetically by name. Pass empty `pluginFilter` for all tools.

### CatalogCount(pluginFilter)

Returns total count of catalog entries (for pagination).

### SearchCatalog(query)

Searches tool names and descriptions. Results are ranked: exact name match first, then name-contains, then description-contains. Case-insensitive.

### GetCatalogEntry(toolName)

Returns a single tool's full details including JSON Schema.

### ListPluginIDs()

Returns sorted list of unique plugin IDs that have registered tools.

## MCP Tools

Three MCP tools expose the catalog to AI agents:

### list_mcp_tools

Paginated listing of all tools. Parameters:

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| plugin | string | (all) | Filter by plugin ID |
| offset | number | 0 | Skip first N results |
| limit | number | 50 | Max results (max 200) |

### search_mcp_tools

Search by name or description. Parameters:

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| query | string | yes | Search query |
| limit | number | 20 | Max results |

### get_mcp_tool

Full detail view with JSON Schema. Parameters:

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| tool_name | string | yes | Exact tool name |

## ToolCatalog Interface

Defined in `libs/sdk-go/plugin/catalog.go`. Any plugin that needs catalog access can depend on this interface:

```go
type ToolCatalog interface {
    ListCatalog(pluginFilter string, offset, limit int) []CatalogEntry
    CatalogCount(pluginFilter string) int
    SearchCatalog(query string) []CatalogEntry
    GetCatalogEntry(toolName string) *CatalogEntry
    ListPluginIDs() []string
}
```

The in-process Router implements this interface automatically.
