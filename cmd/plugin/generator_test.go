package main

import (
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestGeneratePluginCreatesDirectoryStructure(t *testing.T) {
	t.Parallel()
	dir := t.TempDir()
	err := generatePlugin("my-plugin", nil, dir)
	require.NoError(t, err)

	root := filepath.Join(dir, "my-plugin")
	expected := []string{
		"go.mod",
		filepath.Join("config", "my-plugin.go"),
		filepath.Join("providers", "plugin.go"),
		filepath.Join("src", "service.go"),
		filepath.Join("src", "types.go"),
		filepath.Join("tests", "service_test.go"),
		"README.md",
	}
	for _, rel := range expected {
		path := filepath.Join(root, rel)
		_, err := os.Stat(path)
		assert.NoError(t, err, "expected file to exist: %s", rel)
	}
}

func TestGeneratePluginGoModHasReplaceDirective(t *testing.T) {
	t.Parallel()
	dir := t.TempDir()
	err := generatePlugin("test-mod", nil, dir)
	require.NoError(t, err)

	data, err := os.ReadFile(filepath.Join(dir, "test-mod", "go.mod"))
	require.NoError(t, err)

	content := string(data)
	assert.Contains(t, content, "module github.com/orchestra-mcp/test-mod")
	assert.Contains(t, content, "replace github.com/orchestra-mcp/framework")
}

func TestGeneratePluginWithCapabilities(t *testing.T) {
	t.Parallel()
	dir := t.TempDir()
	caps := []string{"routes", "tray", "settings"}
	err := generatePlugin("cap-test", caps, dir)
	require.NoError(t, err)

	data, err := os.ReadFile(filepath.Join(dir, "cap-test", "providers", "plugin.go"))
	require.NoError(t, err)

	content := string(data)
	assert.Contains(t, content, "RegisterRoutes")
	assert.Contains(t, content, "TrayMenuItems")
	assert.Contains(t, content, "ConfigKey")
}

func TestGeneratePluginInvalidNameRejected(t *testing.T) {
	t.Parallel()
	tests := []struct {
		name    string
		wantErr string
	}{
		{"", "plugin name is required"},
		{"My-Plugin", "invalid plugin name"},
		{"-leading", "must not start or end with a hyphen"},
		{"trailing-", "must not start or end with a hyphen"},
		{"has space", "invalid plugin name"},
		{"UPPER", "invalid plugin name"},
	}
	for _, tc := range tests {
		err := validatePluginName(tc.name)
		assert.Error(t, err, "name=%q should be rejected", tc.name)
		if err != nil {
			assert.Contains(t, err.Error(), tc.wantErr)
		}
	}
}

func TestGeneratePluginDuplicateNameRejected(t *testing.T) {
	t.Parallel()
	dir := t.TempDir()
	err := generatePlugin("dup-test", nil, dir)
	require.NoError(t, err)

	err = generatePlugin("dup-test", nil, dir)
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "already exists")
}

func TestValidateCapabilitiesRejectsUnknown(t *testing.T) {
	t.Parallel()
	err := validateCapabilities([]string{"routes", "bogus"})
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "unknown capability")
}

func TestValidateCapabilitiesAcceptsValid(t *testing.T) {
	t.Parallel()
	err := validateCapabilities(validCapabilities)
	assert.NoError(t, err)
}

func TestToPascalCase(t *testing.T) {
	t.Parallel()
	tests := []struct{ input, want string }{
		{"my-plugin", "MyPlugin"},
		{"hello_world", "HelloWorld"},
		{"simple", "Simple"},
		{"a-b-c", "ABC"},
		{"one--two", "OneTwo"},
	}
	for _, tc := range tests {
		got := toPascalCase(tc.input)
		assert.Equal(t, tc.want, got, "toPascalCase(%q)", tc.input)
	}
}

func TestTemplateDataHasCapability(t *testing.T) {
	t.Parallel()
	data := templateData{Capabilities: []string{"routes", "mcp"}}
	assert.True(t, data.HasCapability("routes"))
	assert.True(t, data.HasCapability("mcp"))
	assert.False(t, data.HasCapability("tray"))
}

func TestGeneratedPluginProviderContainsInterface(t *testing.T) {
	t.Parallel()
	dir := t.TempDir()
	err := generatePlugin("iface-check", []string{"widgets"}, dir)
	require.NoError(t, err)

	data, err := os.ReadFile(filepath.Join(dir, "iface-check", "providers", "plugin.go"))
	require.NoError(t, err)

	content := string(data)
	assert.Contains(t, content, "plugins.Plugin")
	assert.Contains(t, content, "plugins.HasWidgets")
	// Should NOT contain capabilities we did not request.
	assert.False(t, strings.Contains(content, "HasRoutes"))
}
