---
title: QUIC Protocol
description: Wire protocol details — QUIC, mTLS, length-delimited Protobuf framing
order: 4
---

# QUIC Transport Protocol

Orchestra plugins communicate using QUIC with mutual TLS (mTLS) and length-delimited Protobuf framing.

## Why QUIC?

- **Multiplexed streams** — Multiple tool calls in parallel over a single connection
- **0-RTT reconnection** — Fast reconnects after network changes
- **Built-in encryption** — TLS 1.3 by default
- **NAT traversal** — Works behind firewalls (UDP-based)

## mTLS Authentication

Every plugin authenticates with mutual TLS using ed25519 certificates:

```
~/.orchestra/certs/
├── ca.crt         # Certificate Authority (auto-generated)
├── ca.key         # CA private key
├── server.crt     # Orchestrator certificate
├── server.key     # Orchestrator private key
├── client.crt     # Plugin certificate
└── client.key     # Plugin private key
```

Certificates are auto-generated on first run. The CA is local — no external PKI needed.

### Certificate Generation

```go
// Go (sdk-go)
certs.EnsureCA()           // Create CA if missing
certs.GenerateCert("plugin-name")  // Generate plugin cert

// Server-side TLS config
tlsConfig := certs.ServerTLSConfig()

// Client-side TLS config
tlsConfig := certs.ClientTLSConfig()
```

## Framing

Messages are length-delimited: a 4-byte big-endian length prefix followed by the Protobuf-encoded message.

```
┌──────────┬──────────────────────┐
│ 4 bytes  │  Protobuf payload    │
│ (length) │  (PluginMessage)     │
└──────────┴──────────────────────┘
```

### Go Implementation

```go
// Write
func WriteMessage(w io.Writer, msg proto.Message) error {
    data, _ := proto.Marshal(msg)
    binary.Write(w, binary.BigEndian, uint32(len(data)))
    w.Write(data)
}

// Read
func ReadMessage(r io.Reader, msg proto.Message) error {
    var length uint32
    binary.Read(r, binary.BigEndian, &length)
    data := make([]byte, length)
    io.ReadFull(r, data)
    proto.Unmarshal(data, msg)
}
```

### Rust Implementation

```rust
// Write
async fn write_message(stream: &mut SendStream, msg: &PluginMessage) -> Result<()> {
    let data = msg.encode_to_vec();
    stream.write_all(&(data.len() as u32).to_be_bytes()).await?;
    stream.write_all(&data).await?;
    Ok(())
}
```

## Message Types

### PluginManifest (on connect)

```protobuf
message PluginManifest {
  string plugin_id = 1;
  string version = 2;
  repeated ToolDefinition tools = 3;
  repeated PromptDefinition prompts = 4;
}
```

### ToolCall (request)

```protobuf
message ToolCall {
  string id = 1;
  string name = 2;
  bytes params = 3;  // JSON-encoded parameters
}
```

### ToolResult (response)

```protobuf
message ToolResult {
  string id = 1;
  bool success = 2;
  bytes data = 3;    // JSON-encoded result
  string error = 4;
}
```

## Connection Flow

```
Plugin                          Orchestrator
  │                                  │
  │──── QUIC Connect ───────────────→│
  │←─── TLS Handshake (mTLS) ──────│
  │                                  │
  │──── PluginManifest ─────────────→│  (declare tools)
  │←─── Acknowledge ────────────────│
  │                                  │
  │←─── ToolCall ───────────────────│  (from IDE)
  │──── ToolResult ─────────────────→│
  │                                  │
  │←─── Shutdown ───────────────────│  (lifecycle)
  │──── Ack ────────────────────────→│
```

## Ports

| Service | Port | Transport |
|---------|------|-----------|
| Orchestrator (QUIC) | 9100 | QUIC + mTLS |
| Desktop App (TCP) | 50101 | TCP + Protobuf |
| MCP stdio | — | stdin/stdout |
