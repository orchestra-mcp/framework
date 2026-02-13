# Plugin System Guide

Orchestra uses a plugin-first architecture. Every feature — MCP server, AI assistant, terminal, editor — is a plugin.

## Core Concepts

### Plugin Interface

Every plugin implements the `Plugin` interface:

```go
type Plugin interface {
    ID() string                          // "orchestra/mcp"
    Name() string                        // "MCP Server"
    Version() string                     // "0.1.0"
    Dependencies() []string              // ["orchestra/core"]
    Activate(ctx *PluginContext) error
    Deactivate() error
    IsActive() bool
}
```

### Capability Interfaces

Plugins declare capabilities by implementing additional interfaces:

| Interface | Method | Purpose |
|-----------|--------|---------|
| `HasRoutes` | `RegisterRoutes(fiber.Router)` | HTTP endpoints |
| `HasConfig` | `ConfigKey()`, `DefaultConfig()` | Configuration |
| `HasCommands` | `Commands() []Command` | CLI commands |
| `HasMcpTools` | `McpTools() []McpToolDefinition` | MCP tools |
| `HasJobs` | `Jobs() []JobDefinition` | Background jobs |
| `HasMiddleware` | `Middleware() []any` | HTTP middleware |
| `HasServices` | `Services() []ServiceDefinition` | DI services |
| `HasMigrations` | `MigrationFiles() []string` | DB migrations |
| `HasSchedule` | `RegisterSchedule(any)` | Scheduled tasks |
| `Contributable` | `Contributes() *Contributions` | UI extensions |
| `HasFeatureFlag` | `FeatureFlag() string` | Feature gating |
| `Marketable` | `IsMarketable()`, `Category()`, etc. | Marketplace |
| `HasDesktopViews` | `DesktopViewsPath() string` | Desktop templates |
| `HasChromeViews` | `ChromeViewsPath() string` | Chrome extension |
| `HasWebViews` | `WebViewsPath() string` | Web dashboard |

### Plugin Lifecycle

```
Register → Boot → Activate → (running) → Deactivate → Shutdown
```

1. **Register** — plugin is known but not active
2. **Boot** — topological sort of dependencies, activate in order
3. **Activate** — receives `PluginContext` with config, logger, DI container
4. **Deactivate** — cleanup, release resources
5. **Shutdown** — deactivate all in reverse order

### Plugin Manager

The `PluginManager` orchestrates the lifecycle:

```go
cfg := config.DefaultPluginsConfig()
pm := plugins.NewPluginManager(cfg)
pm.SetLogger(logger)

// Register plugins
pm.Register(myPlugin)

// Boot — resolves deps, activates
pm.Boot()

// Collect capabilities from active plugins
pm.CollectRoutes(router)     // registers all HTTP routes
pm.CollectMcpTools()          // gathers all MCP tools
pm.CollectJobs()              // gathers all background jobs
pm.CollectMiddleware()        // gathers all middleware

// Shutdown gracefully
pm.Shutdown()
```

### Feature Flags

Any plugin can be disabled:

```go
// Via config
cfg := &config.PluginsConfig{
    Disabled: []string{"orchestra/mcp"},
}

// Via runtime
pm.Deactivate("orchestra/mcp")
```

Plugins with `HasFeatureFlag` are automatically gated:

```go
func (p *MyPlugin) FeatureFlag() string { return "my-feature" }
```

### Service Registry

Plugins share services through a thread-safe DI container:

```go
// Register a factory (new instance each call)
registry.Register("db", func() any { return newDB() })

// Register a singleton (same instance always)
registry.RegisterSingleton("cache", redisClient)

// Retrieve
svc, ok := registry.Get("db")
```

### Contributions

Plugins contribute UI elements (VS Code-style):

```go
func (p *MyPlugin) Contributes() *Contributions {
    return &Contributions{
        Commands: []CommandContribution{
            {ID: "my.command", Title: "My Command"},
        },
        Keybindings: []KeybindingContribution{
            {Command: "my.command", Key: "ctrl+shift+m"},
        },
    }
}
```

## Plugin Folder Convention

```
plugins/{name}/
  go.mod                    # Standalone module
  config/                   # Plugin config structs
  providers/                # Plugin registration
  src/                      # Source code
  resources/                # Bundled assets
  tests/                    # Test suite
    unit/                   # Unit tests
    feature/                # Integration tests
  docs/                     # Plugin documentation
  README.md
```

Each plugin is a standalone Go module with its own `go.mod`. It can be pushed as a separate GitHub repo.

## Code Quality

All Go code (framework and plugins) is checked with three tools:

| Tool | Config | Purpose |
|------|--------|---------|
| **golangci-lint** | `.golangci.yml` | 26 linters — errcheck, govet, staticcheck, revive, goconst, misspell, unparam, prealloc, etc. |
| **gofumpt** | `extra-rules: true` | Strict formatter (superset of gofmt) |
| **go test** | — | Unit + integration tests |

```bash
make check    # runs format check + lint + tests
make lint     # lint only
make fmt      # format only
make test     # tests only
```

Test files (`_test.go`) are excluded from `errcheck`, `unparam`, and `goconst` linters to keep tests focused.

## Next Steps

- [Creating Plugins](creating-plugins.md) — step-by-step guide
- [Plugin API Reference](../api/plugin-contracts.md) — all interfaces
- [Plugin Manager Reference](../api/plugin-manager.md) — manager methods
