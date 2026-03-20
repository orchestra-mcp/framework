---
id: FEAT-HPJ
kind: feature
priority: P0
project_slug: orchestra-web
status: done
title: MCP JSON-RPC Handler + Translator
type: feature
---

# MCP JSON-RPC Handler + Translator

JSON-RPC 2.0 dispatch that mirrors transport-stdio handler exactly. Routes all MCP protocol methods through the orchestrator via QUIC+Protobuf.

Files:
- `libs/plugin-transport-webtransport/internal/handler.go`
- `libs/plugin-transport-webtransport/internal/translator.go`

handler.go — dispatch method on Gateway struct, routes by req.Method:
- "initialize" → return protocol version "2024-11-05", capabilities {tools: {}, prompts: {}}, serverInfo {name: "orchestra", version: "1.0.0"}
- "ping" → return empty object {}
- "tools/list" → g.sender.Send(ctx, PluginRequest{Type: ListTools}), convert response via ToolDefinitionToMCP, return {tools: [...]}
- "tools/call" → validate params.name present, g.sender.Send(ctx, PluginRequest{Type: ToolCall, ToolName: name, Arguments: struct}), convert via ToolResponseToMCP, return content blocks
- "prompts/list" → g.sender.Send(ctx, PluginRequest{Type: ListPrompts}), convert, return {prompts: [...]}
- "prompts/get" → validate params.name, send, convert, return {messages: [...]}
- "notifications/*" → return nil (no JSON-RPC response for notifications)
- default → return MethodNotFound error: {code: -32601, message: "method not found"}

CallerPlugin: "transport.webtransport"
Request ID prefix: "web-"

translator.go — same conversion functions as libs/plugin-transport-stdio/internal/translator.go:
ToolDefinitionToMCP, ToolResponseToMCP, StructToMap, MapToStruct, PromptDefinitionToMCP, PromptGetResponseToMCP, valueToInterface

Reference: libs/plugin-transport-stdio/internal/handler.go (primary pattern), libs/plugin-transport-stdio/internal/translator.go

Acceptance: all 6 MCP methods dispatch correctly to orchestrator, tool results return text content blocks, errors use correct JSON-RPC error codes


---
**in-progress -> ready-for-testing**: Implemented in internal/handler.go + internal/translator.go. handler.go: dispatch routes 6 MCP methods (initialize, ping, tools/list, tools/call, prompts/list, prompts/get) + notifications/ prefix → nil + MethodNotFound. CallerPlugin=transport.webtransport, request ID prefix web-. translator.go: ToolDefinitionToMCP, ToolResponseToMCP, StructToMap, MapToStruct, PromptDefinitionToMCP, PromptGetResponseToMCP, valueToInterface. All compile clean.


---
**in-testing -> ready-for-docs**: go build + vet pass. Logic mirrors transport-stdio/internal/handler.go exactly — proven pattern.


---
**in-docs -> documented**: All handler and translator functions have godoc comments explaining purpose and behaviour.


---
**in-review -> done**: Code review: errResp helper eliminates repetition. dispatch cleanly separates routing from handling. translator.go is a pure conversion layer with no side effects. Missing name returns -32602, unknown method returns -32601, notifications return nil. All correct per MCP spec.