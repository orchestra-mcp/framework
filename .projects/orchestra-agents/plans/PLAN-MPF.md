---
created_at: "2026-03-14T18:41:06Z"
description: |-
    Make Orchestra MCP production-ready by fixing all critical issues found during the 395-tool audit. Covers 10 features across 3 tiers: Critical (must-fix blockers), High Priority (stability & security), and Medium (observability & scalability).

    ## Audit Summary

    - **Total tools**: 395 across 37 plugins
    - **Pass rate**: 98% (154/157 loaded tools work)
    - **3 broken tools**: list_packs, get_pack, recommend_packs — all caused by pack registry JSON deserialization bug (array vs map mismatch)
    - **1 crash**: recommend_packs crashes the orchestrator process (connection reset by peer)

    ## Current Architecture Strengths

    - Clean plugin architecture with Builder pattern
    - CAS versioning on file writes prevents race conditions
    - Path traversal protection in storage layer
    - Session-scoped locking prevents concurrent feature edits
    - Gated workflow with evidence validation
    - 55 test files with solid unit coverage
    - Clear separation: tools → storage → transport

    ## Critical Issues (Tier 1 — Blockers)

    ### 1. Pack Registry Deserialization Bug
    - `libs/plugin-tools-marketplace/internal/storage/client.go` — `PackRegistry.Packs` is `map[string]*PackEntry` but registry JSON stores an array
    - Breaks: `list_packs`, `get_pack`, `recommend_packs`
    - `recommend_packs` crashes the entire orchestrator (panic without recovery)
    - Fix: Handle both array and map formats during deserialization, migrate registry on write

    ### 2. No Panic Recovery in Tool Dispatch
    - External plugin panics propagate up and crash the in-process router
    - `libs/cli/internal/inprocess/router.go` — no `defer recover()` wrapper on tool calls
    - Any single tool panic takes down ALL 395 tools
    - Fix: Add `defer recover()` in `callTool()` that returns an error response instead of crashing

    ### 3. Silent Error Suppression
    - `storage.go:158` — `_ = os.Remove(versionPath)` silently ignores delete failures
    - `storage.go:185` — `walkErr` silently ignored in filepath.Walk
    - `paths.go:61-62` — `readVersion()` ignores parse errors, returns 0
    - `transport.go:120` — `_ = t.writeResponse(resp)` discards write errors
    - Fix: Log all suppressed errors, return errors where possible

    ### 4. No Context Timeout Enforcement
    - Functions accept `context.Context` but never check `ctx.Err()` or `select { case <-ctx.Done() }`
    - A hung storage operation or external plugin call blocks forever
    - Fix: Add context checks in all storage operations, external calls, and long-running loops

    ## High Priority Issues (Tier 2 — Stability & Security)

    ### 5. No Structured Logging
    - Uses `log.Printf()` everywhere — no request IDs, no correlation, no log levels
    - Can't debug issues across 36 plugins with plain stdout
    - StdioTransport logs without mutex protection (`transport.go:169`)
    - Fix: Replace with `log/slog` (stdlib), add request IDs, structured fields, log levels

    ### 6. Plaintext Credential Storage
    - `accounts.json` stores API keys (ANTHROPIC_API_KEY, etc.) in plaintext readable by any process
    - No token expiration handling, no secret rotation
    - Fix: Use OS keychain (macOS Keychain, Linux Secret Service, Windows Credential Manager) — the macOS integration plugin already exists

    ### 7. No Input Validation Bounds
    - No max length on: project IDs, feature titles, note bodies, search queries, storage paths
    - Type casting helpers (`GetString()`, `GetInt()`) silently return zero values on mismatch
    - `List()` pattern passed directly to `filepath.Match()` without sanitization (glob injection)
    - Fix: Add max length constants, validate all inputs, sanitize glob patterns

    ### 8. No Rate Limiting
    - Any client can spam tools with unlimited requests
    - Pack installation could DOS with recursive git clones
    - No throttling on concurrent requests
    - Fix: Add per-session token bucket rate limiter (e.g., 100 calls/min default, configurable)

    ## Medium Priority Issues (Tier 3 — Scalability & Observability)

    ### 9. Missing Pagination on List Operations
    - `list_features` returns ALL features at once (63 in orchestra-web, could be thousands)
    - `list_notes`, `list_sessions`, `list_plans` — same issue
    - Fix: Add cursor-based pagination with `limit` and `offset` params to all list tools

    ### 10. No Observability / Telemetry
    - No request tracing, metrics, or spans
    - No way to measure tool latency, error rates, or usage patterns
    - No health checks that verify plugin dependencies
    - Fix: Add OpenTelemetry spans to tool dispatch, expose /metrics endpoint, add dependency health checks

    ## Feature Dependency Order

    ```
    FEAT-1: Pack Registry Bug Fix (no deps)
    FEAT-2: Panic Recovery (no deps)
    FEAT-3: Silent Error Fix (no deps)
    FEAT-4: Context Timeout Enforcement (no deps)
    FEAT-5: Structured Logging (depends on FEAT-3)
    FEAT-6: Credential Encryption (no deps)
    FEAT-7: Input Validation (no deps)
    FEAT-8: Rate Limiting (depends on FEAT-5 for logging)
    FEAT-9: Pagination (no deps)
    FEAT-10: Observability (depends on FEAT-5 for structured logging)
    ```

    ## Estimated Size

    | Feature | Estimate | Files Touched |
    |---------|----------|---------------|
    | Pack Registry Fix | S | 2-3 files in plugin-tools-marketplace |
    | Panic Recovery | S | 1-2 files in cli/inprocess |
    | Silent Error Fix | S | 3-4 files in storage-markdown, transport-stdio |
    | Context Timeouts | M | 5-8 files across storage, transport, router |
    | Structured Logging | M | 10-15 files across all core plugins |
    | Credential Encryption | M | 3-5 files in tools-agentops + new keychain wrapper |
    | Input Validation | M | 8-12 files across sdk-go helpers, tools-features |
    | Rate Limiting | S | 2-3 files, new middleware in router |
    | Pagination | M | 6-10 files across tools-features, tools-notes, tools-sessions |
    | Observability | L | 10-15 files, new telemetry package |
