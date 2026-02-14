package plugins

import (
	"fmt"
	"path/filepath"
	"sync"

	"github.com/gofiber/fiber/v3"
	"github.com/orchestra-mcp/framework/config"
	"github.com/rs/zerolog"
)

// PluginManager is the central orchestrator for the plugin system.
// It handles registration, dependency resolution, activation/deactivation,
// and aggregation of plugin capabilities.
type PluginManager struct {
	mu          sync.RWMutex
	plugins     map[string]Plugin
	active      map[string]bool
	order       []string
	features    *FeatureManager
	contributes *ContributesRegistry
	services    *ServiceRegistry
	config      *config.PluginsConfig
	logger      zerolog.Logger
	booted      bool
}

// NewPluginManager creates a new PluginManager with the given configuration.
func NewPluginManager(cfg *config.PluginsConfig) *PluginManager {
	if cfg == nil {
		cfg = config.DefaultPluginsConfig()
	}

	return &PluginManager{
		plugins:     make(map[string]Plugin),
		active:      make(map[string]bool),
		features:    NewFeatureManager(cfg),
		contributes: NewContributesRegistry(),
		services:    NewServiceRegistry(),
		config:      cfg,
		logger:      zerolog.Nop(),
	}
}

// SetLogger sets the logger for the plugin manager.
func (pm *PluginManager) SetLogger(logger zerolog.Logger) {
	pm.mu.Lock()
	defer pm.mu.Unlock()
	pm.logger = logger
}

// Register adds a plugin to the manager. The plugin is not activated
// until Boot or Activate is called. Returns an error if a plugin with
// the same ID is already registered.
func (pm *PluginManager) Register(p Plugin) error {
	pm.mu.Lock()
	defer pm.mu.Unlock()

	id := p.ID()
	if _, exists := pm.plugins[id]; exists {
		return fmt.Errorf("plugin %q is already registered", id)
	}

	pm.plugins[id] = p
	pm.logger.Debug().Str("plugin", id).Msg("plugin registered")

	// If the plugin implements HasFeatureFlag, register the flag.
	if ff, ok := p.(HasFeatureFlag); ok {
		flagName := ff.FeatureFlag()
		pm.features.RegisterFlag(id, true)
		pm.logger.Debug().
			Str("plugin", id).
			Str("flag", flagName).
			Msg("feature flag registered")
	}

	return nil
}

// Boot resolves plugin dependencies via topological sort and activates
// all non-disabled plugins in dependency order. It should be called once
// after all plugins have been registered.
func (pm *PluginManager) Boot() error {
	pm.mu.Lock()
	defer pm.mu.Unlock()

	if pm.booted {
		return fmt.Errorf("plugin manager has already been booted")
	}

	// Build the topological order.
	sorted, err := pm.topologicalSort()
	if err != nil {
		return fmt.Errorf("dependency resolution failed: %w", err)
	}

	pm.order = sorted

	// Activate plugins in order.
	for _, id := range sorted {
		if pm.features.IsDisabled(id) {
			pm.logger.Info().Str("plugin", id).Msg("plugin is disabled, skipping")
			continue
		}

		if err := pm.activatePlugin(id); err != nil {
			pm.logger.Error().Err(err).Str("plugin", id).Msg("failed to activate plugin")
			return fmt.Errorf("failed to activate plugin %q: %w", id, err)
		}
	}

	pm.booted = true
	pm.logger.Info().Int("active", len(pm.active)).Msg("plugin manager booted")

	return nil
}

// Shutdown deactivates all active plugins in reverse dependency order.
func (pm *PluginManager) Shutdown() error {
	pm.mu.Lock()
	defer pm.mu.Unlock()

	// Deactivate in reverse order.
	for i := len(pm.order) - 1; i >= 0; i-- {
		id := pm.order[i]
		if !pm.active[id] {
			continue
		}

		if err := pm.deactivatePlugin(id); err != nil {
			pm.logger.Error().Err(err).Str("plugin", id).Msg("failed to deactivate plugin during shutdown")
		}
	}

	pm.booted = false
	pm.logger.Info().Msg("plugin manager shut down")

	return nil
}

// Activate activates a single plugin by ID. Its dependencies must
// already be active.
func (pm *PluginManager) Activate(id string) error {
	pm.mu.Lock()
	defer pm.mu.Unlock()

	p, exists := pm.plugins[id]
	if !exists {
		return fmt.Errorf("plugin %q is not registered", id)
	}

	if pm.active[id] {
		return nil
	}

	// Verify all dependencies are active.
	for _, dep := range p.Dependencies() {
		if !pm.active[dep] {
			return fmt.Errorf("plugin %q depends on %q which is not active", id, dep)
		}
	}

	return pm.activatePlugin(id)
}

