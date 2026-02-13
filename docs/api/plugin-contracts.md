# Plugin API Reference — Contracts

All interfaces and types defined in `app/plugins/contracts.go`.

## Plugin Interface

```go
type Plugin interface {
    ID() string
    Name() string
    Version() string
    Dependencies() []string
    Activate(ctx *PluginContext) error
    Deactivate() error
    IsActive() bool
}
```

Every plugin must implement this interface. ID must be unique across all registered plugins.

## Capability Interfaces

### HasRoutes

```go
type HasRoutes interface {
    RegisterRoutes(group fiber.Router)
}
```

Called during `CollectRoutes()`. The router group is pre-scoped to `/api`.

### HasConfig

```go
type HasConfig interface {
    ConfigKey() string
    DefaultConfig() map[string]any
}
```

`DefaultConfig()` is merged with user overrides during activation.

### HasCommands

```go
type HasCommands interface {
    Commands() []Command
}
```

### HasMcpTools

```go
type HasMcpTools interface {
    McpTools() []McpToolDefinition
}
```

Collected via `PluginManager.CollectMcpTools()`. MCP plugin aggregates all tool definitions.

### HasMigrations

```go
type HasMigrations interface {
    MigrationFiles() []string
}
```

### HasMiddleware

```go
type HasMiddleware interface {
    Middleware() []any
}
```

### HasJobs

```go
type HasJobs interface {
    Jobs() []JobDefinition
}
```

### HasSchedule

```go
type HasSchedule interface {
    RegisterSchedule(scheduler any)
}
```

### HasServices

```go
type HasServices interface {
    Services() []ServiceDefinition
}
```

Services are registered in the global `ServiceRegistry` during activation.

### Contributable

```go
type Contributable interface {
    Contributes() *Contributions
}
```

### HasFeatureFlag

```go
type HasFeatureFlag interface {
    FeatureFlag() string
}
```

When registered, the PluginManager checks the flag before activation.

### Marketable

```go
type Marketable interface {
    IsMarketable() bool
    MarketplaceCategory() string
    MarketplaceDescription() string
}
```

### View Interfaces

```go
type HasDesktopViews interface { DesktopViewsPath() string }
type HasChromeViews interface  { ChromeViewsPath() string }
type HasWebViews interface     { WebViewsPath() string }
```

## Data Types

### Command

```go
type Command struct {
    Name        string
    Description string
    Handler     func(args []string) error
}
```

### McpToolDefinition

```go
type McpToolDefinition struct {
    Name        string
    Description string
    InputSchema map[string]any
    Handler     func(input map[string]any) (any, error)
}
```

### JobDefinition

```go
type JobDefinition struct {
    Name    string
    Handler func(payload map[string]any) error
    Queue   string
}
```

### ServiceDefinition

```go
type ServiceDefinition struct {
    ID      string
    Factory func() any
}
```

### Contributions

```go
type Contributions struct {
    Commands    []CommandContribution
    Menus       []MenuContribution
    Settings    []SettingContribution
    Keybindings []KeybindingContribution
    Themes      []ThemeContribution
}
```

### CommandContribution

```go
type CommandContribution struct {
    ID, Title, Category, Icon string
}
```

### MenuContribution

```go
type MenuContribution struct {
    ID, Label, Group, Command, When string
    Priority int
}
```

### SettingContribution

```go
type SettingContribution struct {
    Key, Title, Description, Type string
    Default any
    Enum []any
    EnumLabels []string
}
```

### KeybindingContribution

```go
type KeybindingContribution struct {
    Command, Key, Mac, When string
    Priority int
}
```

### ThemeContribution

```go
type ThemeContribution struct {
    ID, Label, UITheme, Path, Description string
}
```

## Source

All types defined in `app/plugins/contracts.go`.
