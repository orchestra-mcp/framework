package providers_test

import (
	"testing"

	"github.com/orchestra-mcp/framework/app/plugins"
	"github.com/orchestra-mcp/mcp/providers"
	"github.com/orchestra-mcp/mcp/src/version"
	"github.com/rs/zerolog"
)

func TestPluginInterfaces(t *testing.T) {
	p := providers.NewMcpPlugin()
	var _ plugins.Plugin = p
	var _ plugins.HasConfig = p
	var _ plugins.HasCommands = p
	var _ plugins.HasFeatureFlag = p
	var _ plugins.HasMcpTools = p
	var _ plugins.HasRoutes = p
}

func TestPluginMetadata(t *testing.T) {
	p := providers.NewMcpPlugin()
	if p.ID() != "orchestra/mcp" {
		t.Errorf("ID = %q", p.ID())
	}
	if p.Name() != "MCP Server" {
		t.Errorf("Name = %q", p.Name())
	}
	if p.Version() != version.Version {
		t.Errorf("Version = %q, want %q", p.Version(), version.Version)
	}
}

func TestActivateDeactivate(t *testing.T) {
	p := providers.NewMcpPlugin()
	if p.IsActive() {
		t.Error("should not be active before Activate")
	}
	ctx := &plugins.PluginContext{
		PluginID: "orchestra/mcp",
		Config:   map[string]any{},
		Logger:   zerolog.Nop(),
	}
	if err := p.Activate(ctx); err != nil {
		t.Fatalf("Activate: %v", err)
	}
	if !p.IsActive() {
		t.Error("should be active after Activate")
	}
	if err := p.Deactivate(); err != nil {
		t.Fatalf("Deactivate: %v", err)
	}
	if p.IsActive() {
		t.Error("should not be active after Deactivate")
	}
}

func TestMcpToolsCount(t *testing.T) {
	p := providers.NewMcpPlugin()
	ctx := &plugins.PluginContext{
		PluginID: "orchestra/mcp",
		Config:   map[string]any{},
		Logger:   zerolog.Nop(),
	}
	p.Activate(ctx)
	tools := p.McpTools()
	if len(tools) != 40 {
		t.Errorf("McpTools count = %d, want 40", len(tools))
	}
}
