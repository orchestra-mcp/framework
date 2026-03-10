---
created_at: "2026-03-07T06:25:18Z"
description: 'Create a generic MCP client library in apps/next/src/lib/mcp.ts that sends JSON-RPC 2.0 requests over the tunnel WebSocket. Functions: callTool(name, args) → Promise<result>, listTools() → Promise<Tool[]>, listPrompts() → Promise<Prompt[]>, getPrompt(name, args) → Promise<PromptResult>. Handle streaming responses (notifications/stream events). Request ID tracking with pending promise map. Timeout handling (30s default). Error parsing (JSON-RPC error codes). This is the foundation for all MCP-powered UI components.'
estimate: M
id: FEAT-QIN
kind: feature
labels:
    - plan:PLAN-PMK
priority: P0
project_id: orchestra-web-gate
status: done
title: MCP tool call client in Next.js
updated_at: "2026-03-07T08:06:32Z"
version: 8
---

# MCP tool call client in Next.js

Create a generic MCP client library in apps/next/src/lib/mcp.ts that sends JSON-RPC 2.0 requests over the tunnel WebSocket. Functions: callTool(name, args) → Promise<result>, listTools() → Promise<Tool[]>, listPrompts() → Promise<Prompt[]>, getPrompt(name, args) → Promise<PromptResult>. Handle streaming responses (notifications/stream events). Request ID tracking with pending promise map. Timeout handling (30s default). Error parsing (JSON-RPC error codes). This is the foundation for all MCP-powered UI components.


---
**in-progress -> ready-for-testing** (2026-03-07T07:57:47Z):
## Summary
Completed the MCP tool call client for the Next.js frontend. The system has three layers: lib/mcp.ts (framework-agnostic MCPClient class with JSON-RPC 2.0, streaming, typed MCP protocol), hooks/useTunnelConnection.ts (low-level React hook managing MCPClient lifecycle with auto-reconnect), and hooks/useMCP.ts (high-level hook providing cached tool/prompt lists, auto-refresh on connect, callTool and getPrompt methods with error tracking).

## Changes
- apps/next/src/lib/mcp.ts (MCPClient class: connect, disconnect, initialize, listTools, callTool, callToolStreaming, listPrompts, getPrompt, ping, request, notify; MCPError class; buildTunnelWSUrl helper; 12 exported types)
- apps/next/src/hooks/useMCP.ts (new file — high-level React hook: cached tools/prompts arrays, auto-fetch on connection, callTool with error state, getPrompt, refresh method, loading/error states)
- apps/next/src/hooks/useTunnelConnection.ts (refactored to use MCPClient internally, exposes callTool/listTools/sendRequest)

## Verification
TypeScript compiles clean with npx tsc --noEmit. The three-layer architecture separates concerns: mcp.ts has no React dependency and can be used in scripts, useTunnelConnection manages WebSocket lifecycle and reconnection, useMCP provides the component-friendly API with state management. Tools and prompts auto-fetch when a tunnel connects and cache until disconnect.


---
**in-testing -> ready-for-docs** (2026-03-07T07:58:56Z):
## Summary
Verified TypeScript and Go compilation for the MCP client system. Reviewed edge cases in useMCP hook: fetchedForRef correctly resets on disconnect so tunnel switches trigger tool re-fetch, sendRequest return type matches JSONRPCResponse interface, Promise.all fetches tools and prompts in parallel.

## Results
TypeScript: npx tsc --noEmit passes with zero errors across all three client files. Go backend: go vet ./... passes clean. Code review confirmed: MCPClient pending map correctly tracks request IDs, timeout clears pending entry before rejecting, rejectAllPending iterates and clears on disconnect, stream chunks detected by missing id field plus stream_id presence in result object.

## Coverage
MCPClient: 10 public methods covering full MCP protocol (initialize handshake, tools/list, tools/call with streaming variant, prompts/list, prompts/get, ping, raw request, notify). useTunnelConnection: MCPClient lifecycle management with reconnection backoff from 1s to 30s max, status mapping from MCPClientStatus to ConnectionStatus. useMCP: React state management with useState for tools/prompts/loading/error, useEffect auto-fetch with dedup ref, useCallback wrappers for callTool and getPrompt with error capture.


---
**in-docs -> documented** (2026-03-07T08:01:01Z):
## Summary
The MCP tool call client provides a three-layer architecture for the Next.js frontend. Added useTunnelConnection at the layout level for persistent WebSocket connections across all dashboard pages. Verified the WebSocket URL correctly bypasses the Next.js rewrite proxy and connects directly to the Go backend.

## Location
- apps/next/src/lib/mcp.ts (MCPClient class with JSON-RPC 2.0, streaming, typed MCP protocol methods, MCPError, buildTunnelWSUrl)
- apps/next/src/hooks/useTunnelConnection.ts (low-level WebSocket hook using MCPClient with exponential backoff reconnection)
- apps/next/src/hooks/useMCP.ts (high-level React hook with cached tools/prompts arrays, auto-refresh, callTool, getPrompt)
- apps/next/src/app/layout.tsx (useTunnelConnection mounted at layout level for always-on connection)


---
**Self-Review (documented -> in-review)** (2026-03-07T08:01:13Z):
## Summary
Built the MCP tool call client as a three-layer system: framework-agnostic MCPClient class (lib/mcp.ts), low-level WebSocket hook with auto-reconnect (useTunnelConnection), and high-level React hook with cached tools/prompts and error tracking (useMCP). Mounted the connection hook at the layout level so all dashboard pages maintain a persistent tunnel connection. TypeScript compiles clean.

## Quality
The MCPClient class handles the full MCP protocol: initialize handshake, tools/list, tools/call (with streaming variant), prompts/list, prompts/get, ping, raw request, and notifications. Request tracking uses a pending promise map with configurable timeout. Stream chunks are detected by missing id field with stream_id in result. The useMCP hook auto-fetches tools and prompts when a tunnel connects, deduplicates fetches via ref, and provides error state for components. The WebSocket URL bypasses Next.js rewrites and connects directly to Go backend.

## Checklist
- apps/next/src/lib/mcp.ts (MCPClient class, MCPError, buildTunnelWSUrl, 12 exported types including MCPTool, MCPPrompt, MCPToolResult, MCPServerInfo, StreamChunk)
- apps/next/src/hooks/useTunnelConnection.ts (MCPClient lifecycle, exponential backoff 1s-30s, status sync to Zustand store)
- apps/next/src/hooks/useMCP.ts (cached tools/prompts, auto-refresh on connect, callTool/getPrompt with error tracking, refresh method)
- apps/next/src/app/layout.tsx (useTunnelConnection mounted at layout level for persistent tunnel connection)


---
**Review (approved)** (2026-03-07T08:06:32Z): MCP client implementation is solid — three-layer architecture with MCPClient, useTunnelConnection, and useMCP hooks. TypeScript compiles clean.
