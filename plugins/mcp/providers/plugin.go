package providers

import (
	"fmt"
	"os/exec"
	"sync"

	"github.com/orchestra-mcp/framework/app/plugins"
	"github.com/orchestra-mcp/mcp/src/version"
)

// McpPlugin implements the Orchestra plugin interface for the MCP server.
// Other plugins can push tools via RegisterExternalTools.
type McpPlugin struct {
	mu            sync.RWMutex
	active        bool
	ctx           *plugins.PluginContext
	workspace     string
	externalTools []plugins.McpToolDefinition
}

// NewMcpPlugin creates a new MCP plugin instance.
func NewMcpPlugin() *McpPlugin { return &McpPlugin{workspace: "."} }

func (p *McpPlugin) ID() string             { return "orchestra/mcp" }
func (p *McpPlugin) Name() string           { return "MCP Server" }
func (p *McpPlugin) Version() string        { return version.Version }
func (p *McpPlugin) Dependencies() []string { return nil }
func (p *McpPlugin) IsActive() bool         { return p.active }
func (p *McpPlugin) FeatureFlag() string    { return "mcp" }
func (p *McpPlugin) ConfigKey() string      { return "mcp" }

func (p *McpPlugin) DefaultConfig() map[string]any {
	return map[string]any{"enabled": true, "binary": "orchestra-mcp", "workspace": "."}
}

func (p *McpPlugin) Activate(ctx *plugins.PluginContext) error {
	p.ctx = ctx
	p.active = true
	if ws := ctx.GetConfigString("workspace"); ws != "" {
		p.workspace = ws
	}
	ctx.Logger.Info().Str("plugin", p.ID()).Msg("MCP plugin activated")
	return nil
}

func (p *McpPlugin) Deactivate() error {
	p.active = false
	return nil
}

// RegisterExternalTools allows other plugins to push tools into the MCP server.
// These tools appear in stdio, REST, and CollectMcpTools responses.
func (p *McpPlugin) RegisterExternalTools(tools []plugins.McpToolDefinition) {
	p.mu.Lock()
	defer p.mu.Unlock()
	p.externalTools = append(p.externalTools, tools...)
}

// ExternalTools returns a copy of all registered external tools.
func (p *McpPlugin) ExternalTools() []plugins.McpToolDefinition {
	p.mu.RLock()
	defer p.mu.RUnlock()
	out := make([]plugins.McpToolDefinition, len(p.externalTools))
	copy(out, p.externalTools)
	return out
}

func (p *McpPlugin) Commands() []plugins.Command {
	return []plugins.Command{
		{Name: "mcp:start", Description: "Start MCP server", Handler: p.cmdStart},
		{Name: "mcp:init", Description: "Init MCP in workspace", Handler: p.cmdInit},
	}
}

func (p *McpPlugin) cmdStart(args []string) error {
	ws := p.workspace
	if len(args) > 0 {
		ws = args[0]
	}
	cmd := exec.Command("orchestra-mcp", "--workspace", ws)
	cmd.Stdout = nil
	cmd.Stderr = nil
	return cmd.Start()
}

func (p *McpPlugin) cmdInit(args []string) error {
	ws := p.workspace
	if len(args) > 0 {
		ws = args[0]
	}
	out, err := exec.Command("orchestra-mcp", "init", "--workspace", ws).CombinedOutput()
	if err != nil {
		return fmt.Errorf("init failed: %w\n%s", err, out)
	}
	return nil
}

// Compile-time interface assertions.
var (
	_ plugins.Plugin         = (*McpPlugin)(nil)
	_ plugins.HasConfig      = (*McpPlugin)(nil)
	_ plugins.HasCommands    = (*McpPlugin)(nil)
	_ plugins.HasFeatureFlag = (*McpPlugin)(nil)
	_ plugins.HasMcpTools    = (*McpPlugin)(nil)
	_ plugins.HasRoutes      = (*McpPlugin)(nil)
)
