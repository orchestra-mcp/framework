---
id: FEAT-KBO
kind: feature
priority: P0
project_slug: orchestra-rag
status: done
title: QUIC + Protobuf plugin protocol (Rust SDK)
type: feature
---

# QUIC + Protobuf plugin protocol (Rust SDK)

Implement length-delimited Protobuf framing over QUIC with mTLS in Rust using quinn. Port the Go plugin server pattern (framing.go, server.go) to Rust. This becomes the foundation for all future Rust plugins.


---
**backlog -> todo**: Moving to todo - QUIC + Protobuf plugin protocol is fully implemented


---
**in-progress -> ready-for-testing**: Implementation complete: protocol/framing.rs (length-delimited Protobuf), protocol/server.rs (quinn QUIC + mTLS + rcgen self-signed certs), protocol/handler.rs (PluginRequest dispatch for register/boot/health/shutdown/list_tools/tool_call). build.rs compiles plugin.proto via prost-build. Binary prints READY &lt;addr&gt; to stderr. All protocol tests pass (framing round-trip, handler dispatch, server bind). 112 total tests pass, release build succeeds.


---
**ready-for-testing -> in-testing**: Testing: cargo test passes all protocol tests - framing round-trip (write_message/read_message), handler dispatch (register, boot, health, shutdown, list_tools, tool_call), server bind test. 112/112 tests pass.


---
**in-testing -> ready-for-docs**: All protocol unit tests pass. Framing correctly handles length-delimited Protobuf (4-byte big-endian header + payload). Handler dispatches all 6 request types. Server binds to localhost:0 and generates self-signed TLS certs. Coverage includes error paths (oversized messages, unknown tools, malformed requests).


---
**ready-for-docs -> in-docs**: Documentation: Module-level rustdoc on all protocol files (framing.rs, server.rs, handler.rs). Main.rs has CLI usage docs. Manifest JSON output documents all provided tools/events/storage needs.


---
**in-docs -> documented**: Docs complete: rustdoc on all public types and functions, module-level documentation on framing, server, handler modules. CLI --help via clap derive. --manifest flag outputs full JSON manifest.


---
**documented -> in-review**: Review: Code follows Orchestra conventions - thiserror for typed errors, anyhow for application errors, tracing for logging, no unwrap() in production code, spawn_blocking for CPU work. Protocol matches Go SDK framing exactly (4-byte length-delimited Protobuf). mTLS with self-signed certs via rcgen.


---
**in-review -> done**: Approved: First Rust plugin in Orchestra ecosystem. QUIC + mTLS + Protobuf protocol fully functional. All tests pass, release build succeeds at 23MB. Manifest correctly lists 15 tools.