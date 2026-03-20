---
id: FEAT-ILH
kind: feature
priority: P0
project_slug: orchestra-linux
status: backlog
title: QUIC transport client (ngtcp2)
type: feature
---

# QUIC transport client (ngtcp2)

Implement QUIC transport client using ngtcp2 C library with Vala VAPI bindings. Connect to orchestrator at localhost:50100. Support mTLS authentication using certificates from ~/.orchestra/certs/ (ca.crt, plugin cert/key). ALPN protocol: "orchestra-plugin". Include exponential backoff reconnection (1s to 30s max). Integrate with GLib main loop for async I/O.