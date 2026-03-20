# MCP Resources Capability

## Overview

Orchestra MCP exposes project data (features, notes, docs) as MCP resources, allowing IDE clients to browse project state directly without tool calls.

## Protocol

The resources capability is advertised in the `initialize` response:

```json
{
  "capabilities": {
    "resources": {}
  }
}
```

## Resource Types

| Type | URI Pattern | Storage Prefix | MIME Type |
|------|-------------|----------------|-----------|
| Features | `orchestra://features/{id}` | `features/` | text/markdown |
| Notes | `orchestra://notes/{id}` | `notes/` | text/markdown |
| Docs | `orchestra://docs/{id}` | `docs/` | text/markdown |

## Methods

### resources/list

Lists all available resources by querying storage for each prefix.

**Request:**
```json
{ "jsonrpc": "2.0", "id": 1, "method": "resources/list" }
```

**Response:**
```json
{
  "jsonrpc": "2.0", "id": 1,
  "result": {
    "resources": [
      {
        "uri": "orchestra://features/FEAT-001",
        "name": "FEAT-001",
        "mimeType": "text/markdown"
      }
    ]
  }
}
```

### resources/read

Reads a single resource by its `orchestra://` URI.

**Request:**
```json
{
  "jsonrpc": "2.0", "id": 2,
  "method": "resources/read",
  "params": { "uri": "orchestra://features/FEAT-001" }
}
```

**Response:**
```json
{
  "jsonrpc": "2.0", "id": 2,
  "result": {
    "contents": [
      {
        "uri": "orchestra://features/FEAT-001",
        "mimeType": "text/markdown",
        "text": "# Feature FEAT-001\n\n..."
      }
    ]
  }
}
```

### resources/templates/list

Returns URI templates for resource discovery.

**Response:**
```json
{
  "jsonrpc": "2.0", "id": 3,
  "result": {
    "resourceTemplates": [
      {
        "uriTemplate": "orchestra://features/{id}",
        "name": "Project Features",
        "description": "Access Project Features by ID",
        "mimeType": "text/markdown"
      }
    ]
  }
}
```

## Implementation

### Types (libs/sdk-go/protocol/mcp.go)

- `MCPResourcesCapability` — Subscribe and ListChanged booleans
- `MCPResource` — URI, Name, Description, MimeType
- `MCPResourceTemplate` — URITemplate, Name, Description, MimeType
- `MCPResourceContent` — URI, MimeType, Text

### URI Scheme

Resources use the `orchestra://` URI scheme:
- `orchestra://features/FEAT-001` maps to storage path `features/FEAT-001.md`
- `orchestra://notes/my-note` maps to storage path `notes/my-note.md`
- `orchestra://docs/architecture` maps to storage path `docs/architecture.md`

### Storage Routing

Resource handlers translate MCP resource requests into storage operations:
- `resources/list` → `StorageList` for each prefix (features/, notes/, docs/)
- `resources/read` → `StorageRead` with the resolved storage path

Both stdio transport and WebGate implement the same handlers.
