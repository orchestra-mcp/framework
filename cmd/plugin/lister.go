package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

// pluginInfo holds metadata extracted from a discovered plugin directory.
type pluginInfo struct {
	Name         string
	ID           string
	Version      string
	Disabled     bool
	Capabilities []string
}

// listPlugins scans the plugins directory and returns discovered plugins.
func listPlugins(pluginsDir string) ([]pluginInfo, error) {
	entries, err := os.ReadDir(pluginsDir)
	if err != nil {
		return nil, fmt.Errorf("cannot read plugins directory %s: %w", pluginsDir, err)
	}

	disabled := loadDisabledPlugins()
	var plugins []pluginInfo

	for _, entry := range entries {
		if !entry.IsDir() {
			continue
		}
		providerPath := filepath.Join(pluginsDir, entry.Name(), "providers", "plugin.go")
		data, err := os.ReadFile(providerPath)
		if err != nil {
			continue // skip directories without a plugin provider
		}
		info := extractPluginInfo(entry.Name(), string(data))
		info.Disabled = isDisabled(info.ID, disabled)
		plugins = append(plugins, info)
	}

	return plugins, nil
}

// extractPluginInfo parses metadata from provider source code.
func extractPluginInfo(dirName, source string) pluginInfo {
	info := pluginInfo{
		Name:    dirName,
		ID:      "orchestra/" + dirName,
		Version: "0.0.0",
	}

	info.ID = extractMethodStringReturn(source, "ID()", info.ID)
	info.Version = extractMethodStringReturn(source, "Version()", info.Version)
	info.Capabilities = detectCapabilities(source)

	return info
}

// extractMethodStringReturn finds a one-liner method and extracts its string literal.
// Pattern: func (p *...) <method> { return "<value>" }
func extractMethodStringReturn(source, method, fallback string) string {
	idx := strings.Index(source, method)
	if idx < 0 {
		return fallback
	}

	// Look within a small window after the method signature for return "...".
	window := source[idx:]
	if len(window) > 200 {
		window = window[:200]
	}

	// Find the return statement with a string literal in this method.
	retIdx := strings.Index(window, `return "`)
	if retIdx < 0 {
		return fallback
	}

	rest := window[retIdx+len(`return "`):]
	end := strings.Index(rest, `"`)
	if end < 0 {
		return fallback
	}

	return rest[:end]
}

// detectCapabilities scans provider source for Has* interface implementations.
func detectCapabilities(source string) []string {
	checks := []struct {
		marker     string
		capability string
	}{
		{"HasRoutes", "routes"},
		{"HasConfig", "settings"},
		{"HasMcpTools", "mcp"},
		{"HasTrayMenu", "tray"},
		{"HasPanels", "panels"},
		{"HasWidgets", "widgets"},
		{"HasNotifications", "notifications"},
		{"HasSearchProviders", "search"},
	}

	var caps []string
	for _, c := range checks {
		if strings.Contains(source, c.marker) {
			caps = append(caps, c.capability)
		}
	}
	return caps
}

// loadDisabledPlugins reads config/plugins.go for the disabled list.
func loadDisabledPlugins() []string {
	data, err := os.ReadFile("config/plugins.go")
	if err != nil {
		return nil
	}
	return parseDisabledList(string(data))
}

// parseDisabledList extracts plugin IDs from the Disabled slice literal.
func parseDisabledList(content string) []string {
	idx := strings.Index(content, "Disabled:")
	if idx < 0 {
		return nil
	}

	sub := content[idx:]
	start := strings.Index(sub, "{")
	end := strings.Index(sub, "}")
	if start < 0 || end < 0 || end <= start {
		return nil
	}

	inner := sub[start+1 : end]
	var disabled []string
	for _, line := range strings.Split(inner, "\n") {
		line = strings.TrimSpace(line)
		line = strings.Trim(line, `",`)
		line = strings.TrimSpace(line)
		if line != "" {
			disabled = append(disabled, line)
		}
	}
	return disabled
}

// isDisabled checks if a plugin ID is in the disabled list.
func isDisabled(id string, disabled []string) bool {
	for _, d := range disabled {
		if d == id {
			return true
		}
	}
	return false
}

// getPluginInfo returns detailed info for a single named plugin.
func getPluginInfo(name, pluginsDir string) (*pluginInfo, error) {
	providerPath := filepath.Join(pluginsDir, name, "providers", "plugin.go")
	data, err := os.ReadFile(providerPath)
	if err != nil {
		return nil, fmt.Errorf("plugin %q not found at %s", name, pluginsDir)
	}

	disabled := loadDisabledPlugins()
	info := extractPluginInfo(name, string(data))
	info.Disabled = isDisabled(info.ID, disabled)
	return &info, nil
}

