package helpers

import (
	"encoding/json"

	"github.com/orchestra-mcp/mcp/src/types"
)

// TextResult creates a plain text tool result.
func TextResult(text string) *types.ToolResult {
	return &types.ToolResult{Content: []types.ContentBlock{{Type: "text", Text: text}}}
}

// JSONResult creates a JSON-formatted tool result.
func JSONResult(v any) *types.ToolResult {
	data, _ := json.MarshalIndent(v, "", "  ")
	return TextResult(string(data))
}

// ErrorResult creates an error tool result.
func ErrorResult(msg string) *types.ToolResult {
	return &types.ToolResult{
		Content: []types.ContentBlock{{Type: "text", Text: msg}},
		IsError: true,
	}
}
