package plugins

import (
	"sync"

	"github.com/nicepkg/orchestra-mcp/config"
)

// FeatureManager manages feature flags and disabled-plugin lists,
// determining whether a given plugin should be activated.
type FeatureManager struct {
	mu       sync.RWMutex
	disabled map[string]bool
	flags    map[string]bool
}

// NewFeatureManager creates a FeatureManager initialized from config.
// Plugins listed in config.Disabled are marked as disabled.
func NewFeatureManager(cfg *config.PluginsConfig) *FeatureManager {
	fm := &FeatureManager{
		disabled: make(map[string]bool),
		flags:    make(map[string]bool),
	}

	if cfg != nil {
		for _, id := range cfg.Disabled {
			fm.disabled[id] = true
		}
	}

	return fm
}

// IsDisabled reports whether a plugin is disabled. A plugin is disabled
// if it appears in the disabled list or if its feature flag is set to false.
func (fm *FeatureManager) IsDisabled(pluginID string) bool {
	fm.mu.RLock()
	defer fm.mu.RUnlock()

	// Explicitly disabled plugins are always disabled.
	if fm.disabled[pluginID] {
		return true
	}

	// If a feature flag has been registered for this plugin, check it.
	if flagValue, ok := fm.flags[pluginID]; ok {
		return !flagValue
	}

	// Not disabled by default.
	return false
}

// Enable marks a plugin as enabled by removing it from the disabled list
// and setting its feature flag to true.
func (fm *FeatureManager) Enable(pluginID string) {
	fm.mu.Lock()
	defer fm.mu.Unlock()
	delete(fm.disabled, pluginID)
	fm.flags[pluginID] = true
}

// Disable marks a plugin as disabled.
func (fm *FeatureManager) Disable(pluginID string) {
	fm.mu.Lock()
	defer fm.mu.Unlock()
	fm.disabled[pluginID] = true
}

// RegisterFlag registers a feature flag for a plugin. When feature flags
// are in use, a plugin with a registered flag set to false will be disabled.
func (fm *FeatureManager) RegisterFlag(pluginID string, flagValue bool) {
	fm.mu.Lock()
	defer fm.mu.Unlock()
	fm.flags[pluginID] = flagValue
}
