package plugins

import (
	"github.com/rs/zerolog"
)

// PluginContext is passed to a plugin's Activate method, providing
// access to the plugin's environment, configuration, and services.
type PluginContext struct {
	// PluginID is the unique identifier of the plugin being activated.
	PluginID string

	// PluginPath is the filesystem path to the plugin's root directory.
	PluginPath string

	// StoragePath is the filesystem path where the plugin can persist data.
	StoragePath string

	// Config holds the plugin's resolved configuration values.
	Config map[string]any

	// Logger is a pre-configured logger scoped to this plugin.
	Logger zerolog.Logger

	// Services provides access to the plugin-scoped service registry.
	Services *ServiceRegistry
}

// NewPluginContext creates a new PluginContext with the given parameters.
func NewPluginContext(pluginID, pluginPath, storagePath string, config map[string]any, logger zerolog.Logger, services *ServiceRegistry) *PluginContext {
	return &PluginContext{
		PluginID:    pluginID,
		PluginPath:  pluginPath,
		StoragePath: storagePath,
		Config:      config,
		Logger:      logger,
		Services:    services,
	}
}

// GetConfig retrieves a configuration value by key, returning the
// value and a boolean indicating whether the key was found.
func (ctx *PluginContext) GetConfig(key string) (any, bool) {
	if ctx.Config == nil {
		return nil, false
	}
	val, ok := ctx.Config[key]
	return val, ok
}

// GetConfigString retrieves a string configuration value by key,
// returning an empty string if the key is not found or not a string.
func (ctx *PluginContext) GetConfigString(key string) string {
	val, ok := ctx.GetConfig(key)
	if !ok {
		return ""
	}
	s, ok := val.(string)
	if !ok {
		return ""
	}
	return s
}
