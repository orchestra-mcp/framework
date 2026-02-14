package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

// validationResult holds the outcome of a plugin validation.
type validationResult struct {
	Path   string
	Errors []string
	Warns  []string
}

// IsValid returns true if no errors were found.
func (v *validationResult) IsValid() bool {
	return len(v.Errors) == 0
}

// validatePlugin checks that a plugin directory has the expected structure.
func validatePlugin(pluginPath string) *validationResult {
	result := &validationResult{Path: pluginPath}

	info, err := os.Stat(pluginPath)
	if err != nil || !info.IsDir() {
		result.Errors = append(result.Errors, "path does not exist or is not a directory")
		return result
	}

	checkGoMod(pluginPath, result)
	checkProviderPlugin(pluginPath, result)
	checkRequiredDirs(pluginPath, result)

	return result
}

// checkGoMod verifies go.mod exists and contains the replace directive.
func checkGoMod(pluginPath string, result *validationResult) {
	goModPath := filepath.Join(pluginPath, "go.mod")
	data, err := os.ReadFile(goModPath)
	if err != nil {
		result.Errors = append(result.Errors, "go.mod not found")
		return
	}

	content := string(data)
	if !strings.Contains(content, "github.com/orchestra-mcp/framework") {
		result.Errors = append(result.Errors, "go.mod missing framework dependency")
	}
	if !strings.Contains(content, "replace github.com/orchestra-mcp/framework") {
		result.Warns = append(result.Warns, "go.mod missing replace directive for framework")
	}
}

// checkProviderPlugin verifies providers/plugin.go exists and implements Plugin.
func checkProviderPlugin(pluginPath string, result *validationResult) {
	providerPath := filepath.Join(pluginPath, "providers", "plugin.go")
	data, err := os.ReadFile(providerPath)
	if err != nil {
		result.Errors = append(result.Errors, "providers/plugin.go not found")
		return
	}

	content := string(data)
	if !strings.Contains(content, "plugins.Plugin") {
		result.Errors = append(result.Errors, "providers/plugin.go does not reference plugins.Plugin interface")
	}

	checkPluginID(content, pluginPath, result)
}

// checkPluginID verifies the plugin ID follows the naming convention.
func checkPluginID(content string, pluginPath string, result *validationResult) {
	// Look for ID() method returning a string literal.
	if idx := strings.Index(content, `func (p *`); idx >= 0 {
		if !strings.Contains(content, `ID()`) {
			result.Warns = append(result.Warns, "providers/plugin.go may be missing ID() method")
		}
	}

	// Check for valid ID format: orchestra/<name> or vendor/<name>.
	name := filepath.Base(pluginPath)
	expected := fmt.Sprintf(`"orchestra/%s"`, name)
	if !strings.Contains(content, expected) {
		// Allow vendor/<name> format too.
		if !strings.Contains(content, fmt.Sprintf(`/%s"`, name)) {
			result.Warns = append(result.Warns, "plugin ID may not match directory name: "+name)
		}
	}
}

// checkRequiredDirs verifies expected subdirectories exist.
func checkRequiredDirs(pluginPath string, result *validationResult) {
	required := []string{"config", "providers", "src"}
	for _, dir := range required {
		p := filepath.Join(pluginPath, dir)
		info, err := os.Stat(p)
		if err != nil || !info.IsDir() {
			result.Errors = append(result.Errors, fmt.Sprintf("required directory missing: %s/", dir))
		}
	}

	// Tests directory is recommended, not required.
	testsDir := filepath.Join(pluginPath, "tests")
	if info, err := os.Stat(testsDir); err != nil || !info.IsDir() {
		result.Warns = append(result.Warns, "recommended directory missing: tests/")
	}
}

// printValidation prints the validation result to stdout.
func printValidation(v *validationResult) {
	fmt.Printf("Validating: %s\n", v.Path)
	if v.IsValid() && len(v.Warns) == 0 {
		fmt.Println("  OK - plugin structure is valid")
		return
	}
	for _, e := range v.Errors {
		fmt.Printf("  ERROR: %s\n", e)
	}
	for _, w := range v.Warns {
		fmt.Printf("  WARN:  %s\n", w)
	}
	if v.IsValid() {
		fmt.Println("  Result: VALID (with warnings)")
	} else {
		fmt.Println("  Result: INVALID")
	}
}
