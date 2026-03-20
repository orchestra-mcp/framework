---
estimate: M
id: FEAT-HDS
kind: feature
priority: high
project_slug: orchestra-agents
status: todo
title: WebSocket real-time subscription and notification center UI on web
type: feature
---

# WebSocket real-time subscription and notification center UI on web

Implement WebSocket connection in Next.js for real-time event streaming. (1) Connect to WS endpoint on auth with auto-reconnect. (2) Build notification center dropdown in header (bell icon + unread badge + scrollable list). (3) Wire WebSocket events to notification center: new notifications, entity updates, agent requests. (4) Mark-as-read on click. (5) Settings page for notification preferences (already has toggle).
