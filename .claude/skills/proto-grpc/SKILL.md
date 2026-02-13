---
name: proto-grpc
description: Protobuf/gRPC/Buf patterns for Go-Rust communication. Activates when working with .proto files, gRPC services, buf configuration, code generation, or service contracts between Go and Rust.
---

# Proto & gRPC — Service Contracts

Orchestra MCP uses Protocol Buffers as the contract layer between the Go backend and Rust engine, compiled via Buf and generated into both languages.

## Project Layout

```
proto/
├── buf.yaml              # Buf workspace config
├── buf.gen.yaml          # Code generation config
├── buf.lock
├── common/
│   ├── types.proto       # Shared types (timestamps, pagination, errors)
│   └── sync.proto        # Sync protocol messages
├── engine/
│   ├── parser.proto      # Tree-sitter parsing service
│   ├── indexer.proto      # Code indexing service
│   ├── search.proto       # Tantivy search service
│   ├── completer.proto    # Autocomplete service
│   ├── differ.proto       # File diff service
│   └── crypto.proto       # Encryption service
├── ai/
│   └── agent.proto        # AI agent protocol
└── sync/
    └── sync.proto         # Device sync protocol
```

## Buf Configuration

### `proto/buf.yaml`
```yaml
version: v2
modules:
  - path: common
  - path: engine
  - path: ai
  - path: sync
lint:
  use:
    - STANDARD
breaking:
  use:
    - FILE
```

### `proto/buf.gen.yaml`
```yaml
version: v2
plugins:
  # Go generation
  - remote: buf.build/protocolbuffers/go
    out: ../app/gen/proto
    opt: paths=source_relative
  - remote: buf.build/grpc/go
    out: ../app/gen/proto
    opt: paths=source_relative
  # TypeScript generation (for frontend types)
  - remote: buf.build/bufbuild/es
    out: ../resources/shared/gen/proto
```

## Proto Design Patterns

### Service Definition
```protobuf
syntax = "proto3";
package engine.parser;

option go_package = "orchestra/app/gen/proto/engine";

import "common/types.proto";

service ParserService {
  rpc Parse(ParseRequest) returns (ParseResponse);
  rpc ParseStream(ParseRequest) returns (stream ParseEvent);
}

message ParseRequest {
  string file_path = 1;
  string content = 2;
  string language = 3;
}

message ParseResponse {
  common.Status status = 1;
  repeated ASTNode nodes = 2;
  repeated Diagnostic diagnostics = 3;
}
```

### Common Types (`common/types.proto`)
```protobuf
syntax = "proto3";
package common;

option go_package = "orchestra/app/gen/proto/common";

message Status {
  bool success = 1;
  string message = 2;
  int32 code = 3;
}

message Pagination {
  int32 page = 1;
  int32 per_page = 2;
  int32 total = 3;
}

message Timestamp {
  int64 seconds = 1;
  int32 nanos = 2;
}

message DeviceInfo {
  string device_id = 1;
  string device_type = 2;  // desktop, chrome, mobile_ios, mobile_android, web
  string app_version = 3;
}
```

### Sync Protocol (`sync/sync.proto`)
```protobuf
syntax = "proto3";
package sync;

option go_package = "orchestra/app/gen/proto/sync";

import "common/types.proto";

service SyncService {
  rpc Push(PushRequest) returns (PushResponse);
  rpc Pull(PullRequest) returns (PullResponse);
  rpc Subscribe(SubscribeRequest) returns (stream SyncEvent);
}

message SyncEvent {
  string entity_id = 1;
  string entity_type = 2;
  string action = 3;          // create, update, delete
  bytes data = 4;
  int64 version = 5;
  common.Timestamp timestamp = 6;
  common.DeviceInfo device = 7;
  string checksum = 8;
}
```

## Code Generation Commands

```bash
# Generate all (Go + Rust + TypeScript)
make proto

# Generate Go only
cd proto && buf generate --template buf.gen.yaml

# Generate Rust (via tonic-build in engine/build.rs)
cd engine && cargo build
```

## Rust Proto Compilation (`engine/build.rs`)

```rust
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let protos = &[
        "../proto/engine/parser.proto",
        "../proto/engine/indexer.proto",
        "../proto/engine/search.proto",
        "../proto/engine/completer.proto",
        "../proto/engine/differ.proto",
        "../proto/engine/crypto.proto",
        "../proto/common/types.proto",
        "../proto/sync/sync.proto",
    ];

    tonic_build::configure()
        .build_server(true)
        .build_client(true)
        .out_dir("src/gen")
        .compile_protos(protos, &["../proto"])?;

    for proto in protos {
        println!("cargo:rerun-if-changed={}", proto);
    }

    Ok(())
}
```

## Conventions

- Package names: `common`, `engine.parser`, `engine.indexer`, `sync`, `ai`
- Go package option: `option go_package = "orchestra/app/gen/proto/{package}";`
- Field numbering: never reuse deleted field numbers, reserve them
- Enums: use `UNSPECIFIED = 0` as first value
- Streaming: use server-side streaming for real-time events (parse, sync, search)
- Errors: return `common.Status` in response messages, not gRPC status codes for business errors
- Versioning: breaking changes require new service version (`v2/parser.proto`)

## Don'ts

- Don't use `google.protobuf.Any` — use concrete types or `oneof`
- Don't put business logic in proto definitions — they are pure contracts
- Don't generate Rust code with buf (use `tonic-build` in `build.rs` instead)
- Don't skip the `buf lint` step — it catches common proto issues
