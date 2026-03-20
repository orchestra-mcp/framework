---
id: FEAT-ZCC
kind: feature
priority: P0
project_slug: orchestra-web
status: done
title: Gateway Unit Tests (22 tests)
type: feature
---

# Gateway Unit Tests (22 tests)

Comprehensive test suite using httptest package + mockSender for orchestrator isolation.

File: `libs/plugin-transport-webtransport/internal/gateway_test.go`

Pattern: same as libs/plugin-transport-stdio/internal/transport_test.go
- mockSender struct implementing Sender interface, configurable return values
- Tests use httptest.NewRecorder() + http.NewRequest() pattern (not httptest.NewServer)

HTTP layer tests (8):
1. TestHealthEndpoint — GET /health returns 200 OK
2. TestCORSPreflight — OPTIONS /rpc returns 204 + Access-Control-Allow-Origin, Allow-Methods, Allow-Headers
3. TestCORSHeaders — POST /rpc response includes CORS headers
4. TestRPCInvalidContentType — Content-Type: text/plain returns 415
5. TestRPCEmptyBody — empty body returns {error: {code: -32700, message: "parse error"}}
6. TestRPCInvalidJSON — malformed JSON returns parse error
7. TestAuthRequired — POST /rpc without Authorization returns 401 when apiKey is set
8. TestAuthSuccess — correct Bearer token proceeds to dispatch

Handler tests (8):
9. TestInitialize — verify ProtocolVersion "2024-11-05", Capabilities contains tools+prompts, ServerInfo.Name "orchestra"
10. TestPing — verify Result is empty object {}
11. TestToolsList — mockSender returns 2 tools, verify MCPToolDefinition conversion
12. TestToolsCall — mockSender returns success, verify content blocks in response
13. TestToolsCallError — mockSender returns error, verify isError content block
14. TestToolsCallMissingName — params without name field returns -32602 InvalidParams
15. TestMethodNotFound — "unknown/method" returns -32601
16. TestNotification — "notifications/something" returns nil (no response written)

Translator tests (4):
17. TestStructToMap — round-trip: MapToStruct -> StructToMap gives identical map
18. TestToolDefinitionToMCP — protobuf ToolDefinition converts to MCPToolDefinition correctly
19. TestToolResponseToMCPSuccess — success result produces text content block
20. TestToolResponseToMCPError — error result produces isError: true content block

Prompt tests (2):
21. TestPromptsList — verify prompt list conversion from protobuf
22. TestPromptsGet — verify prompt get forwarding with arguments

Acceptance: go test ./libs/plugin-transport-webtransport/... -v — all 22 tests pass


---
**in-progress -> ready-for-testing**: 22/22 tests pass. go test ./libs/plugin-transport-webtransport/... -v: all PASS. Covers: HTTP layer (health, CORS preflight, CORS headers on response, invalid content-type, empty body, invalid JSON, auth required, auth success), handler (initialize, ping, tools/list, tools/call, tools/call error, tools/call missing name, method not found, notification), translator (StructToMap, ToolDefinitionToMCP, ToolResponseToMCPSuccess, ToolResponseToMCPError), prompts (list, get).


---
**in-testing -> ready-for-docs**: 22/22 tests pass. Covers all 4 categories: HTTP layer (8), handler dispatch (8), translator (2), prompts (2). Uses httptest.NewRecorder pattern. mockSender isolates tests from QUIC. fstest.MapFS provides in-memory dist/ FS.


---
**in-docs -> documented**: Each test is numbered and titled. Helper functions doRPC, parseRPCResponse, newTestGateway have clear names. Test sections are commented by category.


---
**in-review -> done**: Reviewed: tests use httptest.NewRecorder (no real network). mockSender is configurable per-test. testFS uses fstest.MapFS (in-memory, no disk I/O). Notification test correctly asserts 204 + empty body. Auth tests verify both reject and accept paths. CallerPlugin assertion in TestToolsCall verifies correct plugin identity is forwarded.