// printPluginList prints a formatted table of plugins.
func printPluginList(plugins []pluginInfo) {
	if len(plugins) == 0 {
		fmt.Println("No plugins found.")
		return
	}

	fmt.Printf("%-20s %-25s %-10s %-10s %s\n",
		"NAME", "ID", "VERSION", "STATUS", "CAPABILITIES")
	fmt.Println(strings.Repeat("-", 85))

	for _, p := range plugins {
		status := "active"
		if p.Disabled {
			status = "disabled"
		}
		caps := "-"
		if len(p.Capabilities) > 0 {
			caps = strings.Join(p.Capabilities, ", ")
		}
		fmt.Printf("%-20s %-25s %-10s %-10s %s\n",
			p.Name, p.ID, p.Version, status, caps)
	}
}

// printPluginInfo prints detailed info for a single plugin.
func printPluginInfo(p *pluginInfo) {
	status := "active"
	if p.Disabled {
		status = "disabled"
	}

	fmt.Printf("Name:         %s\n", p.Name)
	fmt.Printf("ID:           %s\n", p.ID)
	fmt.Printf("Version:      %s\n", p.Version)
	fmt.Printf("Status:       %s\n", status)

	if len(p.Capabilities) > 0 {
		fmt.Printf("Capabilities: %s\n", strings.Join(p.Capabilities, ", "))
	} else {
		fmt.Println("Capabilities: none")
	}
}

// togglePlugin adds or removes a plugin from the disabled list in config.
func togglePlugin(name, pluginsDir string, disable bool) error {
	info, err := getPluginInfo(name, pluginsDir)
	if err != nil {
		return err
	}

	configPath := "config/plugins.go"
	data, err := os.ReadFile(configPath)
	if err != nil {
		return fmt.Errorf("cannot read %s: %w", configPath, err)
	}

	content := string(data)
	disabled := parseDisabledList(content)

	if disable {
		if isDisabled(info.ID, disabled) {
			fmt.Printf("Plugin %q is already disabled.\n", info.ID)
			return nil
		}
		return addToDisabledList(configPath, content, info.ID)
	}

	if !isDisabled(info.ID, disabled) {
		fmt.Printf("Plugin %q is already enabled.\n", info.ID)
		return nil
	}
	return removeFromDisabledList(configPath, content, info.ID)
}

// addToDisabledList appends a plugin ID to the Disabled slice in config.
func addToDisabledList(configPath, content, pluginID string) error {
	// Replace empty Disabled list.
	old := "Disabled:     []string{},"
	if strings.Contains(content, old) {
		replacement := fmt.Sprintf("Disabled:     []string{\n\t\t\"%s\",\n\t},", pluginID)
		content = strings.Replace(content, old, replacement, 1)
	} else {
		// Insert before the closing brace of the Disabled slice.
		idx := strings.Index(content, "Disabled:")
		if idx < 0 {
			return fmt.Errorf("cannot find Disabled field in %s", configPath)
		}
		sub := content[idx:]
		braceIdx := strings.Index(sub, "}")
		if braceIdx < 0 {
			return fmt.Errorf("cannot parse Disabled field in %s", configPath)
		}
		insertAt := idx + braceIdx
		entry := fmt.Sprintf("\t\t\"%s\",\n\t", pluginID)
		content = content[:insertAt] + entry + content[insertAt:]
	}

	if err := os.WriteFile(configPath, []byte(content), 0644); err != nil {
		return fmt.Errorf("write %s: %w", configPath, err)
	}

	fmt.Printf("Disabled plugin: %s\n", pluginID)
	return nil
}

// removeFromDisabledList removes a plugin ID from the Disabled slice in config.
func removeFromDisabledList(configPath, content, pluginID string) error {
	// Remove the line containing the plugin ID.
	line := fmt.Sprintf("\t\t\"%s\",\n", pluginID)
	if !strings.Contains(content, line) {
		line = fmt.Sprintf(`"%s",`, pluginID)
	}
	content = strings.Replace(content, line, "", 1)

	// Clean up: if the list is now empty, reset to empty slice.
	idx := strings.Index(content, "Disabled:")
	if idx >= 0 {
		sub := content[idx:]
		start := strings.Index(sub, "{")
		end := strings.Index(sub, "}")
		if start >= 0 && end >= 0 {
			inner := strings.TrimSpace(sub[start+1 : end])
			if inner == "" {
				old := sub[:end+1]
				content = strings.Replace(content, old, "Disabled:     []string{}", 1)
			}
		}
	}

	if err := os.WriteFile(configPath, []byte(content), 0644); err != nil {
		return fmt.Errorf("write %s: %w", configPath, err)
	}

	fmt.Printf("Enabled plugin: %s\n", pluginID)
	return nil
}