features:
    - FEAT-WNY
    - FEAT-YTD
    - FEAT-YTQ
    - FEAT-JBJ
    - FEAT-BJU
    - FEAT-BTW
    - FEAT-ZHZ
    - FEAT-NDX
    - FEAT-QXB
    - FEAT-LDT
id: PLAN-MPF
project_id: orchestra-pro
status: completed
title: Orchestra MCP Production Hardening
updated_at: "2026-03-14T20:28:05Z"
version: 4
---

# Orchestra MCP Production Hardening

Make Orchestra MCP production-ready by fixing all critical issues found during the 395-tool audit. Covers 10 features across 3 tiers: Critical (must-fix blockers), High Priority (stability & security), and Medium (observability & scalability).

## Audit Summary

- **Total tools**: 395 across 37 plugins
- **Pass rate**: 98% (154/157 loaded tools work)
- **3 broken tools**: list_packs, get_pack, recommend_packs — all caused by pack registry JSON deserialization bug (array vs map mismatch)
- **1 crash**: recommend_packs crashes the orchestrator process (connection reset by peer)

## Current Architecture Strengths

- Clean plugin architecture with Builder pattern
- CAS versioning on file writes prevents race conditions
- Path traversal protection in storage layer
- Session-scoped locking prevents concurrent feature edits
- Gated workflow with evidence validation
- 55 test files with solid unit coverage
- Clear separation: tools → storage → transport

## Critical Issues (Tier 1 — Blockers)

### 1. Pack Registry Deserialization Bug
- `libs/plugin-tools-marketplace/internal/storage/client.go` — `PackRegistry.Packs` is `map[string]*PackEntry` but registry JSON stores an array
- Breaks: `list_packs`, `get_pack`, `recommend_packs`
- `recommend_packs` crashes the entire orchestrator (panic without recovery)
- Fix: Handle both array and map formats during deserialization, migrate registry on write

### 2. No Panic Recovery in Tool Dispatch
- External plugin panics propagate up and crash the in-process router
- `libs/cli/internal/inprocess/router.go` — no `defer recover()` wrapper on tool calls
- Any single tool panic takes down ALL 395 tools
- Fix: Add `defer recover()` in `callTool()` that returns an error response instead of crashing

