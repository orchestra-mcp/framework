---
title: Go Plugin SDK
description: Build Orchestra plugins in Go using the sdk-go package
order: 2
---

# Go Plugin SDK

The Go SDK (`github.com/orchestra-mcp/sdk-go`) provides everything needed to build Orchestra plugins in Go.

## Quick Example

```go
package main

import (
    "context"
    "github.com/orchestra-mcp/sdk-go/plugin"
)

func main() {
    p := plugin.New("my-plugin").
        RegisterTool("hello_world", helloHandler).
        Build()

    p.Run(context.Background())
}

func helloHandler(ctx context.Context, params map[string]any) (any, error) {
    name := params["name"].(string)
    return map[string]string{"message": "Hello, " + name + "!"}, nil
}
```

## Package Structure

### `plugin/` — Core Transport + Builder

| File | Purpose |
|------|---------|
| `plugin.go` | Fluent builder API: `New(id).RegisterTool().Build().Run()` |
| `server.go` | QUIC server: accept streams, dispatch tool calls |
| `client.go` | QUIC client: connect to orchestrator |
| `framing.go` | Length-delimited Protobuf read/write |
| `certs.go` | Auto mTLS certificate management |
| `manifest.go` | Plugin manifest builder |
| `lifecycle.go` | `OnBoot`, `OnShutdown` hooks |
| `export.go` | In-process export for bundled plugins |

### `types/` — Domain Types

| Type | Fields |
|------|--------|
| `FeatureData` | ID, Title, Status, Kind, Body, Assignee, Labels |
| `ProjectData` | ID, Name, Slug, Description |
| `CanTransition()` | State machine validation |

### `helpers/` — Utilities

ID generation, markdown parsing, YAML frontmatter, date formatting.

## Building a Plugin

### Step 1: Define Tools

```go
p := plugin.New("my-tools").
    RegisterTool("create_widget", createWidgetHandler).
    RegisterTool("list_widgets", listWidgetsHandler).
    RegisterTool("delete_widget", deleteWidgetHandler).
    Build()
```

### Step 2: Implement Handlers

```go
func createWidgetHandler(ctx context.Context, params map[string]any) (any, error) {
    name := params["name"].(string)
    // ... create widget logic
    return map[string]string{
        "id":   "WDG-001",
        "name": name,
    }, nil
}
```

### Step 3: Cross-Plugin Calls

Plugins can call tools from other plugins via the orchestrator:

```go
func myHandler(ctx context.Context, params map[string]any) (any, error) {
    // Call a tool from another plugin
    result, err := plugin.CallTool(ctx, "search_memory", map[string]any{
        "query": "authentication",
    })
    return result, err
}
```

### Step 4: Run

```go
func main() {
    p := plugin.New("my-tools").
        RegisterTool("create_widget", createWidgetHandler).
        Build()

    p.Run(context.Background())
}
```

## In-Process vs External

### In-Process Plugin

For plugins that ship with Orchestra, use the export pattern:

```go
// export.go at package root
package mytools

func Register(builder *plugin.PluginBuilder) {
    builder.RegisterTool("my_tool", myHandler)
}
```

### External Plugin

For standalone plugins, build a binary:

```bash
go build -o bin/my-plugin ./cmd/my-plugin
```

The binary connects to the orchestrator over QUIC on startup.

## Testing

```go
func TestMyTool(t *testing.T) {
    result, err := createWidgetHandler(context.Background(), map[string]any{
        "name": "Test Widget",
    })
    require.NoError(t, err)
    assert.Equal(t, "WDG-001", result.(map[string]string)["id"])
}
```

Run tests:

```bash
go test ./...
```
