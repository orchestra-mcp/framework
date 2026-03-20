---
estimate: S
id: FEAT-GVQ
kind: feature
priority: P1
project_slug: orchestra-web-gate
status: backlog
title: Tunnel heartbeat & auto-reconnection
type: feature
---

# Tunnel heartbeat & auto-reconnection

Add heartbeat protocol between tunnels and the web backend. Each tunnel sends a periodic heartbeat (every 30s) to the web backend via REST or WebSocket with: status, uptime, tool_count, active_sessions. Web backend updates tunnel.LastSeenAt and sets status to offline if no heartbeat for 90s. Frontend shows real-time status changes. Auto-reconnection: if a tunnel WebSocket disconnects, the frontend retries with exponential backoff (1s → 2s → 4s → ... → 30s). Toast notification on disconnect/reconnect.