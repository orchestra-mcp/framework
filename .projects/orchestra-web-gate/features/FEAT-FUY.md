---
estimate: M
id: FEAT-FUY
kind: feature
priority: P2
project_slug: orchestra-web-gate
status: backlog
title: Tunnel authentication — JWT-based secure connections
type: feature
---

# Tunnel authentication — JWT-based secure connections

Replace simple API key auth with JWT-based authentication for tunnel connections. Flow: user logs into web app → gets JWT → JWT is included in WebSocket connection to tunnel → tunnel validates JWT against the web backend's public key or via a verification endpoint. Support both: (1) web backend proxied connections (backend adds auth automatically), (2) direct browser-to-tunnel connections (browser sends JWT in WebSocket handshake). Rotate connection tokens periodically.