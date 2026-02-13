package plugins

import (
	"fmt"
)

// PluginManifest holds metadata about a plugin, used for registration,
// marketplace listing, and dependency resolution.
type PluginManifest struct {
	// ID is the unique identifier of the plugin (e.g. "core.editor").
	ID string `json:"id"`

	// Name is the human-readable display name.
	Name string `json:"name"`

	// Version is the semantic version string (e.g. "1.0.0").
	Version string `json:"version"`

	// Description is a short summary of what the plugin does.
	Description string `json:"description"`

	// Author is the plugin author's name or organization.
	Author string `json:"author"`

	// License is the SPDX license identifier (e.g. "MIT").
	License string `json:"license"`

	// Icon is a path or URL to the plugin's icon.
	Icon string `json:"icon"`

	// Dependencies lists plugin IDs this plugin depends on.
	Dependencies []string `json:"dependencies"`

	// ActivationEvents lists events that trigger activation of this plugin.
	ActivationEvents []string `json:"activation_events"`

	// Contributes holds the plugin's UI/editor contributions.
	Contributes *Contributions `json:"contributes,omitempty"`

	// Marketable indicates whether this plugin should appear in the marketplace.
	Marketable bool `json:"marketable"`

	// MarketplaceCategory is the marketplace category for this plugin.
	MarketplaceCategory string `json:"marketplace_category,omitempty"`
}

// FromPlugin creates a PluginManifest from a Plugin instance,
// extracting all available metadata from the plugin's interfaces.
func FromPlugin(p Plugin) *PluginManifest {
	m := &PluginManifest{
		ID:           p.ID(),
		Name:         p.Name(),
		Version:      p.Version(),
		Dependencies: p.Dependencies(),
	}

	if m.Dependencies == nil {
		m.Dependencies = []string{}
	}

	// Extract contributions if the plugin implements Contributable.
	if c, ok := p.(Contributable); ok {
		m.Contributes = c.Contributes()
	}

	// Extract marketplace info if the plugin implements Marketable.
	if mk, ok := p.(Marketable); ok {
		m.Marketable = mk.IsMarketable()
		m.MarketplaceCategory = mk.MarketplaceCategory()
		if m.Description == "" {
			m.Description = mk.MarketplaceDescription()
		}
	}

	return m
}

// Validate checks the manifest for required fields and returns an error
// if any required field is missing or invalid.
func (m *PluginManifest) Validate() error {
	if m.ID == "" {
		return fmt.Errorf("plugin manifest: ID is required")
	}
	if m.Name == "" {
		return fmt.Errorf("plugin manifest: Name is required for plugin %q", m.ID)
	}
	if m.Version == "" {
		return fmt.Errorf("plugin manifest: Version is required for plugin %q", m.ID)
	}
	return nil
}
