# Plugin Configuration Reference

Configuration types defined in `config/plugins.go`.

## PluginsConfig

```go
type PluginsConfig struct {
    Disabled     []string `json:"disabled" yaml:"disabled"`
    FeatureFlags bool     `json:"feature_flags" yaml:"feature_flags"`
    StoragePath  string   `json:"storage_path" yaml:"storage_path"`
    PluginsPath  string   `json:"plugins_path" yaml:"plugins_path"`
}
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `Disabled` | `[]string` | `[]` | Plugin IDs to skip during boot |
| `FeatureFlags` | `bool` | `true` | Enable the feature flag system |
| `StoragePath` | `string` | `storage/plugins` | Base directory for plugin data |
| `PluginsPath` | `string` | `plugins` | Base directory for plugin source |

## Default Configuration

```go
func DefaultPluginsConfig() *PluginsConfig {
    return &PluginsConfig{
        Disabled:     []string{},
        FeatureFlags: true,
        StoragePath:  "storage/plugins",
        PluginsPath:  "plugins",
    }
}
```

## Disabling Plugins

Add plugin IDs to the `Disabled` list:

```go
cfg := &config.PluginsConfig{
    Disabled: []string{"orchestra/mcp", "orchestra/ai"},
}
pm := plugins.NewPluginManager(cfg)
```

Disabled plugins are registered but never activated during Boot.

## Source

Defined in `config/plugins.go`.
