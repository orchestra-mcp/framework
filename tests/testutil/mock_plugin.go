package testutil

import (
	"github.com/gofiber/fiber/v3"
	"github.com/orchestra-mcp/framework/app/plugins"
	"github.com/orchestra-mcp/framework/config"
)

// MockPlugin implements plugins.Plugin and several Has* interfaces for testing.
type MockPlugin struct {
	PluginID      string
	PluginName    string
	PluginVersion string
	Deps          []string
	Active        bool
	Tools         []plugins.McpToolDefinition
	JobList       []plugins.JobDefinition
	MWList        []any
	RoutesCalled  bool
}

func (m *MockPlugin) ID() string             { return m.PluginID }
func (m *MockPlugin) Name() string           { return m.PluginName }
func (m *MockPlugin) Version() string        { return m.PluginVersion }
func (m *MockPlugin) Dependencies() []string { return m.Deps }
func (m *MockPlugin) IsActive() bool         { return m.Active }

func (m *MockPlugin) Activate(_ *plugins.PluginContext) error {
	m.Active = true
	return nil
}

func (m *MockPlugin) Deactivate() error {
	m.Active = false
	return nil
}

func (m *MockPlugin) RegisterRoutes(_ fiber.Router)         { m.RoutesCalled = true }
func (m *MockPlugin) McpTools() []plugins.McpToolDefinition { return m.Tools }
func (m *MockPlugin) Jobs() []plugins.JobDefinition         { return m.JobList }
func (m *MockPlugin) Middleware() []any                     { return m.MWList }

// NewMockPlugin creates a basic MockPlugin with the given ID.
func NewMockPlugin(id string) *MockPlugin {
	return &MockPlugin{PluginID: id, PluginName: id, PluginVersion: "1.0.0"}
}

// NewManager creates a PluginManager with the given disabled plugin IDs.
func NewManager(disabled ...string) *plugins.PluginManager {
	cfg := &config.PluginsConfig{
		Disabled:    disabled,
		StoragePath: "/tmp/storage",
		PluginsPath: "/tmp/plugins",
	}
	return plugins.NewPluginManager(cfg)
}
