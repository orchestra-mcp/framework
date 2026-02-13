---
name: rust-engine
description: Rust engine patterns with Tonic gRPC, rusqlite, Tree-sitter, and Tantivy. Activates when writing Rust services, gRPC handlers, code parsing, indexing, file diffing, encryption, or any Rust code.
---

# Rust Engine — Tonic gRPC + Tree-sitter + Tantivy

The Rust engine handles CPU-intensive operations: code parsing (Tree-sitter), code indexing (Tantivy), file diffing, content hashing, compression (zstd), encryption, and local SQLite management.

## Project Structure

```
engine/
├── Cargo.toml
├── build.rs                 # Proto compilation (tonic-build)
└── src/
    ├── main.rs              # gRPC server entry point
    ├── config.rs            # Engine configuration
    ├── gen/                 # Generated proto code (from build.rs)
    │   └── mod.rs
    ├── services/
    │   ├── mod.rs
    │   ├── parser.rs        # Tree-sitter parsing
    │   ├── indexer.rs       # Tantivy code indexing
    │   ├── searcher.rs      # Search queries
    │   ├── completer.rs     # Autocomplete engine
    │   ├── differ.rs        # File diff (Myers algorithm)
    │   ├── hasher.rs        # Content-addressable hashing (SHA-256)
    │   ├── compressor.rs    # zstd compression
    │   └── crypto.rs        # AES-256-GCM encryption
    ├── models/
    │   ├── mod.rs
    │   ├── ast_node.rs      # AST node types
    │   ├── symbol.rs        # Code symbols
    │   ├── diagnostic.rs    # Errors/warnings
    │   └── completion.rs    # Completion items
    ├── repositories/
    │   ├── mod.rs
    │   ├── file_repo.rs     # Local SQLite file metadata
    │   └── symbol_repo.rs   # Symbol table
    └── handlers/            # gRPC service implementations
        ├── mod.rs
        ├── parser_handler.rs
        ├── indexer_handler.rs
        ├── search_handler.rs
        └── completer_handler.rs
```

## Cargo.toml

```toml
[package]
name = "orchestra-engine"
version = "0.1.0"
edition = "2021"

[dependencies]
# gRPC
tonic = "0.12"
prost = "0.13"
prost-types = "0.13"
tokio = { version = "1", features = ["full"] }

# Parsing
tree-sitter = "0.24"
tree-sitter-rust = "0.23"
tree-sitter-javascript = "0.23"
tree-sitter-typescript = "0.23"
tree-sitter-python = "0.23"
tree-sitter-go = "0.23"

# Search
tantivy = "0.22"

# Database
rusqlite = { version = "0.32", features = ["bundled"] }

# Utilities
serde = { version = "1", features = ["derive"] }
serde_json = "1"
sha2 = "0.10"
zstd = "0.13"
aes-gcm = "0.10"
thiserror = "2"
anyhow = "1"
tracing = "0.1"
tracing-subscriber = "0.3"
uuid = { version = "1", features = ["v4"] }

[build-dependencies]
tonic-build = "0.12"
```

## gRPC Server Entry Point (`main.rs`)

```rust
use tonic::transport::Server;
use tracing_subscriber;

mod config;
mod gen;
mod handlers;
mod models;
mod repositories;
mod services;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    tracing_subscriber::init();

    let config = config::load()?;

    let parser_svc = handlers::ParserHandler::new();
    let indexer_svc = handlers::IndexerHandler::new(&config)?;
    let search_svc = handlers::SearchHandler::new(&config)?;

    let addr = format!("{}:{}", config.host, config.port).parse()?;
    tracing::info!("Engine listening on {}", addr);

    Server::builder()
        .add_service(gen::engine::parser_service_server::ParserServiceServer::new(parser_svc))
        .add_service(gen::engine::indexer_service_server::IndexerServiceServer::new(indexer_svc))
        .add_service(gen::engine::search_service_server::SearchServiceServer::new(search_svc))
        .serve(addr)
        .await?;

    Ok(())
}
```

## gRPC Handler Pattern

