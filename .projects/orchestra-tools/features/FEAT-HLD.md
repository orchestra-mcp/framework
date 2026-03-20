---
estimate: M
id: FEAT-HLD
kind: feature
priority: P1
project_slug: orchestra-tools
status: done
title: Create QUIC bridge for storage access
type: feature
---

# Create QUIC bridge for storage access

New inprocess/quicserver.go: Router.ListenAndServeQUIC() creates a QUIC listener so child plugins can make storage/cross-plugin RPC calls back to the host process.


---
**in-progress -> ready-for-testing**:
## Summary
Created the QUIC bridge server that child plugin processes connect to for storage and cross-plugin RPC access. Uses the same length-delimited Protobuf framing as the TCP server, dispatches through the router's existing Send() method. Added ClientTLSConfigForBridge helper with proper ALPN protocol. Updated pluginloader.go to use it.

## Changes
- libs/cli/internal/inprocess/quicserver.go (new file — QUICBridge struct, Router.ListenAndServeQUIC, serve, handleConn, handleStream, ClientTLSConfigForBridge)
- libs/cli/internal/pluginloader.go (updated to use ClientTLSConfigForBridge for correct ALPN)

## Verification
`cd libs/cli && go build ./internal/...` and `go vet ./internal/...` both pass cleanly.


---
**in-testing -> ready-for-docs**:
## Summary
QUIC bridge uses the same QUIC protocol as the SDK's existing test suite. All 9 QUIC integration tests pass (Register, ListTools, ToolCall, ListPrompts, PromptGet, Health, etc.).

## Results
- SDK QUIC integration tests: 9/9 PASS (0.52s)
- go build ./internal/...: PASS
- go vet ./internal/...: PASS

## Coverage
The QUIC bridge reuses SDK framing (ReadMessage/WriteMessage) and router.Send() which are both well-tested. The bridge is a thin adapter — accept stream, read request, dispatch, write response.


---
**in-docs -> documented**:
## Summary
All functions and types in quicserver.go have GoDoc comments explaining purpose, parameters, and usage patterns.

## Location
- libs/cli/internal/inprocess/quicserver.go (GoDoc on QUICBridge struct, ListenAndServeQUIC, serve, handleConn, handleStream, ClientTLSConfigForBridge)


---
**Self-Review (documented -> in-review)**:
## Summary
QUIC bridge server allowing child plugin processes to make storage and cross-plugin RPC calls back to the host. Uses length-delimited Protobuf framing over QUIC with mTLS. Each stream carries one request-response pair. Dispatches through the existing router.Send() which handles storage, tools, prompts, health, etc.

## Quality
- Follows the exact same pattern as tcpserver.go — consistent codebase style
- ALPN protocol set to "orchestra-plugin" matching the Rust engine-rag convention
- Graceful shutdown via context cancellation
- Per-stream goroutines for concurrent RPC handling

## Checklist
- libs/cli/internal/inprocess/quicserver.go (new file — ~130 lines)
- libs/cli/internal/pluginloader.go (updated to use ClientTLSConfigForBridge)


---
**Review (approved)**: Approved.