### 3. Silent Error Suppression
- `storage.go:158` — `_ = os.Remove(versionPath)` silently ignores delete failures
- `storage.go:185` — `walkErr` silently ignored in filepath.Walk
- `paths.go:61-62` — `readVersion()` ignores parse errors, returns 0
- `transport.go:120` — `_ = t.writeResponse(resp)` discards write errors
- Fix: Log all suppressed errors, return errors where possible

### 4. No Context Timeout Enforcement
- Functions accept `context.Context` but never check `ctx.Err()` or `select { case <-ctx.Done() }`
- A hung storage operation or external plugin call blocks forever
- Fix: Add context checks in all storage operations, external calls, and long-running loops

## High Priority Issues (Tier 2 — Stability & Security)

### 5. No Structured Logging
- Uses `log.Printf()` everywhere — no request IDs, no correlation, no log levels
- Can't debug issues across 36 plugins with plain stdout
- StdioTransport logs without mutex protection (`transport.go:169`)
- Fix: Replace with `log/slog` (stdlib), add request IDs, structured fields, log levels

### 6. Plaintext Credential Storage
- `accounts.json` stores API keys (ANTHROPIC_API_KEY, etc.) in plaintext readable by any process
- No token expiration handling, no secret rotation
- Fix: Use OS keychain (macOS Keychain, Linux Secret Service, Windows Credential Manager) — the macOS integration plugin already exists

### 7. No Input Validation Bounds
- No max length on: project IDs, feature titles, note bodies, search queries, storage paths
- Type casting helpers (`GetString()`, `GetInt()`) silently return zero values on mismatch
- `List()` pattern passed directly to `filepath.Match()` without sanitization (glob injection)
- Fix: Add max length constants, validate all inputs, sanitize glob patterns

### 8. No Rate Limiting
- Any client can spam tools with unlimited requests
- Pack installation could DOS with recursive git clones
- No throttling on concurrent requests
- Fix: Add per-session token bucket rate limiter (e.g., 100 calls/min default, configurable)

## Medium Priority Issues (Tier 3 — Scalability & Observability)

### 9. Missing Pagination on List Operations
- `list_features` returns ALL features at once (63 in orchestra-web, could be thousands)
- `list_notes`, `list_sessions`, `list_plans` — same issue
- Fix: Add cursor-based pagination with `limit` and `offset` params to all list tools

### 10. No Observability / Telemetry
- No request tracing, metrics, or spans
- No way to measure tool latency, error rates, or usage patterns
- No health checks that verify plugin dependencies
- Fix: Add OpenTelemetry spans to tool dispatch, expose /metrics endpoint, add dependency health checks

## Feature Dependency Order

```
FEAT-1: Pack Registry Bug Fix (no deps)
FEAT-2: Panic Recovery (no deps)
FEAT-3: Silent Error Fix (no deps)
FEAT-4: Context Timeout Enforcement (no deps)
FEAT-5: Structured Logging (depends on FEAT-3)
FEAT-6: Credential Encryption (no deps)
FEAT-7: Input Validation (no deps)
FEAT-8: Rate Limiting (depends on FEAT-5 for logging)
FEAT-9: Pagination (no deps)
FEAT-10: Observability (depends on FEAT-5 for structured logging)
```

## Estimated Size

| Feature | Estimate | Files Touched |
|---------|----------|---------------|
| Pack Registry Fix | S | 2-3 files in plugin-tools-marketplace |
| Panic Recovery | S | 1-2 files in cli/inprocess |
| Silent Error Fix | S | 3-4 files in storage-markdown, transport-stdio |
| Context Timeouts | M | 5-8 files across storage, transport, router |
| Structured Logging | M | 10-15 files across all core plugins |
| Credential Encryption | M | 3-5 files in tools-agentops + new keychain wrapper |
| Input Validation | M | 8-12 files across sdk-go helpers, tools-features |
| Rate Limiting | S | 2-3 files, new middleware in router |
| Pagination | M | 6-10 files across tools-features, tools-notes, tools-sessions |
| Observability | L | 10-15 files, new telemetry package |
