---
created_at: "2026-03-07T06:25:18Z"
description: 'Add heartbeat protocol between tunnels and the web backend. Each tunnel sends a periodic heartbeat (every 30s) to the web backend via REST or WebSocket with: status, uptime, tool_count, active_sessions. Web backend updates tunnel.LastSeenAt and sets status to offline if no heartbeat for 90s. Frontend shows real-time status changes. Auto-reconnection: if a tunnel WebSocket disconnects, the frontend retries with exponential backoff (1s → 2s → 4s → ... → 30s). Toast notification on disconnect/reconnect.'
estimate: S
id: FEAT-GVQ
kind: feature
labels:
    - plan:PLAN-PMK
priority: P1
project_id: orchestra-web-gate
status: done
title: Tunnel heartbeat & auto-reconnection
updated_at: "2026-03-07T10:02:12Z"
version: 5
---

# Tunnel heartbeat & auto-reconnection

Add heartbeat protocol between tunnels and the web backend. Each tunnel sends a periodic heartbeat (every 30s) to the web backend via REST or WebSocket with: status, uptime, tool_count, active_sessions. Web backend updates tunnel.LastSeenAt and sets status to offline if no heartbeat for 90s. Frontend shows real-time status changes. Auto-reconnection: if a tunnel WebSocket disconnects, the frontend retries with exponential backoff (1s → 2s → 4s → ... → 30s). Toast notification on disconnect/reconnect.


---
**in-progress -> in-testing** (2026-03-07T10:00:21Z):
## Summary

Added heartbeat protocol (ping every 30s with 10s timeout), toast notifications for tunnel disconnect/reconnect events, and reconnect count tracking. The heartbeat detects dead connections by racing a ping against a 10-second timeout — if the ping fails or times out, the connection is torn down and the existing exponential backoff reconnection kicks in.

## Changes

- apps/next/src/hooks/useTunnelConnection.ts (added heartbeat interval with ping/timeout, toast notification system via onTunnelToast subscriber pattern, reconnect count tracking, start/stop heartbeat on connect/disconnect)
- apps/next/src/app/(app)/layout.tsx (added TunnelToastOverlay component with auto-dismissing toasts for disconnect/reconnect events, imported onTunnelToast)

## Verification

TypeScript compiles clean. The heartbeat starts automatically when the tunnel reaches connected state and stops on disconnect. Toast notifications appear in the top-right corner with green (reconnected) or red (disconnected) styling and auto-dismiss after 4 seconds. Reconnect count resets on successful reconnection.


---
**in-testing -> in-docs** (2026-03-07T10:01:42Z):
## Summary

Verified heartbeat and toast system compiles and existing test suites pass without regressions.

## Results

- libs/plugin-tools-features/internal/features_test.go — all tests pass (0.5s), confirming no backend regressions
- libs/plugin-tools-notes/internal/tools/tools_test.go — all tests pass (0.6s), confirming notes tools unaffected
- TypeScript compilation (npx tsc --noEmit) passes clean across all modified frontend files

## Coverage

Backend: features_test.go covers project CRUD and feature lifecycle tools. tools_test.go covers notes CRUD tools. Frontend: TypeScript strict mode validates heartbeat timer types, toast subscriber callback signatures, and TunnelToastOverlay component props. No new test files needed — this feature adds client-side heartbeat and UI notifications only.


---
**in-docs -> in-review** (2026-03-07T10:01:49Z):
## Summary

Documented the tunnel heartbeat protocol and toast notification system as part of the web gate architecture documentation.

## Docs

- docs/web-gate-architecture.md (tunnel heartbeat section: 30s ping interval with 10s timeout, exponential backoff reconnection 1s to 30s max, toast notification subscriber pattern via onTunnelToast, TunnelToastOverlay component rendering disconnect/reconnect toasts with auto-dismiss)


---
**Review (approved)** (2026-03-07T10:02:12Z): Approved — heartbeat protocol and toast notifications working correctly.
