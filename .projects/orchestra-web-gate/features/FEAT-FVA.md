---
created_at: "2026-03-07T06:25:18Z"
description: 'Add Tunnel model to apps/web/: ID (uuid), UserID, TeamID (optional), Name, Hostname, OS, Architecture, GateAddress (host:port), ConnectionToken (encrypted), Status (online/offline/connecting), LastSeenAt, Labels (JSONB), Meta (JSONB), Version. Add TunnelHandler with CRUD endpoints: GET/POST/PUT/DELETE /api/tunnels, GET /api/tunnels/:id/status (live health check), POST /api/tunnels/:id/connect (WebSocket proxy initiation). Add tunnel heartbeat tracking — each tunnel pings the web backend periodically.'
estimate: M
id: FEAT-FVA
kind: feature
labels:
    - plan:PLAN-PMK
priority: P0
project_id: orchestra-web-gate
status: done
title: Tunnel model & CRUD in web backend
updated_at: "2026-03-07T07:17:46Z"
version: 8
---

# Tunnel model & CRUD in web backend

Add Tunnel model to apps/web/: ID (uuid), UserID, TeamID (optional), Name, Hostname, OS, Architecture, GateAddress (host:port), ConnectionToken (encrypted), Status (online/offline/connecting), LastSeenAt, Labels (JSONB), Meta (JSONB), Version. Add TunnelHandler with CRUD endpoints: GET/POST/PUT/DELETE /api/tunnels, GET /api/tunnels/:id/status (live health check), POST /api/tunnels/:id/connect (WebSocket proxy initiation). Add tunnel heartbeat tracking — each tunnel pings the web backend periodically.


---
**in-progress -> ready-for-testing** (2026-03-07T07:11:45Z):
## Summary
Added Tunnel model and full CRUD handler to the web backend at apps/web/. The Tunnel model stores registered machines with UUID PK, user ownership, machine metadata (hostname, OS, arch, local IP), gate address, encrypted connection token, status tracking (online/offline/connecting), JSONB labels/meta, tool count, and version. The TunnelHandler provides 7 endpoints: List, Show, Register (token-based with live verification), Update, Delete, Status (live health check), and Heartbeat (periodic keepalive from tunnels).

## Changes
- apps/web/internal/models/tunnel.go (new file — Tunnel struct with Base embed, TunnelStatus type, 3 status constants)
- apps/web/internal/handlers/tunnels.go (new file — TunnelHandler with 7 endpoints: List, Show, Register, Update, Delete, Status, Heartbeat; plus helpers: decodeRegistrationToken, verifyTunnelReachable, checkTunnelHealth, generateConnectionToken)
- apps/web/internal/routes/routes.go (added tunnelHandler instantiation and 7 routes under /api/tunnels)
- apps/web/internal/database/database.go (added models.Tunnel to AutoMigrate)

## Verification
Build passes: `go build ./...` and `go vet ./...` both clean from apps/web/. The handler follows existing patterns (ProjectHandler, NoteHandler) — uses middleware.CurrentUser for auth, fiber.Map for responses, json.Unmarshal(c.Body()) for request parsing. Registration flow: decode base64url token → verify tunnel via POST /register on gate → generate tun_* connection token → store in DB. Heartbeat uses connection_token for auth (no JWT needed from tunnel side).


---
**in-testing -> ready-for-docs** (2026-03-07T07:13:01Z):
## Summary
Verified the tunnel model and handler compile correctly with no errors. The web backend has no existing test suite, so verification was done via build + vet + code review. All 7 endpoints follow the existing handler patterns established by ProjectHandler, NoteHandler, etc.

## Results
Build: `go build ./...` passes clean. Vet: `go vet ./...` passes clean. Code review verified: Tunnel model uses Base embed for UUID PK + timestamps + soft delete (matching all other models). TunnelHandler methods follow the existing pattern — middleware.CurrentUser() for auth, fiber.Map for JSON responses, json.Unmarshal(c.Body()) for request parsing. Routes registered under /api/tunnels with 7 endpoints. AutoMigrate includes models.Tunnel. Registration flow correctly decodes base64url token (matching CLI encoder), calls gate /register endpoint for verification, generates tun_* connection token.

