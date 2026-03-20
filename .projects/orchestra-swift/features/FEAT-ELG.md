---
id: FEAT-ELG
kind: feature
priority: P0
project_slug: orchestra-swift
status: done
title: QUIC transport layer (QUICConnection + StreamFramer + MTLSConfig)
type: feature
---

# QUIC transport layer (QUICConnection + StreamFramer + MTLSConfig)

QUICConnection: Network.framework QUIC client connecting to orchestrator (default localhost:50100), ALPN "orchestra-plugin", exponential backoff reconnection (1s-30s), ConnectionState published property. StreamFramer: length-delimited Protobuf framing (4-byte big-endian uint32 + payload), 16MB max message size, async read/write. MTLSConfig: load ed25519 certs from ~/.orchestra/certs/ (macOS) or app bundle (iOS), create NWProtocolTLS.Options with mTLS.