package types

// ToolDefinition describes a single MCP tool.
type ToolDefinition struct {
	Name        string      `json:"name"`
	Description string      `json:"description"`
	InputSchema InputSchema `json:"inputSchema"`
}

// InputSchema is the JSON Schema for tool input.
type InputSchema struct {
	Type       string         `json:"type"`
	Properties map[string]any `json:"properties,omitempty"`
	Required   []string       `json:"required,omitempty"`
}

// ToolResult is returned by tool handlers.
type ToolResult struct {
	Content []ContentBlock `json:"content"`
	IsError bool           `json:"isError,omitempty"`
}

// ContentBlock is a single content item in a tool result.
type ContentBlock struct {
	Type string `json:"type"`
	Text string `json:"text"`
}

// ToolHandler processes a tool call and returns a result.
type ToolHandler func(args map[string]any) (*ToolResult, error)

// Tool pairs a definition with its handler.
type Tool struct {
	Definition ToolDefinition
	Handler    ToolHandler
}
