package providers

import (
	"encoding/json"
	"fmt"

	"github.com/gofiber/fiber/v3"
	"github.com/orchestra-mcp/framework/app/plugins"
	"github.com/orchestra-mcp/mcp/src/tools"
	t "github.com/orchestra-mcp/mcp/src/types"
)

// allTools returns all built-in MCP tools for the configured workspace.
func (p *McpPlugin) builtinTools() []t.Tool {
	ws := p.workspace
	var all []t.Tool
	all = append(all, tools.Project(ws)...)
	all = append(all, tools.Epic(ws)...)
	all = append(all, tools.Story(ws)...)
	all = append(all, tools.Task(ws)...)
	all = append(all, tools.Workflow(ws)...)
	all = append(all, tools.Prd(ws)...)
	all = append(all, tools.Bugfix(ws)...)
	all = append(all, tools.Usage(ws)...)
	all = append(all, tools.Readme(ws)...)
	all = append(all, tools.Artifacts(ws)...)
	return all
}

// externalAsTools converts external McpToolDefinitions to internal Tool structs.
func (p *McpPlugin) externalAsTools() []t.Tool {
	ext := p.ExternalTools()
	out := make([]t.Tool, len(ext))
	for i, def := range ext {
		handler := def.Handler
		out[i] = t.Tool{
			Definition: t.ToolDefinition{
				Name:        def.Name,
				Description: def.Description,
				InputSchema: t.InputSchema{Type: "object", Properties: def.InputSchema},
			},
			Handler: func(args map[string]any) (*t.ToolResult, error) {
				res, err := handler(args)
				if err != nil {
					return nil, err
				}
				if tr, ok := res.(*t.ToolResult); ok {
					return tr, nil
				}
				return &t.ToolResult{
					Content: []t.ContentBlock{{Type: "text", Text: fmt.Sprintf("%v", res)}},
				}, nil
			},
		}
	}
	return out
}

// allTools returns built-in + external tools.
func (p *McpPlugin) allTools() []t.Tool {
	all := p.builtinTools()
	all = append(all, p.externalAsTools()...)
	return all
}

// McpTools bridges internal tools to the plugin system's McpToolDefinition.
func (p *McpPlugin) McpTools() []plugins.McpToolDefinition {
	internal := p.allTools()
	defs := make([]plugins.McpToolDefinition, len(internal))
	for i, tool := range internal {
		handler := tool.Handler
		defs[i] = plugins.McpToolDefinition{
			Name:        tool.Definition.Name,
			Description: tool.Definition.Description,
			InputSchema: toSchemaMap(tool.Definition.InputSchema),
			Handler: func(input map[string]any) (any, error) {
				return handler(input)
			},
		}
	}
	return defs
}

// RegisterRoutes adds REST API endpoints for all MCP tools.
func (p *McpPlugin) RegisterRoutes(router fiber.Router) {
	mcp := router.Group("/mcp")

	// GET /api/mcp/tools — list all available tools.
	mcp.Get("/tools", func(c fiber.Ctx) error {
		internal := p.allTools()
		defs := make([]t.ToolDefinition, len(internal))
		for i, tool := range internal {
			defs[i] = tool.Definition
		}
		return c.JSON(fiber.Map{"tools": defs, "count": len(defs)})
	})

	// POST /api/mcp/tools/call — call a tool by name.
	mcp.Post("/tools/call", func(c fiber.Ctx) error {
		var req struct {
			Name      string         `json:"name"`
			Arguments map[string]any `json:"arguments"`
		}
		if err := c.Bind().JSON(&req); err != nil {
			return c.Status(400).JSON(fiber.Map{"error": "invalid request body"})
		}
		toolMap := make(map[string]t.Tool)
		for _, tool := range p.allTools() {
			toolMap[tool.Definition.Name] = tool
		}
		tool, ok := toolMap[req.Name]
		if !ok {
			return c.Status(404).JSON(fiber.Map{"error": "unknown tool: " + req.Name})
		}
		result, err := tool.Handler(req.Arguments)
		if err != nil {
			return c.Status(500).JSON(fiber.Map{"error": err.Error()})
		}
		return c.JSON(result)
	})
}

func toSchemaMap(schema t.InputSchema) map[string]any {
	data, _ := json.Marshal(schema)
	var m map[string]any
	_ = json.Unmarshal(data, &m)
	return m
}