```rust
use tonic::{Request, Response, Status};
use crate::gen::engine::{
    parser_service_server::ParserService,
    ParseRequest, ParseResponse,
};
use crate::services::parser::Parser;

pub struct ParserHandler {
    parser: Parser,
}

impl ParserHandler {
    pub fn new() -> Self {
        Self {
            parser: Parser::new(),
        }
    }
}

#[tonic::async_trait]
impl ParserService for ParserHandler {
    async fn parse(
        &self,
        request: Request<ParseRequest>,
    ) -> Result<Response<ParseResponse>, Status> {
        let req = request.into_inner();

        let result = self.parser
            .parse(&req.content, &req.language)
            .map_err(|e| Status::internal(format!("Parse error: {}", e)))?;

        Ok(Response::new(ParseResponse {
            status: Some(crate::gen::common::Status {
                success: true,
                message: String::new(),
                code: 0,
            }),
            nodes: result.nodes,
            diagnostics: result.diagnostics,
        }))
    }
}
```

## Service Pattern

```rust
use thiserror::Error;
use tree_sitter::{Parser as TSParser, Language};

#[derive(Error, Debug)]
pub enum ParserError {
    #[error("Unsupported language: {0}")]
    UnsupportedLanguage(String),
    #[error("Parse failed: {0}")]
    ParseFailed(String),
    #[error("Timeout")]
    Timeout,
}

pub struct Parser {
    languages: HashMap<String, Language>,
}

impl Parser {
    pub fn new() -> Self {
        let mut languages = HashMap::new();
        languages.insert("rust".into(), tree_sitter_rust::LANGUAGE.into());
        languages.insert("javascript".into(), tree_sitter_javascript::LANGUAGE.into());
        languages.insert("typescript".into(), tree_sitter_typescript::LANGUAGE_TYPESCRIPT.into());
        languages.insert("python".into(), tree_sitter_python::LANGUAGE.into());
        languages.insert("go".into(), tree_sitter_go::LANGUAGE.into());

        Self { languages }
    }

    pub fn parse(&self, content: &str, language: &str) -> Result<ParseResult, ParserError> {
        let lang = self.languages.get(language)
            .ok_or_else(|| ParserError::UnsupportedLanguage(language.to_string()))?;

        let mut parser = TSParser::new();
        parser.set_language(lang)
            .map_err(|e| ParserError::ParseFailed(e.to_string()))?;

        let tree = parser.parse(content, None)
            .ok_or(ParserError::ParseFailed("Failed to parse".into()))?;

        Ok(ParseResult::from_tree(&tree))
    }
}
```

## rusqlite Repository Pattern

```rust
use rusqlite::{Connection, params, Result};
use std::sync::Mutex;

pub struct FileRepo {
    conn: Mutex<Connection>,
}

impl FileRepo {
    pub fn new(db_path: &str) -> Result<Self> {
        let conn = Connection::open(db_path)?;
        conn.execute_batch("
            CREATE TABLE IF NOT EXISTS files (
                id TEXT PRIMARY KEY,
                project_id TEXT NOT NULL,
                path TEXT NOT NULL,
                content_hash TEXT,
                metadata TEXT DEFAULT '{}',
                synced INTEGER DEFAULT 0,
                version INTEGER DEFAULT 0,
                updated_at TEXT DEFAULT (datetime('now'))
            );
            CREATE INDEX IF NOT EXISTS idx_files_project ON files(project_id);
        ")?;

        Ok(Self { conn: Mutex::new(conn) })
    }

    pub fn upsert(&self, file: &FileRecord) -> Result<()> {
        let conn = self.conn.lock().unwrap();
        conn.execute(
            "INSERT INTO files (id, project_id, path, content_hash, metadata, version, updated_at)
             VALUES (?1, ?2, ?3, ?4, ?5, ?6, datetime('now'))
             ON CONFLICT(id) DO UPDATE SET
                path = excluded.path,
                content_hash = excluded.content_hash,
                metadata = excluded.metadata,
                version = excluded.version,
                updated_at = datetime('now'),
                synced = 0",
            params![file.id, file.project_id, file.path, file.content_hash, file.metadata, file.version],
        )?;
        Ok(())
    }

    pub fn find_by_project(&self, project_id: &str) -> Result<Vec<FileRecord>> {
        let conn = self.conn.lock().unwrap();
        let mut stmt = conn.prepare(
            "SELECT id, project_id, path, content_hash, metadata, version FROM files WHERE project_id = ?1"
        )?;

        let files = stmt.query_map(params![project_id], |row| {
            Ok(FileRecord {
                id: row.get(0)?,
                project_id: row.get(1)?,
                path: row.get(2)?,
                content_hash: row.get(3)?,
                metadata: row.get(4)?,
                version: row.get(5)?,
            })
        })?.collect::<Result<Vec<_>>>()?;

        Ok(files)
    }

    pub fn unsynced(&self) -> Result<Vec<FileRecord>> {
        let conn = self.conn.lock().unwrap();
        let mut stmt = conn.prepare(
            "SELECT id, project_id, path, content_hash, metadata, version FROM files WHERE synced = 0"
        )?;
        stmt.query_map([], |row| {
            Ok(FileRecord {
                id: row.get(0)?,
                project_id: row.get(1)?,
                path: row.get(2)?,
                content_hash: row.get(3)?,
                metadata: row.get(4)?,
                version: row.get(5)?,
            })
        })?.collect()
    }
}
```

