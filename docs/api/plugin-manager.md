# Plugin Manager API Reference

The `PluginManager` is the central orchestrator. Defined in `app/plugins/manager.go`.

## Constructor

```go
func NewPluginManager(cfg *config.PluginsConfig) *PluginManager
```

Creates a manager with the given config. If `cfg` is nil, uses `DefaultPluginsConfig()`.

## Configuration

```go
func (pm *PluginManager) SetLogger(logger zerolog.Logger)
```

## Registration

```go
func (pm *PluginManager) Register(p Plugin) error
```

Registers a plugin. Returns error if a plugin with the same ID is already registered. Automatically registers feature flags for plugins implementing `HasFeatureFlag`.

## Boot

```go
func (pm *PluginManager) Boot() error
```

Resolves dependencies via topological sort and activates all non-disabled plugins in dependency order. Can only be called once. Returns error on:
- Circular dependencies
- Missing dependencies
- Plugin activation failure

## Shutdown

```go
func (pm *PluginManager) Shutdown() error
```

Deactivates all active plugins in reverse dependency order. Safe to call after Boot.

## Single Plugin Control

```go
func (pm *PluginManager) Activate(id string) error
func (pm *PluginManager) Deactivate(id string) error
```

- `Activate` — verifies all dependencies are active first
- `Deactivate` — stops a single plugin

## Queries

```go
func (pm *PluginManager) Get(id string) (Plugin, bool)
func (pm *PluginManager) All() []Plugin
func (pm *PluginManager) Active() []Plugin
func (pm *PluginManager) Inactive() []Plugin
func (pm *PluginManager) IsDisabled(id string) bool
```

## Capability Collection

```go
func (pm *PluginManager) CollectRoutes(router fiber.Router)
func (pm *PluginManager) CollectMcpTools() []McpToolDefinition
func (pm *PluginManager) CollectJobs() []JobDefinition
func (pm *PluginManager) CollectMiddleware() []any
```

Each iterates over active plugins, checks for the relevant interface, and aggregates results.

## Boot Sequence Detail

1. Build dependency graph from all registered plugins
2. Topological sort (DFS with cycle detection)
3. For each plugin in sorted order:
   - Check `FeatureManager.IsDisabled()` — skip if disabled
   - Build `PluginContext` (paths, config, logger, services)
   - Register `HasServices` in global `ServiceRegistry`
   - Call `plugin.Activate(ctx)`
   - Register `Contributable` in `ContributesRegistry`
4. Mark manager as booted

## Related

- [Plugin Contracts](plugin-contracts.md)
- [Plugin System Guide](../guides/plugin-system.md)
- [PluginsConfig](plugin-config.md)
