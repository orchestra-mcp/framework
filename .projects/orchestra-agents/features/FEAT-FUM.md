---
estimate: M
id: FEAT-FUM
kind: feature
priority: P1
project_slug: orchestra-agents
status: todo
title: WebSocket real-time status broadcasting (tunnel status + file changes)
type: feature
---

# WebSocket real-time status broadcasting (tunnel status + file changes)

Enhance the existing WebSocket hub to broadcast real-time events: tunnel connect/disconnect, tunnel heartbeat status, file change notifications from connected desktops, feature status transitions, sync events. Frontend subscribes to team-scoped channels. Uses Redis pub/sub for multi-instance scaling. Dashboard widgets auto-update on events.
