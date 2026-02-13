# Tool Development Guide

How to add new tools to the MCP plugin.

## Adding a Built-in Tool

### 1. Create the Tool File

```go
// src/tools/my_category.go
package tools

import (
    h "github.com/orchestra-mcp/mcp/src/helpers"
    t "github.com/orchestra-mcp/mcp/src/types"
)

func MyCategory(workspace string) []t.Tool {
    return []t.Tool{
        {
            Definition: t.ToolDefinition{
                Name:        "my_tool",
                Description: "What this tool does",
                InputSchema: t.InputSchema{
                    Type: "object",
                    Properties: map[string]any{
                        "name": map[string]any{
                            "type":        "string",
                            "description": "The name parameter",
                        },
                    },
                    Required: []string{"name"},
                },
            },
            Handler: func(args map[string]any) (*t.ToolResult, error) {
                name := h.GetString(args, "name")
                if name == "" {
                    return h.ErrorResult("name is required"), nil
                }
                return h.JSONResult(map[string]string{
                    "status": "done",
                    "name":   name,
                }), nil
            },
        },
    }
}
```

### 2. Register in Tools Aggregation

Add the tool group to `providers/tools.go`:

```go
func (p *McpPlugin) builtinTools() []t.Tool {
    ws := p.workspace
    var all []t.Tool
    // ... existing tool groups
    all = append(all, tools.MyCategory(ws)...)
    return all
}
```

### 3. Write Tests

```go
// tests/unit/tools/my_category_test.go
package tools_test

import (
    "testing"
    "github.com/orchestra-mcp/mcp/src/tools"
)

func TestMyTool(t *testing.T) {
    ws := t.TempDir()
    toolList := tools.MyCategory(ws)
    res, err := toolList[0].Handler(map[string]any{"name": "test"})
    if err != nil {
        t.Fatalf("error: %v", err)
    }
    if res.IsError {
        t.Fatalf("tool error: %s", res.Content[0].Text)
    }
}
```

## Result Helpers

Use helpers from `src/helpers/results.go`:

```go
h.TextResult("plain text response")
h.JSONResult(map[string]any{"key": "value"})
h.ErrorResult("something went wrong")
```

## Argument Helpers

Use helpers from `src/helpers/args.go`:

```go
name := h.GetString(args, "name")     // string or ""
count := h.GetInt(args, "count")      // int or 0 (handles float64)
val := h.GetFloat64(args, "val")      // float64 or 0
exists := h.Has(args, "key")          // bool
```

## File Helpers

Use helpers from `src/helpers/paths.go`:

```go
dir := h.ProjectsDir(workspace)              // .projects/
dir := h.ProjectDir(workspace, "my-app")     // .projects/my-app/
exists := h.FileExists(path)                 // bool
```

## TOON Files

Read and write TOON (YAML) files via `src/toon/`:

```go
// Write a struct to a TOON file
toon.WriteFile(path, &myStruct)

// Parse a TOON file into a struct
var data MyStruct
toon.ParseFile(path, &data)
```

## Adding External Tools (From Another Plugin)

See [Creating Plugins — Push Tools to MCP](../../docs/guides/creating-plugins.md).
