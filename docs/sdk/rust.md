---
title: Rust Plugin SDK
description: Build Orchestra plugins in Rust using quinn, prost, and the QUIC protocol
order: 3
---

# Rust Plugins

Orchestra supports Rust plugins via the QUIC transport protocol. The `engine.rag` plugin is the reference implementation — a 24MB binary with 22 MCP tools built with quinn, Tantivy, Tree-sitter, and rusqlite.

## Architecture

Rust plugins are external plugins that connect to the orchestrator over QUIC:

```
Orchestra CLI (Go)          Rust Plugin
     │                           │
     │◄── QUIC + mTLS ──────────│  quinn
     │    Protobuf (prost)       │  prost
     │                           │
```

## Dependencies

| Crate | Purpose |
|-------|---------|
| `quinn` | QUIC transport (Rust equivalent of quic-go) |
| `prost` | Protobuf serialization/deserialization |
| `prost-build` | Proto → Rust code generation |
| `rustls` | TLS for mTLS authentication |
| `tokio` | Async runtime |

Plus domain-specific crates:
| Crate | Purpose |
|-------|---------|
| `tantivy` | Full-text search indexing |
| `tree-sitter` | Multi-language code parsing |
| `rusqlite` | SQLite database |
| `ignore` | .gitignore-aware file traversal |

## Proto Contract

The same `.proto` files used by Go plugins are compiled with `prost-build`:

```rust
// build.rs
fn main() {
    prost_build::compile_protos(
        &["../../proto/mcp.proto"],
        &["../../proto/"],
    ).unwrap();
}
```

## Plugin Structure

```
libs/plugin-engine-rag/
├── Cargo.toml
├── build.rs              # prost-build for proto
├── src/
│   ├── main.rs           # Entry point, QUIC server
│   ├── transport/        # QUIC + mTLS + framing
│   ├── parse/            # Tree-sitter service
│   ├── search/           # Tantivy service
│   ├── memory/           # SQLite + embeddings
│   └── tests/            # 159 tests
```

## Connection Flow

1. Plugin reads cert paths from `~/.orchestra/certs/`
2. Creates a quinn client with mTLS config
3. Connects to orchestrator at `localhost:9100`
4. Sends `PluginManifest` (declares tools, prompts, capabilities)
5. Waits for `ToolCall` messages, returns `ToolResult`

## Implementing a Tool

```rust
async fn handle_tool_call(call: ToolCall) -> ToolResult {
    match call.name.as_str() {
        "search" => {
            let query = call.params.get("query").unwrap();
            let results = search_index(query).await;
            ToolResult::success(serde_json::to_value(results).unwrap())
        }
        _ => ToolResult::error(format!("Unknown tool: {}", call.name)),
    }
}
```

## Building

```bash
# Debug build
cargo build

# Release build (24MB binary)
cargo build --release

# Run tests (159 tests)
cargo test
```

## Testing

```rust
#[tokio::test]
async fn test_search() {
    let index = IndexManager::new_temp().await;
    index.add_file("test.go", "package main\nfunc Hello() {}").await;

    let results = index.search("Hello").await.unwrap();
    assert_eq!(results.len(), 1);
    assert_eq!(results[0].path, "test.go");
}
```

## Performance Characteristics

| Operation | Speed |
|-----------|-------|
| Parse file (Tree-sitter) | < 5ms |
| Index 2,000 files | ~3s |
| Full-text search | < 10ms |
| Cosine similarity (1K vectors) | < 50ms |
| Binary size (release) | ~24MB |
| Memory usage (idle) | ~15MB |