## Tantivy Search Index Pattern

```rust
use tantivy::{
    schema::{Schema, TEXT, STORED, STRING, FAST},
    Index, IndexWriter, IndexReader,
    collector::TopDocs,
    query::QueryParser,
};

pub struct CodeIndex {
    index: Index,
    writer: IndexWriter,
    reader: IndexReader,
    query_parser: QueryParser,
}

impl CodeIndex {
    pub fn new(index_path: &str) -> Result<Self, anyhow::Error> {
        let mut schema_builder = Schema::builder();
        let path_field = schema_builder.add_text_field("path", STRING | STORED);
        let content_field = schema_builder.add_text_field("content", TEXT);
        let language_field = schema_builder.add_text_field("language", STRING | STORED);
        let project_field = schema_builder.add_text_field("project_id", STRING);
        let schema = schema_builder.build();

        let index = Index::create_in_dir(index_path, schema.clone())?;
        let writer = index.writer(50_000_000)?; // 50MB heap
        let reader = index.reader()?;
        let query_parser = QueryParser::for_index(&index, vec![content_field, path_field]);

        Ok(Self { index, writer, reader, query_parser })
    }

    pub fn index_file(&mut self, project_id: &str, path: &str, content: &str, language: &str) -> Result<(), anyhow::Error> {
        let schema = self.index.schema();
        let mut doc = tantivy::TantivyDocument::new();
        doc.add_text(schema.get_field("path").unwrap(), path);
        doc.add_text(schema.get_field("content").unwrap(), content);
        doc.add_text(schema.get_field("language").unwrap(), language);
        doc.add_text(schema.get_field("project_id").unwrap(), project_id);
        self.writer.add_document(doc)?;
        self.writer.commit()?;
        Ok(())
    }

    pub fn search(&self, query: &str, limit: usize) -> Result<Vec<SearchResult>, anyhow::Error> {
        let searcher = self.reader.searcher();
        let query = self.query_parser.parse_query(query)?;
        let top_docs = searcher.search(&query, &TopDocs::with_limit(limit))?;

        let schema = self.index.schema();
        let results = top_docs.into_iter().map(|(score, doc_addr)| {
            let doc: tantivy::TantivyDocument = searcher.doc(doc_addr).unwrap();
            SearchResult {
                path: doc.get_first(schema.get_field("path").unwrap()).unwrap().as_str().unwrap().to_string(),
                language: doc.get_first(schema.get_field("language").unwrap()).unwrap().as_str().unwrap().to_string(),
                score,
            }
        }).collect();

        Ok(results)
    }
}
```

## Error Handling

```rust
use thiserror::Error;

#[derive(Error, Debug)]
pub enum EngineError {
    #[error("Database error: {0}")]
    Database(#[from] rusqlite::Error),

    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),

    #[error("Parse error: {0}")]
    Parse(String),

    #[error("Index error: {0}")]
    Index(#[from] tantivy::TantivyError),

    #[error("gRPC error: {0}")]
    Grpc(#[from] tonic::Status),

    #[error("Config error: {0}")]
    Config(String),
}

// Convert EngineError to tonic::Status for gRPC responses
impl From<EngineError> for tonic::Status {
    fn from(err: EngineError) -> Self {
        match err {
            EngineError::Parse(msg) => tonic::Status::invalid_argument(msg),
            EngineError::Config(msg) => tonic::Status::failed_precondition(msg),
            _ => tonic::Status::internal(err.to_string()),
        }
    }
}
```

## Testing Pattern

