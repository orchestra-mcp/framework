---
id: REQ-ESY
kind: feature
priority: P0
project_slug: orchestra-agents
status: pending
title: Full realtime sync for ALL data across devices via channels and broadcasting
type: request
---

# Full realtime sync for ALL data across devices via channels and broadcasting

ALL data changes (notes, projects, features, agents, skills, workflows, delegations, health, etc.) must sync in realtime across all devices. When editing a note on desktop, it must update live on mobile. Need: WebSocket channel broadcasting, background services for Flutter, and the backend must relay all data change events to connected clients.
