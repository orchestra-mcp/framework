package transport_test

import (
	"testing"

	"github.com/orchestra-mcp/mcp/src/transport"
	"github.com/orchestra-mcp/mcp/src/types"
)

func TestNewServerAndRegisterTool(t *testing.T) {
	s := transport.New("test-server", "1.0.0")
	if defs := s.GetTools(); len(defs) != 0 {
		t.Errorf("tools should be empty, got %d", len(defs))
	}

	tool := types.Tool{
		Definition: types.ToolDefinition{Name: "my_tool", Description: "A tool"},
		Handler:    func(args map[string]any) (*types.ToolResult, error) { return nil, nil },
	}
	s.RegisterTool(tool)

	defs := s.GetTools()
	if len(defs) != 1 {
		t.Fatalf("tools count = %d, want 1", len(defs))
	}
	if defs[0].Name != "my_tool" {
		t.Errorf("tool name = %q, want my_tool", defs[0].Name)
	}
}

func TestRegisterTools(t *testing.T) {
	s := transport.New("s", "0.1")
	tools := []types.Tool{
		{Definition: types.ToolDefinition{Name: "a"}, Handler: func(map[string]any) (*types.ToolResult, error) { return nil, nil }},
		{Definition: types.ToolDefinition{Name: "b"}, Handler: func(map[string]any) (*types.ToolResult, error) { return nil, nil }},
	}
	s.RegisterTools(tools)
	if len(s.GetTools()) != 2 {
		t.Errorf("tools count = %d, want 2", len(s.GetTools()))
	}
}

func TestGetToolsReturnsDefinitions(t *testing.T) {
	s := transport.New("s", "0.1")
	s.RegisterTool(types.Tool{
		Definition: types.ToolDefinition{Name: "x", Description: "desc"},
		Handler:    func(map[string]any) (*types.ToolResult, error) { return nil, nil },
	})
	defs := s.GetTools()
	if len(defs) != 1 || defs[0].Name != "x" {
		t.Errorf("GetTools = %+v", defs)
	}
}
