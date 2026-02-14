package config

//go:generate go run ../cmd/plugin registry --path ../plugins --out ../config/registry/plugins.go

// PluginsConfig holds the configuration for the plugin system.
type PluginsConfig struct {
	// Disabled lists plugin IDs that should not be activated.
	Disabled []string `json:"disabled" yaml:"disabled"`

	// FeatureFlags enables or disables the feature flag system.
	FeatureFlags bool `json:"feature_flags" yaml:"feature_flags"`

	// StoragePath is the base directory for plugin storage.
	StoragePath string `json:"storage_path" yaml:"storage_path"`

	// PluginsPath is the base directory where plugins are located.
	PluginsPath string `json:"plugins_path" yaml:"plugins_path"`
}

// DefaultPluginsConfig returns a PluginsConfig with sensible defaults.
func DefaultPluginsConfig() *PluginsConfig {
	return &PluginsConfig{
		Disabled:     []string{},
		FeatureFlags: true,
		StoragePath:  "storage/plugins",
		PluginsPath:  "plugins",
	}
}
