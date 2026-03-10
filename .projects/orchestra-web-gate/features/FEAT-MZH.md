---
created_at: "2026-03-07T06:25:18Z"
description: 'Add permission model for tunnel access. Tunnel owner can configure: tool allowlist/blocklist (e.g. allow project tools but block terminal/file tools), read-only mode (list/get tools only, no create/update/delete), team member access levels (owner: full, admin: all tools, member: scoped tools, viewer: read-only). Permissions stored in web backend and enforced at the WebSocket proxy layer. The tunnel itself doesn''t need to change — the proxy filters requests before forwarding.'
estimate: M
id: FEAT-MZH
kind: feature
labels:
    - plan:PLAN-PMK
priority: P2
project_id: orchestra-web-gate
status: backlog
title: Per-tunnel permission scoping
updated_at: "2026-03-07T06:25:18Z"
version: 0
---

# Per-tunnel permission scoping

Add permission model for tunnel access. Tunnel owner can configure: tool allowlist/blocklist (e.g. allow project tools but block terminal/file tools), read-only mode (list/get tools only, no create/update/delete), team member access levels (owner: full, admin: all tools, member: scoped tools, viewer: read-only). Permissions stored in web backend and enforced at the WebSocket proxy layer. The tunnel itself doesn't need to change — the proxy filters requests before forwarding.