```rust
#[cfg(test)]
mod tests {
    use super::*;
    use tempfile::TempDir;

    #[test]
    fn test_parser_rust() {
        let parser = Parser::new();
        let result = parser.parse("fn main() {}", "rust").unwrap();
        assert!(result.nodes.len() > 0);
    }

    #[test]
    fn test_file_repo_upsert() {
        let dir = TempDir::new().unwrap();
        let db_path = dir.path().join("test.db");
        let repo = FileRepo::new(db_path.to_str().unwrap()).unwrap();

        let file = FileRecord {
            id: "test-1".into(),
            project_id: "proj-1".into(),
            path: "src/main.rs".into(),
            content_hash: Some("abc123".into()),
            metadata: "{}".into(),
            version: 1,
        };
        repo.upsert(&file).unwrap();

        let files = repo.find_by_project("proj-1").unwrap();
        assert_eq!(files.len(), 1);
        assert_eq!(files[0].path, "src/main.rs");
    }

    #[tokio::test]
    async fn test_search_index() {
        let dir = TempDir::new().unwrap();
        let mut index = CodeIndex::new(dir.path().to_str().unwrap()).unwrap();
        index.index_file("p1", "main.rs", "fn main() { println!(\"hello\"); }", "rust").unwrap();

        let results = index.search("println", 10).unwrap();
        assert_eq!(results.len(), 1);
    }
}
```

## LSP Server (tower-lsp)

```rust
use tower_lsp::jsonrpc::Result;
use tower_lsp::lsp_types::*;
use tower_lsp::{Client, LanguageServer, LspService, Server};

struct OrchestraLSP {
    client: Client,
    parser: Parser,
    index: CodeIndex,
}

#[tower_lsp::async_trait]
impl LanguageServer for OrchestraLSP {
    async fn initialize(&self, _: InitializeParams) -> Result<InitializeResult> {
        Ok(InitializeResult {
            capabilities: ServerCapabilities {
                text_document_sync: Some(TextDocumentSyncCapability::Kind(TextDocumentSyncKind::INCREMENTAL)),
                completion_provider: Some(CompletionOptions::default()),
                hover_provider: Some(HoverProviderCapability::Simple(true)),
                definition_provider: Some(OneOf::Left(true)),
                references_provider: Some(OneOf::Left(true)),
                document_formatting_provider: Some(OneOf::Left(true)),
                ..Default::default()
            },
            ..Default::default()
        })
    }

    async fn completion(&self, params: CompletionParams) -> Result<Option<CompletionResponse>> {
        let uri = params.text_document_position.text_document.uri;
        let position = params.text_document_position.position;
        // Use parser + index for intelligent completions
        let items = self.parser.completions_at(&uri, position).await;
        Ok(Some(CompletionResponse::Array(items)))
    }

    async fn hover(&self, params: HoverParams) -> Result<Option<Hover>> {
        let uri = params.text_document_position_params.text_document.uri;
        let pos = params.text_document_position_params.position;
        let info = self.parser.hover_info(&uri, pos).await;
        Ok(info.map(|content| Hover {
            contents: HoverContents::Markup(MarkupContent {
                kind: MarkupKind::Markdown,
                value: content,
            }),
            range: None,
        }))
    }

    async fn shutdown(&self) -> Result<()> {
        Ok(())
    }
}

// Start the LSP server (stdin/stdout)
pub async fn start_lsp() {
    let stdin = tokio::io::stdin();
    let stdout = tokio::io::stdout();
    let (service, socket) = LspService::new(|client| OrchestraLSP {
        client,
        parser: Parser::new(),
        index: CodeIndex::new("./index").unwrap(),
    });
    Server::new(stdin, stdout, socket).serve(service).await;
}
```

## Text Manipulation (ropey)

```rust
use ropey::Rope;

pub struct DocumentBuffer {
    rope: Rope,
}

impl DocumentBuffer {
    pub fn new(text: &str) -> Self {
        Self { rope: Rope::from_str(text) }
    }

    pub fn insert(&mut self, line: usize, col: usize, text: &str) {
        let idx = self.rope.line_to_char(line) + col;
        self.rope.insert(idx, text);
    }

    pub fn delete(&mut self, start_line: usize, start_col: usize, end_line: usize, end_col: usize) {
        let start = self.rope.line_to_char(start_line) + start_col;
        let end = self.rope.line_to_char(end_line) + end_col;
        self.rope.remove(start..end);
    }

    pub fn line(&self, idx: usize) -> &str {
        self.rope.line(idx).as_str().unwrap_or("")
    }

    pub fn line_count(&self) -> usize {
        self.rope.len_lines()
    }

    pub fn to_string(&self) -> String {
        self.rope.to_string()
    }
}
```