// Deactivate deactivates a single plugin by ID.
func (pm *PluginManager) Deactivate(id string) error {
	pm.mu.Lock()
	defer pm.mu.Unlock()

	if _, exists := pm.plugins[id]; !exists {
		return fmt.Errorf("plugin %q is not registered", id)
	}

	if !pm.active[id] {
		return nil
	}

	return pm.deactivatePlugin(id)
}

// Get returns a plugin by ID and a boolean indicating whether it was found.
func (pm *PluginManager) Get(id string) (Plugin, bool) {
	pm.mu.RLock()
	defer pm.mu.RUnlock()

	p, ok := pm.plugins[id]
	return p, ok
}

// All returns all registered plugins in registration order.
func (pm *PluginManager) All() []Plugin {
	pm.mu.RLock()
	defer pm.mu.RUnlock()

	result := make([]Plugin, 0, len(pm.plugins))
	for _, p := range pm.plugins {
		result = append(result, p)
	}
	return result
}

// Active returns all currently active plugins.
func (pm *PluginManager) Active() []Plugin {
	pm.mu.RLock()
	defer pm.mu.RUnlock()

	var result []Plugin
	for id, p := range pm.plugins {
		if pm.active[id] {
			result = append(result, p)
		}
	}
	return result
}

// Inactive returns all registered plugins that are not currently active.
func (pm *PluginManager) Inactive() []Plugin {
	pm.mu.RLock()
	defer pm.mu.RUnlock()

	var result []Plugin
	for id, p := range pm.plugins {
		if !pm.active[id] {
			result = append(result, p)
		}
	}
	return result
}

// IsDisabled returns whether a plugin is disabled via config or feature flags.
func (pm *PluginManager) IsDisabled(id string) bool {
	return pm.features.IsDisabled(id)
}

// CollectRoutes iterates over all active HasRoutes plugins and registers
// their routes on the provided fiber.Router.
func (pm *PluginManager) CollectRoutes(router fiber.Router) {
	pm.mu.RLock()
	defer pm.mu.RUnlock()

	for id, p := range pm.plugins {
		if !pm.active[id] {
			continue
		}
		if hr, ok := p.(HasRoutes); ok {
			hr.RegisterRoutes(router)
		}
	}
}

// CollectMcpTools collects all MCP tool definitions from active plugins.
func (pm *PluginManager) CollectMcpTools() []McpToolDefinition {
	pm.mu.RLock()
	defer pm.mu.RUnlock()

	var tools []McpToolDefinition
	for id, p := range pm.plugins {
		if !pm.active[id] {
			continue
		}
		if mt, ok := p.(HasMcpTools); ok {
			tools = append(tools, mt.McpTools()...)
		}
	}
	return tools
}

// CollectJobs collects all job definitions from active plugins.
func (pm *PluginManager) CollectJobs() []JobDefinition {
	pm.mu.RLock()
	defer pm.mu.RUnlock()

	var jobs []JobDefinition
	for id, p := range pm.plugins {
		if !pm.active[id] {
			continue
		}
		if hj, ok := p.(HasJobs); ok {
			jobs = append(jobs, hj.Jobs()...)
		}
	}
	return jobs
}

// CollectMiddleware collects all middleware from active plugins.
func (pm *PluginManager) CollectMiddleware() []any {
	pm.mu.RLock()
	defer pm.mu.RUnlock()

	var middleware []any
	for id, p := range pm.plugins {
		if !pm.active[id] {
			continue
		}
		if hm, ok := p.(HasMiddleware); ok {
			middleware = append(middleware, hm.Middleware()...)
		}
	}
	return middleware
}

// CollectTrayMenuItems collects tray menu items from all active plugins.
func (pm *PluginManager) CollectTrayMenuItems() []TrayMenuItemDef {
	pm.mu.RLock()
	defer pm.mu.RUnlock()

	var items []TrayMenuItemDef
	for id, p := range pm.plugins {
		if !pm.active[id] {
			continue
		}
		if ht, ok := p.(HasTrayMenu); ok {
			items = append(items, ht.TrayMenuItems()...)
		}
	}
	return items
}

// CollectPanels collects panel definitions from all active plugins.
func (pm *PluginManager) CollectPanels() []PanelDef {
	pm.mu.RLock()
	defer pm.mu.RUnlock()

	var panels []PanelDef
	for id, p := range pm.plugins {
		if !pm.active[id] {
			continue
		}
		if hp, ok := p.(HasPanels); ok {
			panels = append(panels, hp.Panels()...)
		}
	}
	return panels
}

// CollectWidgets collects widget definitions from all active plugins.
func (pm *PluginManager) CollectWidgets() []WidgetDef {
	pm.mu.RLock()
	defer pm.mu.RUnlock()

	var widgets []WidgetDef
	for id, p := range pm.plugins {
		if !pm.active[id] {
			continue
		}
		if hw, ok := p.(HasWidgets); ok {
			widgets = append(widgets, hw.Widgets()...)
		}
	}
	return widgets
}

