package main

import (
	"embed"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"text/template"
)

//go:embed templates/*.tmpl
var templateFS embed.FS

// validCapabilities lists all supported --with capability names.
var validCapabilities = []string{
	"routes", "settings", "mcp", "tray",
	"panels", "widgets", "notifications", "search",
}

// templateData holds all variables available inside templates.
type templateData struct {
	Name         string
	PascalName   string
	ID           string
	Module       string
	Capabilities []string
}

// HasCapability returns true if the named capability was requested.
func (d templateData) HasCapability(name string) bool {
	for _, c := range d.Capabilities {
		if c == name {
			return true
		}
	}
	return false
}

// toPascalCase converts a kebab-case or snake_case string to PascalCase.
func toPascalCase(s string) string {
	parts := strings.FieldsFunc(s, func(r rune) bool {
		return r == '-' || r == '_'
	})
	var b strings.Builder
	for _, part := range parts {
		if len(part) == 0 {
			continue
		}
		b.WriteString(strings.ToUpper(part[:1]))
		b.WriteString(part[1:])
	}
	return b.String()
}

// generatePlugin scaffolds a complete plugin directory under pluginsDir.
func generatePlugin(name string, capabilities []string, pluginsDir string) error {
	if err := validatePluginName(name); err != nil {
		return err
	}
	if err := validateCapabilities(capabilities); err != nil {
		return err
	}

	data := templateData{
		Name:         name,
		PascalName:   toPascalCase(name),
		ID:           "orchestra/" + name,
		Module:       "github.com/orchestra-mcp/" + name,
		Capabilities: capabilities,
	}

	pluginRoot := filepath.Join(pluginsDir, name)
	if _, err := os.Stat(pluginRoot); err == nil {
		return fmt.Errorf("plugin directory already exists: %s", pluginRoot)
	}

	// Define output files mapped to their template names.
	files := []struct {
		tmpl string
		dest string
	}{
		{"go.mod.tmpl", "go.mod"},
		{"config.go.tmpl", filepath.Join("config", name+".go")},
		{"plugin.go.tmpl", filepath.Join("providers", "plugin.go")},
		{"service.go.tmpl", filepath.Join("src", "service.go")},
		{"types.go.tmpl", filepath.Join("src", "types.go")},
		{"test.go.tmpl", filepath.Join("tests", "service_test.go")},
		{"readme.md.tmpl", "README.md"},
	}

	for _, f := range files {
		if err := renderTemplate(pluginRoot, f.tmpl, f.dest, data); err != nil {
			return fmt.Errorf("failed to render %s: %w", f.dest, err)
		}
	}

	return nil
}

// renderTemplate parses an embedded template and writes the result.
func renderTemplate(root, tmplName, dest string, data templateData) error {
	content, err := templateFS.ReadFile("templates/" + tmplName)
	if err != nil {
		return fmt.Errorf("read template %s: %w", tmplName, err)
	}

	tmpl, err := template.New(tmplName).Parse(string(content))
	if err != nil {
		return fmt.Errorf("parse template %s: %w", tmplName, err)
	}

	outPath := filepath.Join(root, dest)
	if err := os.MkdirAll(filepath.Dir(outPath), 0755); err != nil {
		return fmt.Errorf("create dir for %s: %w", dest, err)
	}

	file, err := os.Create(outPath)
	if err != nil {
		return fmt.Errorf("create file %s: %w", dest, err)
	}
	defer file.Close()

	return tmpl.Execute(file, data)
}

// validatePluginName checks that the name is a valid identifier.
func validatePluginName(name string) error {
	if name == "" {
		return fmt.Errorf("plugin name is required")
	}
	for _, r := range name {
		if !((r >= 'a' && r <= 'z') || (r >= '0' && r <= '9') || r == '-') {
			return fmt.Errorf("invalid plugin name %q: use lowercase letters, digits, and hyphens only", name)
		}
	}
	if name[0] == '-' || name[len(name)-1] == '-' {
		return fmt.Errorf("plugin name %q must not start or end with a hyphen", name)
	}
	return nil
}

// validateCapabilities checks all requested capabilities are valid.
func validateCapabilities(caps []string) error {
	valid := make(map[string]bool)
	for _, c := range validCapabilities {
		valid[c] = true
	}
	for _, c := range caps {
		if !valid[c] {
			return fmt.Errorf("unknown capability %q; valid: %s", c, strings.Join(validCapabilities, ", "))
		}
	}
	return nil
}