## Concurrent Maps (dashmap)

```rust
use dashmap::DashMap;

pub struct SessionManager {
    sessions: DashMap<String, EditorSession>,
}

impl SessionManager {
    pub fn new() -> Self {
        Self { sessions: DashMap::new() }
    }

    pub fn create(&self, id: String, session: EditorSession) {
        self.sessions.insert(id, session);
    }

    pub fn get(&self, id: &str) -> Option<dashmap::mapref::one::Ref<String, EditorSession>> {
        self.sessions.get(id)
    }

    pub fn remove(&self, id: &str) -> Option<(String, EditorSession)> {
        self.sessions.remove(id)
    }

    pub fn count(&self) -> usize {
        self.sessions.len()
    }
}
```

## Encryption (ring)

```rust
use ring::aead::{Aad, LessSafeKey, Nonce, UnboundKey, AES_256_GCM};
use ring::rand::{SecureRandom, SystemRandom};

pub struct Vault {
    key: LessSafeKey,
    rng: SystemRandom,
}

impl Vault {
    pub fn new(key_bytes: &[u8; 32]) -> Self {
        let unbound = UnboundKey::new(&AES_256_GCM, key_bytes).unwrap();
        Self {
            key: LessSafeKey::new(unbound),
            rng: SystemRandom::new(),
        }
    }

    pub fn encrypt(&self, plaintext: &[u8]) -> Result<Vec<u8>, ring::error::Unspecified> {
        let mut nonce_bytes = [0u8; 12];
        self.rng.fill(&mut nonce_bytes)?;
        let nonce = Nonce::assume_unique_for_key(nonce_bytes);

        let mut data = plaintext.to_vec();
        self.key.seal_in_place_append_tag(nonce, Aad::empty(), &mut data)?;

        // Prepend nonce to ciphertext
        let mut result = nonce_bytes.to_vec();
        result.extend_from_slice(&data);
        Ok(result)
    }

    pub fn decrypt(&self, ciphertext: &[u8]) -> Result<Vec<u8>, ring::error::Unspecified> {
        let (nonce_bytes, encrypted) = ciphertext.split_at(12);
        let nonce = Nonce::assume_unique_for_key(nonce_bytes.try_into().unwrap());

        let mut data = encrypted.to_vec();
        let plaintext = self.key.open_in_place(nonce, Aad::empty(), &mut data)?;
        Ok(plaintext.to_vec())
    }
}
```

## Updated Cargo.toml (Additional Dependencies)

```toml
# Add to existing [dependencies]
tower-lsp = "0.20"       # LSP server framework
ropey = "1.6"             # Efficient text rope for large files
dashmap = "6"             # Concurrent HashMap (no Mutex needed)
ring = "0.17"             # Encryption (AES-256-GCM)
# zstd and aes-gcm already listed above
```

## Conventions

- Use `thiserror` for library errors, `anyhow` for application-level errors
- All async code uses `tokio` runtime
- gRPC handlers are in `handlers/`, business logic in `services/`
- Local SQLite managed via `rusqlite` with `Mutex<Connection>` for thread safety
- Proto code generated into `src/gen/` via `build.rs`
- Tests use `tempfile::TempDir` for temporary databases and indexes
- Logging via `tracing` crate (not `println!` or `log`)
- Use `ropey::Rope` for editing large files (not `String`)
- Use `DashMap` for concurrent shared state (not `Mutex<HashMap>`)
- Use `ring` for encryption, not `openssl` (pure Rust, no system deps)
- LSP server via `tower-lsp` — Orchestra's own language intelligence

## Don'ts

- Don't use `unwrap()` in production code — use `?` operator or explicit error handling
- Don't hold `Mutex` locks across `.await` points — use `tokio::sync::Mutex` for async
- Don't compile proto with buf for Rust — use `tonic-build` in `build.rs`
- Don't store large files in rusqlite — use content-addressable storage on disk
- Don't block the async runtime — use `tokio::task::spawn_blocking` for CPU-heavy ops
- Don't use `String` for large file manipulation — use `ropey::Rope`
- Don't use `Mutex<HashMap>` for hot concurrent maps — use `dashmap::DashMap`