// CollectSettings collects all settings groups and definitions from active plugins.
func (pm *PluginManager) CollectSettings() ([]SettingsGroupDef, []SettingsFieldDef) {
	pm.mu.RLock()
	defer pm.mu.RUnlock()

	var groups []SettingsGroupDef
	var fields []SettingsFieldDef
	for id, p := range pm.plugins {
		if !pm.active[id] {
			continue
		}
		if hs, ok := p.(HasSettings); ok {
			groups = append(groups, hs.SettingsGroups()...)
			fields = append(fields, hs.SettingsDefinitions()...)
		}
	}
	return groups, fields
}

// NotifyTransition broadcasts a workflow transition event to all active plugins
// that implement HasTransitionListener.
func (pm *PluginManager) NotifyTransition(event WorkflowTransitionEvent) {
	pm.mu.RLock()
	defer pm.mu.RUnlock()

	for id, p := range pm.plugins {
		if !pm.active[id] {
			continue
		}
		if tl, ok := p.(HasTransitionListener); ok {
			tl.OnWorkflowTransition(event)
		}
	}
}

// NotifyHookEvent broadcasts a Claude Code hook event to all active plugins
// that implement HasHookListener.
func (pm *PluginManager) NotifyHookEvent(event ClaudeHookEvent) {
	pm.mu.RLock()
	defer pm.mu.RUnlock()

	for id, p := range pm.plugins {
		if !pm.active[id] {
			continue
		}
		if hl, ok := p.(HasHookListener); ok {
			hl.OnClaudeHookEvent(event)
		}
	}
}

// activatePlugin performs the actual activation of a plugin. Must be called
// while holding pm.mu.
func (pm *PluginManager) activatePlugin(id string) error {
	p := pm.plugins[id]

	// Build the plugin context.
	pluginPath := filepath.Join(pm.config.PluginsPath, id)
	storagePath := filepath.Join(pm.config.StoragePath, id)

	var pluginConfig map[string]any
	if hc, ok := p.(HasConfig); ok {
		pluginConfig = hc.DefaultConfig()
	}
	if pluginConfig == nil {
		pluginConfig = make(map[string]any)
	}

	ctx := NewPluginContext(
		id,
		pluginPath,
		storagePath,
		pluginConfig,
		pm.logger.With().Str("plugin", id).Logger(),
		pm.services,
	)

	// Register services if the plugin provides them.
	if hs, ok := p.(HasServices); ok {
		for _, svc := range hs.Services() {
			pm.services.Register(svc.ID, svc.Factory)
		}
	}

	// Activate the plugin.
	if err := p.Activate(ctx); err != nil {
		return err
	}

	pm.active[id] = true

	// Register contributions.
	if c, ok := p.(Contributable); ok {
		pm.contributes.RegisterFromPlugin(id, c.Contributes())
	}

	pm.logger.Info().Str("plugin", id).Msg("plugin activated")

	return nil
}

// deactivatePlugin performs the actual deactivation of a plugin. Must be
// called while holding pm.mu.
func (pm *PluginManager) deactivatePlugin(id string) error {
	p := pm.plugins[id]

	if err := p.Deactivate(); err != nil {
		return err
	}

	delete(pm.active, id)
	pm.logger.Info().Str("plugin", id).Msg("plugin deactivated")

	return nil
}

// topologicalSort performs a topological sort of all registered plugins
// based on their declared dependencies. Returns an error if a cycle is
// detected or a dependency is missing.
func (pm *PluginManager) topologicalSort() ([]string, error) {
	// States: 0 = unvisited, 1 = visiting (in current DFS path), 2 = visited.
	const (
		unvisited = 0
		visiting  = 1
		visited   = 2
	)

	state := make(map[string]int)
	var sorted []string

	var visit func(id string) error
	visit = func(id string) error {
		switch state[id] {
		case visiting:
			return fmt.Errorf("circular dependency detected involving plugin %q", id)
		case visited:
			return nil
		}

		state[id] = visiting

		p, exists := pm.plugins[id]
		if !exists {
			return fmt.Errorf("missing dependency: plugin %q is not registered", id)
		}

		for _, dep := range p.Dependencies() {
			if _, ok := pm.plugins[dep]; !ok {
				return fmt.Errorf("plugin %q depends on %q which is not registered", id, dep)
			}
			if err := visit(dep); err != nil {
				return err
			}
		}

		state[id] = visited
		sorted = append(sorted, id)
		return nil
	}

	for id := range pm.plugins {
		if state[id] == unvisited {
			if err := visit(id); err != nil {
				return nil, err
			}
		}
	}

	return sorted, nil
}
