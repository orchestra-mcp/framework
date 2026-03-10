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
status: backlog
title: Tunnel heartbeat & auto-reconnection
updated_at: "2026-03-07T06:25:18Z"
version: 0
---

# Tunnel heartbeat & auto-reconnection

Add heartbeat protocol between tunnels and the web backend. Each tunnel sends a periodic heartbeat (every 30s) to the web backend via REST or WebSocket with: status, uptime, tool_count, active_sessions. Web backend updates tunnel.LastSeenAt and sets status to offline if no heartbeat for 90s. Frontend shows real-time status changes. Auto-reconnection: if a tunnel WebSocket disconnects, the frontend retries with exponential backoff (1s → 2s → 4s → ... → 30s). Toast notification on disconnect/reconnect.
