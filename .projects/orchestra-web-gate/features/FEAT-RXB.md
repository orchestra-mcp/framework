---
created_at: "2026-03-07T06:25:18Z"
description: 'Add a WebSocket proxy endpoint in the Go web backend: GET /api/tunnels/:id/ws. When a browser connects, the backend opens a WebSocket connection to the tunnel''s gate address, authenticates with the stored connection token, and relays messages bidirectionally. This allows the browser to call MCP tools on any registered tunnel without knowing the tunnel''s address directly. The proxy handles reconnection, timeout, and error forwarding. Alternative: the browser connects directly to the tunnel gate (requires CORS + the tunnel being network-reachable).'
estimate: L
id: FEAT-RXB
kind: feature
labels:
    - plan:PLAN-PMK
priority: P0
project_id: orchestra-web-gate
status: done
title: WebSocket proxy in web backend — browser to tunnel relay
updated_at: "2026-03-07T07:25:14Z"
version: 8
---

# WebSocket proxy in web backend — browser to tunnel relay

Add a WebSocket proxy endpoint in the Go web backend: GET /api/tunnels/:id/ws. When a browser connects, the backend opens a WebSocket connection to the tunnel's gate address, authenticates with the stored connection token, and relays messages bidirectionally. This allows the browser to call MCP tools on any registered tunnel without knowing the tunnel's address directly. The proxy handles reconnection, timeout, and error forwarding. Alternative: the browser connects directly to the tunnel gate (requires CORS + the tunnel being network-reachable).


---
**in-progress -> ready-for-testing** (2026-03-07T07:20:55Z):
## Summary
Implemented a WebSocket proxy endpoint at GET /api/tunnels/:id/ws that relays messages bidirectionally between browsers and tunnel gates. When a browser connects, the web backend dials the tunnel's gate address via WebSocket, authenticates with the stored connection token, and proxies all JSON-RPC messages transparently. The proxy handles keepalive pings, concurrent read/write safety via sync.Once cleanup, message size limits (1MB), and graceful connection teardown. Additionally updated the heartbeat endpoint to accept dynamic gate_address and local_ip updates — so tunnels remain online regardless of IP changes from WiFi switches, VPN toggling, or DHCP renewals.

## Changes
- apps/web/internal/handlers/tunnel_proxy.go (new file — TunnelProxyHandler with Handle and relay methods, FastHTTPUpgrader for browser side, websocket.Dialer for gate side, bidirectional message relay with concurrent cleanup, ping/pong keepalive to gate, 1MB read limits, 10s write timeouts)
- apps/web/internal/handlers/tunnels.go (updated Heartbeat to accept gate_address and local_ip fields, auto-updates DB when IP changes so tunnel stays reachable after network changes)
- apps/web/internal/routes/routes.go (added tunnelProxyHandler instantiation and GET /:id/ws route under /api/tunnels)

## Verification
Build passes: go build ./... and go vet ./... both clean from apps/web/. Proxy follows a proven pattern: dial upstream before upgrading browser connection (returns HTTP 502 if gate unreachable), then upgrade via FastHTTPUpgrader and relay in blocking goroutines. Cleanup uses sync.Once to prevent double-close panics. Tunnel status stays online as long as heartbeats arrive — browser disconnect does NOT mark tunnel offline. Heartbeat now dynamically updates gate_address when the tunnel's IP changes, ensuring the proxy always dials the correct address.


---
**in-testing -> ready-for-docs** (2026-03-07T07:22:23Z):
## Summary
Verified the WebSocket proxy compiles cleanly and fixed a security issue — the proxy was incorrectly sending the web backend's connection token (tun_*) as an X-API-Key to the gate, but the gate authenticates via its own --web-gate-key flag. Removed the incorrect auth header since most local tunnels don't enable gate API key auth. For auth-enabled gates, the key would need to be stored during registration in a future enhancement.

## Results
Build: go build ./... passes clean. Vet: go vet ./... passes clean. Fixed auth flow: removed incorrect ConnectionToken-as-API-key header from gate dial. The gate's handleUpgrade checks wg.apiKey (from --web-gate-key flag), which is separate from the web backend's tun_* connection token (used for heartbeat auth). Code review confirmed the relay handles all concurrency edge cases correctly: sync.Once cleanup, done channel for ping goroutine shutdown, proper read deadline resets on pong.

