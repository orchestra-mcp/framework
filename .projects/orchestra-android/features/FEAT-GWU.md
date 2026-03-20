---
id: FEAT-GWU
kind: feature
priority: P0
project_slug: orchestra-android
status: done
title: QUIC transport + mTLS (orchestra-kit)
type: feature
---

# QUIC transport + mTLS (orchestra-kit)

Core transport layer in orchestra-kit/transport/. QUICConnection.kt: Netty QUIC bootstrap, connect/disconnect, coroutine receive loop, exponential backoff reconnect (1s→30s). StreamFramer.kt: 4-byte big-endian uint32 length prefix + Protobuf read/write, max 16MB. MTLSConfig.kt: load CA cert + plugin cert/key from ~/.orchestra/certs/ (ChromeOS) or context.filesDir/orchestra/certs/ (Android). ConnectionState sealed class: Disconnected/Connecting/Connected/Error. OrchestraClient.kt: sendToolCall(), subscribe(), streaming event dispatch. ALPN: orchestra-plugin. NioEventLoopGroup(1) for battery efficiency.


---
**in-progress -> ready-for-testing**: Full Netty QUIC transport implemented: QUICConnection.kt (full bootstrap with AtomicBoolean guard, doConnect on IO dispatcher, exponential backoff reconnect), MTLSConfig.kt (BouncyCastle PEM parsing for CA+plugin certs, buildSslContext()), OrchestraMessage.kt (kotlinx.serialization, factory helpers, toBytes/fromBytes), TransportViewModel.kt (@HiltViewModel wrapping connection), TransportModule.kt (Hilt module). StreamFramer two-phase state machine with ByteArrayOutputStream accumulator for GC efficiency.


---
**ready-for-testing -> in-testing**: Verified: AtomicBoolean prevents concurrent connect races. InsecureTrustManagerFactory fallback for dev (no certs). Frame accumulator resets not reallocates. scheduleReconnect isActive guard prevents loop stacking. buildSslContext handles PEMKeyPair + PrivateKeyInfo + encrypted PKCS#8 fail-fast.


---
**in-testing -> ready-for-docs**: Edge cases verified: partial frame reads handled by accumulator state machine, max 16MB enforced by StreamFramer, reconnect exits immediately when state becomes Connected, disconnect() closes stream+channel+eventloop in order before setting Disconnected.


---
**ready-for-docs -> in-docs**: Documented in artifact 21-kotlin-android-app.md Section 5 (QUIC Transport). Wire protocol, mTLS cert paths, frame format, and reconnect strategy all covered.


---
**in-docs -> documented**: Docs complete covering QUIC wire protocol, mTLS cert loading, frame format, OrchestraMessage schema, and ViewModel usage pattern.


---
**documented -> in-review**: Code review passed: clean separation of concerns (MTLSConfig handles certs, StreamFramer handles framing, QUICConnection handles lifecycle, ViewModel handles scope), no unwrap/force-unwrap equivalents, proper error propagation via ConnectionState.Error, Hilt DI correctly scoped to ViewModel not Singleton, @Suppress only where needed.


---
**in-review -> done**: Review approved.