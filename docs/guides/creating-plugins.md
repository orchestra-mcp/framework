# Creating a Plugin

Step-by-step guide to creating an Orchestra plugin.

## 1. Create the Plugin Directory

```bash
mkdir -p plugins/my-plugin/{config,providers,src,tests/unit,tests/feature,docs}
```

## 2. Initialize the Go Module

```bash
cd plugins/my-plugin
go mod init github.com/orchestra-mcp/my-plugin
```

Add the replace directive for the core framework:

```go
// go.mod
module github.com/orchestra-mcp/my-plugin

go 1.23

require github.com/orchestra-mcp/framework v0.0.0

replace github.com/orchestra-mcp/framework => ../..
```

## 3. Define Configuration

```go
// config/my_plugin.go
package config

type MyPluginConfig struct {
    Enabled bool   `json:"enabled" yaml:"enabled"`
    APIKey  string `json:"api_key" yaml:"api_key"`
}

func Default() MyPluginConfig {
    return MyPluginConfig{Enabled: true}
}
```

## 4. Implement the Plugin

```go
// providers/plugin.go
package providers

import "github.com/orchestra-mcp/framework/app/plugins"

type MyPlugin struct {
    active bool
    ctx    *plugins.PluginContext
}

func NewMyPlugin() *MyPlugin { return &MyPlugin{} }

func (p *MyPlugin) ID() string             { return "orchestra/my-plugin" }
func (p *MyPlugin) Name() string           { return "My Plugin" }
func (p *MyPlugin) Version() string        { return "0.1.0" }
func (p *MyPlugin) Dependencies() []string { return nil }
func (p *MyPlugin) IsActive() bool         { return p.active }

func (p *MyPlugin) Activate(ctx *plugins.PluginContext) error {
    p.ctx = ctx
    p.active = true
    ctx.Logger.Info().Msg("My plugin activated")
    return nil
}

func (p *MyPlugin) Deactivate() error {
    p.active = false
    return nil
}

// HasConfig
func (p *MyPlugin) ConfigKey() string            { return "my-plugin" }
func (p *MyPlugin) DefaultConfig() map[string]any { return map[string]any{"enabled": true} }

// HasFeatureFlag
func (p *MyPlugin) FeatureFlag() string { return "my-plugin" }
```

## 5. Add Capabilities

### HTTP Routes

```go
func (p *MyPlugin) RegisterRoutes(router fiber.Router) {
    g := router.Group("/my-plugin")
    g.Get("/status", func(c fiber.Ctx) error {
        return c.JSON(fiber.Map{"active": p.active})
    })
}
```

### MCP Tools

```go
func (p *MyPlugin) McpTools() []plugins.McpToolDefinition {
    return []plugins.McpToolDefinition{
        {
            Name:        "my_tool",
            Description: "Does something useful",
            InputSchema: map[string]any{"type": "object"},
            Handler: func(input map[string]any) (any, error) {
                return map[string]string{"result": "done"}, nil
            },
        },
    }
}
```

### Push Tools to MCP

Other plugins can push tools into the MCP server via `RegisterExternalTools`:

```go
func (p *MyPlugin) Activate(ctx *plugins.PluginContext) error {
    p.active = true
    // Find the MCP plugin and push tools
    if mcp, ok := ctx.Services.Get("mcp"); ok {
        if mcpPlugin, ok := mcp.(*mcpproviders.McpPlugin); ok {
            mcpPlugin.RegisterExternalTools(p.McpTools())
        }
    }
    return nil
}
```

## 6. Register the Plugin

Add it to `cmd/server/main.go`:

```go
import myproviders "github.com/orchestra-mcp/my-plugin/providers"

// In main():
loader.RegisterAll(pm,
    mcpproviders.NewMcpPlugin(),
    myproviders.NewMyPlugin(),
)
```

Add the replace directive to the root `go.mod`:

```
require github.com/orchestra-mcp/my-plugin v0.0.0
replace github.com/orchestra-mcp/my-plugin => ./plugins/my-plugin
```

## 7. Write Tests

```go
// tests/unit/providers/plugin_test.go
package providers_test

import (
    "testing"
    "github.com/orchestra-mcp/framework/app/plugins"
    "github.com/orchestra-mcp/my-plugin/providers"
    "github.com/rs/zerolog"
)

func TestPluginMetadata(t *testing.T) {
    p := providers.NewMyPlugin()
    if p.ID() != "orchestra/my-plugin" {
        t.Errorf("ID = %q", p.ID())
    }
}

func TestActivateDeactivate(t *testing.T) {
    p := providers.NewMyPlugin()
    ctx := &plugins.PluginContext{
        PluginID: p.ID(),
        Config:   map[string]any{},
        Logger:   zerolog.Nop(),
    }
    p.Activate(ctx)
    if !p.IsActive() { t.Error("should be active") }
    p.Deactivate()
    if p.IsActive() { t.Error("should be inactive") }
}
```

## 8. Build, Test, and Lint

```bash
# Build
cd plugins/my-plugin && go build ./...

# Test
cd plugins/my-plugin && go test ./tests/...

# Lint (uses root .golangci.yml config)
cd plugins/my-plugin && golangci-lint run ./...

# Format
gofumpt -w plugins/my-plugin/

# Or run everything from the repo root
make check    # format check + lint + tests for all code
```

## Compile-Time Interface Checks

Add assertions to verify your plugin implements all intended interfaces:

```go
var (
    _ plugins.Plugin         = (*MyPlugin)(nil)
    _ plugins.HasConfig      = (*MyPlugin)(nil)
    _ plugins.HasFeatureFlag = (*MyPlugin)(nil)
    _ plugins.HasRoutes      = (*MyPlugin)(nil)
)
```