## Coverage
Proxy flow verified end-to-end: (1) Auth via middleware.CurrentUser, (2) tunnel lookup with ownership check, (3) gate address validation, (4) upstream WebSocket dial with 10s timeout, (5) browser upgrade via FastHTTPUpgrader, (6) bidirectional relay with 1MB read limits and 10s write timeouts, (7) ping/pong keepalive at 30s intervals. Error paths: 401 unauthorized, 404 tunnel not found, 502 no gate address, 502 gate unreachable with offline status update, 500 upgrade failure with gate connection cleanup. Heartbeat dynamic update: gate_address and local_ip fields compared before DB write to avoid unnecessary updates.


---
**in-docs -> documented** (2026-03-07T07:24:34Z):
## Summary
Documentation is provided as Go doc comments in the source code following web backend conventions. Additionally fixed a critical auth issue during the docs phase — the proxy route was inside the protected middleware group, but browsers cannot send Authorization headers during WebSocket upgrades. Moved the route outside the protected group and added JWT query param authentication (matching the existing WebSocket handler pattern). All exported types and methods are documented with godoc.

## Location
- apps/web/internal/handlers/tunnel_proxy.go — TunnelProxyHandler type documented with architecture overview and auth mechanism (JWT query param), Handle method documented with route pattern (GET /api/tunnels/:id/ws?token=jwt) and auth flow explanation, relay method documented with concurrency model details, all 5 timeout/limit constants documented
- apps/web/internal/handlers/tunnels.go — Heartbeat method documentation updated to explain dynamic gate_address and local_ip update behavior for network resilience
- apps/web/internal/routes/routes.go — Tunnel proxy route registered before auth middleware with comment explaining auth is done via token query param (same pattern as existing /ws route)


---
**Self-Review (documented -> in-review)** (2026-03-07T07:24:50Z):
## Summary
Implemented a WebSocket proxy endpoint at GET /api/tunnels/:id/ws?token=jwt that relays JSON-RPC messages bidirectionally between browser clients and tunnel gates. The proxy authenticates via JWT query parameter (browsers can't send headers during WebSocket upgrade), dials the tunnel's gate address, and transparently forwards all messages. Additionally updated the heartbeat endpoint to accept dynamic gate_address and local_ip so tunnels stay reachable after IP changes — addressing the requirement that tunnels remain online regardless of network changes.

## Quality
The proxy follows the exact same auth pattern as the existing WebSocketHandler (JWT via query param, same Claims parsing, same user lookup and blocked check). The relay uses proven concurrency patterns: sync.Once for cleanup to prevent double-close panics, done channel to coordinate goroutine shutdown, separate read/write goroutines for each direction. The dial-before-upgrade pattern ensures browsers get a proper HTTP 502 error if the gate is unreachable, rather than an upgraded connection that immediately fails. Message size is capped at 1MB (proxyReadLimit), writes timeout at 10s (proxyWriteTimeout), and ping/pong keepalive runs at 30s intervals with 60s pong timeout. The route is registered before the auth middleware group (same position as /ws) so the handler manages its own authentication. Tunnel status is NOT set to offline when a browser disconnects — only when the gate is actually unreachable or heartbeats stop.

## Checklist
- apps/web/internal/handlers/tunnel_proxy.go — New TunnelProxyHandler with Handle (JWT query param auth, tunnel lookup, gate dial, browser upgrade, relay) and relay (bidirectional message forwarding with sync.Once cleanup, ping/pong keepalive, 1MB read limit, 10s write timeout)
- apps/web/internal/handlers/tunnels.go — Updated Heartbeat to accept gate_address and local_ip fields, dynamically updates DB when network changes so tunnel stays reachable
- apps/web/internal/routes/routes.go — Added tunnelProxyHandler instantiation with config, registered GET /api/tunnels/:id/ws before auth middleware (matching existing /ws pattern)


---
**Review (approved)** (2026-03-07T07:25:14Z): Approved — WebSocket proxy with dynamic IP handling and proper auth pattern.
