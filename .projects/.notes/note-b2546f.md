---
id: note-b2546f
title: Rust Engine (plugin-engine-rag) — Architecture & Reference
type: note
---

# Rust Engine — plugin-engine-rag

Location: `libs/plugin-engine-rag/`
Binary: `bin/engine-rag` (~24MB release build)
Language: Rust (first Rust plugin in the architecture)
Protocol: **QUIC + length-delimited Protobuf** (NOT gRPC) — same wire format as Go plugins but using `quinn` instead of `quic-go`

---

## Overview

The engine-rag plugin is the CPU-intensive companion to the Go orchestrator. It handles code parsing, full-text search indexing, and persistent RAG memory — tasks that benefit from Rust's performance and safety guarantees.

It is spawned as an external process by the orchestrator and communicates over a local QUIC connection authenticated with mTLS.

---

## Directory Structure

```
libs/plugin-engine-rag/
├── src/
│   ├── main.rs              # Binary entry point, CLI parsing, startup
│   ├── lib.rs               # Library root, module declarations
│   ├── db/                  # SQLite connection pool (WAL mode)
│   ├── parser/              # Tree-sitter code parsing (14 languages)
│   ├── index/               # Tantivy full-text search engine
│   ├── memory/              # RAG memory, sessions, embeddings, observations
│   ├── lsp/                 # Language Server Protocol support
│   ├── protocol/            # QUIC server + Protobuf framing
│   ├── tools/               # MCP tool registry + all tool implementations
│   └── proto/               # Generated Protobuf types (from build.rs)
├── proto/orchestra/plugin/v1/plugin.proto
├── tests/all_tools_integration.rs
├── Cargo.toml
└── build.rs                 # prost-build compiles .proto at build time
```

---

## Key Dependencies

| Crate | Purpose |
|-------|---------|
| `quinn` | QUIC transport |
| `rustls` | mTLS certificate handling |
| `prost` | Protobuf serialization |
| `tantivy` | Full-text search indexing |
| `tree-sitter` + 14 grammars | Code parsing & AST extraction |
| `rusqlite` (bundled) | Embedded SQLite database |
| `tokio` | Async runtime (full features) |
| `ignore` | .gitignore-aware directory walking |
| `ropey` | Rope data structure for text editing |
| `thiserror` / `anyhow` | Typed + application error handling |
| `tracing` | Structured logging |
| `clap` | CLI argument parsing |

---

## MCP Tools (31 total)

### Health (1)
- `health_check`

### Parser — Tree-sitter (3)
- `parse_file` — Parse a source file and return AST info
- `get_symbols` — Extract functions, classes, structs, traits with line ranges
- `get_imports` — Filter symbols to imports only

### Search — Tantivy (7)
- `index_file` — Add/update a file in the search index
- `search` — Full-text search across indexed files with snippets
- `search_symbols` — Search against symbols field only
- `delete_from_index` — Remove a file path from the index
- `clear_index` — Wipe the entire index
- `get_index_stats` — Document count, index path
- `index_directory` — Bulk .gitignore-aware recursive indexing (uses `ignore` crate)

### Memory — RAG (11)
- `save_memory` — Store a memory entry with optional embedding
- `get_memory` — Retrieve a single memory by ID
- `update_memory` — Update memory content/metadata
- `delete_memory` — Delete a memory entry
- `list_memories` — Paginated list with filters
- `search_memory` — Hybrid keyword + vector search (with category filter)
- `get_context` — Token-budgeted cross-session context retrieval
- `start_session` / `end_session` — Session lifecycle management
- `save_observation` — Structured observation (understanding/decision/pattern/issue/insight)
- `get_project_summary` — Aggregated memory + session stats

### LSP (10)
- `lsp_open_document`, `lsp_close_document`, `lsp_update_document`
- `lsp_goto_definition`, `lsp_find_references`, `lsp_hover`, `lsp_complete`
- `lsp_diagnostics`, `lsp_workspace_symbols`, `lsp_build_index`

---

## Supported Languages (Tree-sitter)

Rust, Go, JavaScript, TypeScript, Python, C, C++, Java, HTML, CSS, JSON, TOML, YAML, Markdown

---

## Storage

All data stored under `{workspace}/.orchestra/`:
- `rag.db` — SQLite database (WAL mode, foreign keys, 5s busy timeout)
  - Tables: `sessions`, `observations`, `embeddings`, `memories`
- Tantivy index directory — Full-text search index
  - Schema fields: `path`, `content`, `language`, `symbols`, `metadata`

Embedding search uses **brute-force cosine similarity** in SQLite (suitable for <10k vectors). LanceDB upgrade planned for Phase 2.

---

## Startup Sequence

1. Parse CLI: `--orchestrator-addr`, `--listen-addr`, `--certs-dir`, `--workspace`
2. If `--manifest`: print JSON manifest (31 tools + 2 events) and exit
3. Init tracing (stderr, env-filter default=info)
4. Open SQLite at `{workspace}/.orchestra/rag.db`, run `MemorySchema::init()`
5. Build `ToolRegistry`, register all 31 tools
6. Start `PluginServer` (QUIC listener with mTLS)
7. Print `READY {addr}` to stderr — orchestrator reads this to confirm it's up
8. Accept QUIC connections until SIGINT/SIGTERM (CancellationToken)

---

## Protocol

- **Transport**: QUIC (quinn) with mTLS
- **Framing**: 4-byte big-endian length prefix + Protobuf body
- **Message types**: `PluginRequest` / `PluginResponse` from `orchestra/plugin/v1/plugin.proto`
- **Dispatch**: `RequestHandler` routes by request type → `ToolRegistry.call(name, args)`
- **Events emitted**: `file.indexed`, `memory.saved`

---

## Build & Test

```bash
# Build
make build-engine-rag
# or: cd libs/plugin-engine-rag && cargo build --release

# Test
make test-engine-rag
# or: cd libs/plugin-engine-rag && cargo test

# Print manifest
./bin/engine-rag --manifest
```

Tests: 230+ unit tests inline in modules + 20+ integration tests in `tests/all_tools_integration.rs`

---

## Key Architecture Notes

- **Thread safety**: `Arc<RwLock<IndexManager>>` shared between search and directory tools
- **Async-first**: All tool handlers are `async` closures boxed as trait objects
- **No gRPC**: Uses raw Protobuf over QUIC — no Tonic, no service definitions
- **In-process tool registry**: `HashMap<String, Arc<dyn Fn(Value) -> Pin<Box<...>>>>` — lightweight and fast
- **Export pattern**: `register_all_tools()` / `register_all_tools_with_lsp()` are the registration entry points
