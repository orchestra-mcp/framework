---
title: RAG Memory & Search
description: 22 tools for codebase indexing, semantic search, and AI memory
order: 2
---

# RAG Memory & Search

The `engine.rag` plugin provides **22 MCP tools** for code parsing, full-text search, and semantic memory. It's written in Rust for performance, using Tree-sitter for parsing, Tantivy for indexing, and SQLite for structured storage.

## Architecture

```
engine.rag (Rust binary)
├── Parse Service    — Tree-sitter (14 languages)
├── Search Service   — Tantivy full-text index
└── Memory Service   — SQLite + cosine similarity
```

The engine connects to the orchestrator over QUIC with mTLS, just like Go plugins.

## Parse Tools (Tree-sitter)

| Tool | Description |
|------|-------------|
| `parse_file` | Parse a source file and return its AST |
| `get_symbols` | Extract functions, classes, structs, interfaces from a file |
| `get_imports` | Extract import statements from a file |

### Supported Languages

Go, Rust, TypeScript, JavaScript, Python, Ruby, Java, Kotlin, Swift, C, C++, C#, PHP, HTML — 14 grammars total.

### Example

```
get_symbols({ path: "src/auth/login.go" })

→ [
    { name: "LoginHandler", kind: "function", line: 15 },
    { name: "ValidateJWT", kind: "function", line: 42 },
    { name: "TokenClaims", kind: "struct", line: 8 }
  ]
```

## Search Tools (Tantivy)

| Tool | Description |
|------|-------------|
| `index_file` | Index a single file for full-text search |
| `index_directory` | Bulk index a directory (respects .gitignore) |
| `search` | Full-text search across indexed files |
| `search_symbols` | Search against the symbols field only |
| `get_index_stats` | Get index statistics (doc count, path) |
| `delete_from_index` | Remove a file from the index |
| `clear_index` | Clear the entire search index |

### Bulk Indexing

```
index_directory({ path: ".", recursive: true })

→ Indexed 2,847 files in 3.2s
  Skipped 412 files (.gitignore)
  Index size: 14.2 MB
```

The `index_directory` tool uses the `ignore` crate for .gitignore-aware traversal and batches Tantivy commits for performance.

### Search Example

```
search({ query: "QUIC transport mTLS" })

→ [
    { path: "libs/sdk-go/plugin/client.go", score: 0.94, snippet: "..." },
    { path: "libs/sdk-go/plugin/certs.go", score: 0.91, snippet: "..." },
    { path: "docs/architecture/quic.md", score: 0.88, snippet: "..." }
  ]
```

## Memory Tools (SQLite + Embeddings)

| Tool | Description |
|------|-------------|
| `save_memory` | Store text + embedding vector |
| `search_memory` | Cosine similarity search across memories |
| `get_context` | Get contextual memories for a topic |
| `list_memories` | List all memories (paginated) |
| `get_memory` | Get a single memory by ID |
| `update_memory` | Update an existing memory |
| `delete_memory` | Delete a memory |
| `save_observation` | Store a session-scoped observation |
| `get_project_summary` | Aggregated project overview |
| `start_session` | Begin a memory session |
| `end_session` | End a memory session |

### Memory Categories

Observations can be typed for structured retrieval:

- `understanding` — What was learned about the codebase
- `decision` — Architectural or design decisions made
- `pattern` — Recurring patterns observed
- `issue` — Problems identified
- `insight` — General insights

### Semantic Search

```
search_memory({ query: "authentication flow", category: "understanding" })

→ [
    { id: "mem-001", score: 0.94, text: "JWT validation happens in middleware..." },
    { id: "mem-002", score: 0.89, text: "OAuth flow uses PKCE for security..." }
  ]
```

Memory search uses brute-force cosine similarity in SQLite, which works well for up to ~10,000 vectors. For larger deployments, a LanceDB upgrade path is planned.

## Performance

| Operation | Typical Speed |
|-----------|--------------|
| Parse file (Tree-sitter) | < 5ms |
| Index directory (2,000 files) | ~3s |
| Full-text search | < 10ms |
| Memory search (1,000 vectors) | < 50ms |
| Save memory + embedding | < 20ms |
