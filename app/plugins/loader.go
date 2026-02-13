package plugins

import (
	"fmt"

	"github.com/rs/zerolog"
)

// PluginLoader handles plugin discovery and bulk registration.
// In Go, plugins are registered programmatically rather than discovered
// at runtime from the filesystem, but this struct provides the structure
// for organizing plugin registration and base path configuration.
type PluginLoader struct {
	basePath string
	logger   zerolog.Logger
}

// NewPluginLoader creates a new PluginLoader that looks for plugins
// under the given base path.
func NewPluginLoader(basePath string) *PluginLoader {
	return &PluginLoader{
		basePath: basePath,
		logger:   zerolog.Nop(),
	}
}

// SetLogger sets the logger for the plugin loader.
func (l *PluginLoader) SetLogger(logger zerolog.Logger) {
	l.logger = logger
}

// BasePath returns the base directory path for plugins.
func (l *PluginLoader) BasePath() string {
	return l.basePath
}

// RegisterAll registers multiple plugins with the given PluginManager.
// It stops and returns an error if any plugin fails to register.
func (l *PluginLoader) RegisterAll(manager *PluginManager, plugins ...Plugin) error {
	for _, p := range plugins {
		l.logger.Debug().
			Str("plugin", p.ID()).
			Str("version", p.Version()).
			Msg("registering plugin")

		if err := manager.Register(p); err != nil {
			return fmt.Errorf("failed to register plugin %q: %w", p.ID(), err)
		}
	}

	l.logger.Info().
		Int("count", len(plugins)).
		Msg("all plugins registered")

	return nil
}