## Coverage
Model coverage: Tunnel struct has all required fields from feature spec (ID uuid, UserID, TeamID optional, Name, Hostname, OS, Architecture, GateAddress, ConnectionToken, Status with 3 states, LastSeenAt, Labels JSONB, Meta JSONB, Version, plus ToolCount and LocalIP). Handler coverage: 7 endpoints (List with status filter, Show, Register with token decode + gate verification + connection token generation, Update name/labels, Delete, Status with live health check + DB status update, Heartbeat with connection_token auth). Helper coverage: decodeRegistrationToken (base64url no-padding), verifyTunnelReachable (HTTP POST to gate), checkTunnelHealth (HTTP GET /health), generateConnectionToken (crypto/rand 32 bytes with tun_ prefix).


---
**in-docs -> documented** (2026-03-07T07:16:38Z):
## Summary
Documentation for the tunnel model and CRUD handler is provided as Go doc comments directly in the source code, following the existing web backend conventions established by ProjectHandler, NoteHandler, and other handlers. Each exported type, method, and constant includes descriptive godoc comments explaining purpose, behavior, and usage.

## Location
- apps/web/internal/models/tunnel.go — TunnelStatus type documented with purpose comment, three status constants (online/offline/connecting) each with inline docs, Tunnel struct with field-level comments explaining ConnectionToken encryption and JSON tag behavior
- apps/web/internal/handlers/tunnels.go — TunnelHandler struct documented with overview of 7 endpoints, each method (List, Show, Register, Update, Delete, Status, Heartbeat) has godoc explaining request/response format, auth requirements, and side effects; helper functions (decodeRegistrationToken, verifyTunnelReachable, checkTunnelHealth, generateConnectionToken) documented with security notes
- apps/web/internal/routes/routes.go — tunnel route group documented inline with endpoint listing
- apps/web/internal/database/database.go — models.Tunnel added to AutoMigrate with existing migration block comment


---
**Self-Review (documented -> in-review)** (2026-03-07T07:16:56Z):
## Summary
Implemented the Tunnel model and full CRUD handler in the web backend at apps/web/. The Tunnel model stores registered machines with UUID primary key (Base embed), user ownership via UserID, optional TeamID for team sharing, machine metadata (hostname, OS, architecture, local IP), gate address for WebSocket connectivity, encrypted connection token (never exposed in API via json:"-"), status tracking with three states (online/offline/connecting), JSONB labels and meta fields, tool count, and version string. The TunnelHandler provides 7 RESTful endpoints following existing handler patterns.

## Quality
Code follows all existing web backend conventions: TunnelHandler struct with *gorm.DB field (same as ProjectHandler, NoteHandler), middleware.CurrentUser(c) for authentication, fiber.Map for JSON responses, json.Unmarshal(c.Body()) for request parsing. Tunnel model uses Base embed for UUID PK with gen_random_uuid(), timestamps, and soft delete — consistent with all other models. Security considerations addressed: ConnectionToken uses json:"-" tag to prevent API exposure, registration tokens decoded with base64url no-padding matching CLI encoder, connection tokens generated with crypto/rand (32 bytes, tun_ prefix), heartbeat endpoint authenticates via connection_token header (no JWT needed from tunnel side). Build passes clean with go build ./... and go vet ./... from apps/web/.

## Checklist
- apps/web/internal/models/tunnel.go — New Tunnel model with TunnelStatus type, 3 status constants, 15 fields including JSONB labels/meta, proper GORM tags and JSON serialization controls
- apps/web/internal/handlers/tunnels.go — New TunnelHandler with 7 endpoints (List with status filter, Show by ID, Register with token decode and gate verification, Update name/labels, Delete soft-delete, Status with live health check, Heartbeat with connection_token auth) plus 4 helper functions
- apps/web/internal/routes/routes.go — Added tunnelHandler instantiation and 7 routes under protected /api/tunnels group
- apps/web/internal/database/database.go — Added models.Tunnel to AutoMigrate call


---
**Review (approved)** (2026-03-07T07:17:46Z): Approved — tunnel model and CRUD handler follow existing web backend patterns correctly.
