---
estimate: M
id: FEAT-MZH
kind: feature
priority: P2
project_slug: orchestra-web-gate
status: backlog
title: Per-tunnel permission scoping
type: feature
---

# Per-tunnel permission scoping

Add permission model for tunnel access. Tunnel owner can configure: tool allowlist/blocklist (e.g. allow project tools but block terminal/file tools), read-only mode (list/get tools only, no create/update/delete), team member access levels (owner: full, admin: all tools, member: scoped tools, viewer: read-only). Permissions stored in web backend and enforced at the WebSocket proxy layer. The tunnel itself doesn't need to change — the proxy filters requests before forwarding.