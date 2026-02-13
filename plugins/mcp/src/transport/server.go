package transport

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"

	"github.com/orchestra-mcp/mcp/src/types"
)

const maxScanSize = 10 * 1024 * 1024 // 10MB

// MCPServer handles the stdio JSON-RPC transport.
type MCPServer struct {
	name    string
	version string
	tools   map[string]types.Tool
}

// New creates an MCPServer with the given name and version.
func New(name, version string) *MCPServer {
	return &MCPServer{name: name, version: version, tools: make(map[string]types.Tool)}
}

// RegisterTool adds a single tool to the server.
func (s *MCPServer) RegisterTool(t types.Tool) {
	s.tools[t.Definition.Name] = t
}

// RegisterTools adds multiple tools to the server.
func (s *MCPServer) RegisterTools(tools []types.Tool) {
	for _, t := range tools {
		s.RegisterTool(t)
	}
}

// GetTools returns all registered tool definitions.
func (s *MCPServer) GetTools() []types.ToolDefinition {
	defs := make([]types.ToolDefinition, 0, len(s.tools))
	for _, t := range s.tools {
		defs = append(defs, t.Definition)
	}
	return defs
}

// Run starts the stdio JSON-RPC loop.
func (s *MCPServer) Run() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Buffer(make([]byte, 0, maxScanSize), maxScanSize)
	for scanner.Scan() {
		line := scanner.Bytes()
		if len(line) == 0 {
			continue
		}
		var req types.JSONRPCRequest
		if err := json.Unmarshal(line, &req); err != nil {
			fmt.Fprintf(os.Stderr, "parse error: %v\n", err)
			continue
		}
		s.handleRequest(&req)
	}
}

func (s *MCPServer) handleRequest(req *types.JSONRPCRequest) {
	switch req.Method {
	case "initialize":
		s.writeResult(req.ID, types.InitializeResult{
			ProtocolVersion: "2024-11-05",
			Capabilities:    types.ServerCaps{Tools: map[string]any{}},
			ServerInfo:      types.ServerInfo{Name: s.name, Version: s.version},
		})
	case "notifications/initialized":
		// no response for notifications
	case "tools/list":
		s.writeResult(req.ID, types.ListToolsResult{Tools: s.GetTools()})
	case "tools/call":
		s.handleToolCall(req)
	case "ping":
		s.writeResult(req.ID, map[string]any{})
	default:
		s.writeError(req.ID, -32601, "method not found: "+req.Method)
	}
}

func (s *MCPServer) handleToolCall(req *types.JSONRPCRequest) {
	var params types.CallToolParams
	if err := json.Unmarshal(req.Params, &params); err != nil {
		s.writeError(req.ID, -32602, "invalid params")
		return
	}
	tool, ok := s.tools[params.Name]
	if !ok {
		s.writeError(req.ID, -32601, "unknown tool: "+params.Name)
		return
	}
	result, err := tool.Handler(params.Arguments)
	if err != nil {
		s.writeError(req.ID, -32000, err.Error())
		return
	}
	s.writeResult(req.ID, result)
}

func (s *MCPServer) writeResult(id, result any) {
	resp := types.JSONRPCResponse{JSONRPC: "2.0", ID: id, Result: result}
	data, _ := json.Marshal(resp)
	fmt.Fprintf(os.Stdout, "%s\n", data)
}

func (s *MCPServer) writeError(id any, code int, msg string) {
	resp := types.JSONRPCResponse{
		JSONRPC: "2.0", ID: id,
		Error: &types.JSONRPCError{Code: code, Message: msg},
	}
	data, _ := json.Marshal(resp)
	fmt.Fprintf(os.Stdout, "%s\n", data)
}
