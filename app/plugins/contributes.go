package plugins

import (
	"sync"
)

// ContributesRegistry is a global registry for UI/editor contributions
// from all plugins. It aggregates commands, menus, settings, keybindings,
// and themes contributed by active plugins.
type ContributesRegistry struct {
	mu          sync.RWMutex
	commands    map[string][]CommandContribution
	menus       map[string][]MenuContribution
	settings    map[string][]SettingContribution
	keybindings map[string][]KeybindingContribution
	themes      map[string][]ThemeContribution
}

// NewContributesRegistry creates a new, empty ContributesRegistry.
func NewContributesRegistry() *ContributesRegistry {
	return &ContributesRegistry{
		commands:    make(map[string][]CommandContribution),
		menus:       make(map[string][]MenuContribution),
		settings:    make(map[string][]SettingContribution),
		keybindings: make(map[string][]KeybindingContribution),
		themes:      make(map[string][]ThemeContribution),
	}
}

// RegisterCommand registers a command contribution from a specific plugin.
func (cr *ContributesRegistry) RegisterCommand(pluginID string, cmd CommandContribution) {
	cr.mu.Lock()
	defer cr.mu.Unlock()
	cr.commands[pluginID] = append(cr.commands[pluginID], cmd)
}

// RegisterMenu registers a menu contribution from a specific plugin.
func (cr *ContributesRegistry) RegisterMenu(pluginID string, menu MenuContribution) {
	cr.mu.Lock()
	defer cr.mu.Unlock()
	cr.menus[pluginID] = append(cr.menus[pluginID], menu)
}

// RegisterSetting registers a setting contribution from a specific plugin.
func (cr *ContributesRegistry) RegisterSetting(pluginID string, setting SettingContribution) {
	cr.mu.Lock()
	defer cr.mu.Unlock()
	cr.settings[pluginID] = append(cr.settings[pluginID], setting)
}

// RegisterKeybinding registers a keybinding contribution from a specific plugin.
func (cr *ContributesRegistry) RegisterKeybinding(pluginID string, kb KeybindingContribution) {
	cr.mu.Lock()
	defer cr.mu.Unlock()
	cr.keybindings[pluginID] = append(cr.keybindings[pluginID], kb)
}

// RegisterTheme registers a theme contribution from a specific plugin.
func (cr *ContributesRegistry) RegisterTheme(pluginID string, theme ThemeContribution) {
	cr.mu.Lock()
	defer cr.mu.Unlock()
	cr.themes[pluginID] = append(cr.themes[pluginID], theme)
}

// RegisterFromPlugin registers all contributions from a Contributions struct
// under the given plugin ID.
func (cr *ContributesRegistry) RegisterFromPlugin(pluginID string, c *Contributions) {
	if c == nil {
		return
	}

	cr.mu.Lock()
	defer cr.mu.Unlock()

	if len(c.Commands) > 0 {
		cr.commands[pluginID] = append(cr.commands[pluginID], c.Commands...)
	}
	if len(c.Menus) > 0 {
		cr.menus[pluginID] = append(cr.menus[pluginID], c.Menus...)
	}
	if len(c.Settings) > 0 {
		cr.settings[pluginID] = append(cr.settings[pluginID], c.Settings...)
	}
	if len(c.Keybindings) > 0 {
		cr.keybindings[pluginID] = append(cr.keybindings[pluginID], c.Keybindings...)
	}
	if len(c.Themes) > 0 {
		cr.themes[pluginID] = append(cr.themes[pluginID], c.Themes...)
	}
}

// GetCommands returns all registered command contributions across all plugins.
func (cr *ContributesRegistry) GetCommands() []CommandContribution {
	cr.mu.RLock()
	defer cr.mu.RUnlock()

	var result []CommandContribution
	for _, cmds := range cr.commands {
		result = append(result, cmds...)
	}
	return result
}

// GetMenus returns all registered menu contributions across all plugins.
func (cr *ContributesRegistry) GetMenus() []MenuContribution {
	cr.mu.RLock()
	defer cr.mu.RUnlock()

	var result []MenuContribution
	for _, menus := range cr.menus {
		result = append(result, menus...)
	}
	return result
}

// GetSettings returns all registered setting contributions across all plugins.
func (cr *ContributesRegistry) GetSettings() []SettingContribution {
	cr.mu.RLock()
	defer cr.mu.RUnlock()

	var result []SettingContribution
	for _, settings := range cr.settings {
		result = append(result, settings...)
	}
	return result
}

// GetKeybindings returns all registered keybinding contributions across all plugins.
func (cr *ContributesRegistry) GetKeybindings() []KeybindingContribution {
	cr.mu.RLock()
	defer cr.mu.RUnlock()

	var result []KeybindingContribution
	for _, kbs := range cr.keybindings {
		result = append(result, kbs...)
	}
	return result
}

// GetThemes returns all registered theme contributions across all plugins.
func (cr *ContributesRegistry) GetThemes() []ThemeContribution {
	cr.mu.RLock()
	defer cr.mu.RUnlock()

	var result []ThemeContribution
	for _, themes := range cr.themes {
		result = append(result, themes...)
	}
	return result
}

// Flush removes all registered contributions, resetting the registry.
func (cr *ContributesRegistry) Flush() {
	cr.mu.Lock()
	defer cr.mu.Unlock()
	cr.commands = make(map[string][]CommandContribution)
	cr.menus = make(map[string][]MenuContribution)
	cr.settings = make(map[string][]SettingContribution)
	cr.keybindings = make(map[string][]KeybindingContribution)
	cr.themes = make(map[string][]ThemeContribution)
}
