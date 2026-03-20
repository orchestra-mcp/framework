---
id: PLAN-CEK
project_slug: orchestra-agents
status: in-progress
title: Auto-Connect Tunnel with User Account — Claude Code Bridge + Terminal Only
type: plan
---

# Auto-Connect Tunnel with User Account — Claude Code Bridge + Terminal Only

## Problem

The current tunnel flow requires manual steps: generate token → copy to web → wait for claim → connect. Users want a seamless experience where `orchestra serve` auto-connects to the cloud using their stored credentials (`~/.orchestra/auth.json`), exposing only Claude Code bridge and Terminal capabilities.

## Current Flow (manual)
1. `orchestra serve --web-gate :9201 --cloud-url https://...`
2. CLI generates registration token, displays it
3. User copies token to web app → POST /api/tunnels/register
4. CLI polls POST /api/tunnels/claim with nonce
5. Gets tunnel_id + connection_token
6. Establishes reverse WebSocket

## New Flow (auto)
1. `orchestra serve --web-gate :9201 --cloud-url https://...`
2. CLI reads JWT from `~/.orchestra/auth.json` (sync-cloud auth manager)
3. CLI calls POST /api/tunnels/auto-register with JWT + machine info (no token paste needed)
4. Server creates/updates tunnel, returns tunnel_id + connection_token
5. CLI immediately establishes reverse WebSocket
6. Tunnel only exposes: `tools/call` (Claude Code bridge) + terminal relay
7. If not logged in, falls back to existing manual token flow

## Features

### FEAT 1: Auto-register API endpoint (web backend)
**File**: `apps/web/internal/handlers/tunnels.go`
- New endpoint: POST /api/tunnels/auto-register (authenticated)
- Accepts machine info directly in JSON body (no base64 token needed)
- Upserts tunnel by (user_id, hostname, workspace) — reuses existing tunnel if same machine reconnects
- Returns tunnel_id + connection_token
- Route: add to protected group in routes.go

### FEAT 2: CLI auto-connect on serve (Go CLI)
**Files**: `libs/cli/internal/serve.go`, `libs/cli/internal/inprocess/auto_tunnel.go`
- On startup with `--cloud-url`, check if user is authenticated via sync-cloud auth manager
- If authenticated: call POST /api/tunnels/auto-register with JWT + machine metadata
- Get tunnel_id + connection_token immediately (no polling)
- Start reverse WebSocket connection
- If NOT authenticated: fall back to existing manual token flow (backwards compatible)
- Export auth manager from sync-cloud plugin so serve.go can check `IsAuthenticated()` + `Token()`

### FEAT 3: Filter tunnel to Claude Code bridge + Terminal only
**File**: `libs/cli/internal/inprocess/reverse_tunnel.go`
- Add tool filtering: only expose tools matching a whitelist pattern
- Whitelist: `ai_prompt`, `spawn_session`, `kill_session`, `session_status`, `list_active` (Claude Code bridge tools) + terminal tools (`create_terminal`, `send_input`, `resize_terminal`, `close_terminal`, `terminal_stream`, `list_terminals`)
- `tools/list` returns only whitelisted tools
- `tools/call` rejects calls to non-whitelisted tools
- Add `terminal/data` relay method for real-time terminal I/O over the tunnel WebSocket

## Implementation Order
```
FEAT 1 (auto-register endpoint) → FEAT 2 (CLI auto-connect) → FEAT 3 (filter tools)
```

FEAT 1 and FEAT 3 can start in parallel. FEAT 2 depends on FEAT 1.
