use std::path::PathBuf;
use std::sync::Arc;

use anyhow::Result;
use tonic::{Request, Response, Status};
use tracing::info;

use crate::db::Database;
use crate::proto;
use crate::proto::memory_service_server::MemoryService;

/// MemoryServiceImpl implements the gRPC MemoryService using Tantivy + SQLite.
pub struct MemoryServiceImpl {
    db: Arc<Database>,
    _workspace: String,
}

impl MemoryServiceImpl {
    pub fn new(workspace: &str) -> Result<Self> {
        let db_path = PathBuf::from(workspace)
            .join(".projects")
            .join(".memory")
            .join("vectors.db");
        std::fs::create_dir_all(db_path.parent().unwrap())?;
        let db = Database::open(&db_path)?;
        info!("Memory database opened at {:?}", db_path);
        Ok(Self {
            db: Arc::new(db),
            _workspace: workspace.to_string(),
        })
    }
}

#[tonic::async_trait]
impl MemoryService for MemoryServiceImpl {
    async fn store_chunk(
        &self,
        request: Request<proto::StoreChunkRequest>,
    ) -> Result<Response<proto::StoreChunkResponse>, Status> {
        let req = request.into_inner();
        let id = format!("mem-{}", uuid::Uuid::new_v4());
        let now = chrono::Utc::now().to_rfc3339();
        let tags_str = serde_json::to_string(&req.tags).unwrap_or_default();

        let conn = self.db.conn.lock().unwrap();
        conn.execute(
            "INSERT INTO chunks (id, project, source, source_id, summary, content, tags, created_at)
             VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8)",
            rusqlite::params![
                id, req.project, req.source, req.source_id,
                req.summary, req.content, tags_str, now
            ],
        )
        .map_err(|e| Status::internal(e.to_string()))?;

        Ok(Response::new(proto::StoreChunkResponse {
            chunk: Some(proto::MemoryChunk {
                id,
                project: req.project,
                source: req.source,
                source_id: req.source_id,
                summary: req.summary,
                content: req.content,
                tags: req.tags,
                created_at: now,
                score: 0.0,
            }),
        }))
    }

    async fn search_memory(
        &self,
        request: Request<proto::SearchRequest>,
    ) -> Result<Response<proto::SearchResponse>, Status> {
        let req = request.into_inner();
        let limit = if req.limit > 0 { req.limit } else { 10 };
        let query_lower = req.query.to_lowercase();
        let words: Vec<&str> = query_lower.split_whitespace().collect();

        let conn = self.db.conn.lock().unwrap();
        let mut stmt = conn
            .prepare(
                "SELECT id, project, source, source_id, summary, content, tags, created_at
                 FROM chunks WHERE project = ?1 ORDER BY created_at DESC",
            )
            .map_err(|e| Status::internal(e.to_string()))?;

        let chunks: Vec<proto::MemoryChunk> = stmt
            .query_map(rusqlite::params![req.project], |row| {
                let tags_str: String = row.get(6)?;
                let tags: Vec<String> = serde_json::from_str(&tags_str).unwrap_or_default();
                Ok(proto::MemoryChunk {
                    id: row.get(0)?,
                    project: row.get(1)?,
                    source: row.get(2)?,
                    source_id: row.get(3)?,
                    summary: row.get(4)?,
                    content: row.get(5)?,
                    tags,
                    created_at: row.get(7)?,
                    score: 0.0,
                })
            })
            .map_err(|e| Status::internal(e.to_string()))?
            .filter_map(|r| r.ok())
            .collect();

        let mut scored: Vec<proto::MemoryChunk> = chunks
            .into_iter()
            .filter_map(|mut c| {
                let text = format!("{} {} {}", c.summary, c.content, c.tags.join(" ")).to_lowercase();
                let matches = words.iter().filter(|w| text.contains(*w)).count();
                if matches > 0 {
                    c.score = matches as f32 / words.len() as f32;
                    Some(c)
                } else {
                    None
                }
            })
            .collect();

        scored.sort_by(|a, b| b.score.partial_cmp(&a.score).unwrap());
        scored.truncate(limit as usize);

        Ok(Response::new(proto::SearchResponse { results: scored }))
    }

    async fn get_context(
        &self,
        request: Request<proto::ContextRequest>,
    ) -> Result<Response<proto::ContextResponse>, Status> {
        let req = request.into_inner();
        let search_req = proto::SearchRequest {
            project: req.project,
            query: req.query,
            limit: req.limit,
        };
        let resp = self
            .search_memory(Request::new(search_req))
            .await?
            .into_inner();
        Ok(Response::new(proto::ContextResponse {
            chunks: resp.results,
        }))
    }

    async fn store_session(
        &self,
        request: Request<proto::StoreSessionRequest>,
    ) -> Result<Response<proto::StoreSessionResponse>, Status> {
        let req = request.into_inner();
        let now = chrono::Utc::now().to_rfc3339();
        let events_str = serde_json::to_string(&req.events).unwrap_or_default();

        let conn = self.db.conn.lock().unwrap();
        conn.execute(
            "INSERT OR REPLACE INTO sessions (session_id, project, summary, events, started_at)
             VALUES (?1, ?2, ?3, ?4, ?5)",
            rusqlite::params![req.session_id, req.project, req.summary, events_str, now],
        )
        .map_err(|e| Status::internal(e.to_string()))?;

        Ok(Response::new(proto::StoreSessionResponse {
            session: Some(proto::SessionLog {
                session_id: req.session_id,
                project: req.project,
                summary: req.summary,
                events: req.events,
                started_at: now,
                ended_at: String::new(),
            }),
        }))
    }

    async fn list_sessions(
        &self,
        request: Request<proto::ListSessionsRequest>,
    ) -> Result<Response<proto::ListSessionsResponse>, Status> {
        let req = request.into_inner();
        let limit = if req.limit > 0 { req.limit } else { 20 };

        let conn = self.db.conn.lock().unwrap();
        let mut stmt = conn
            .prepare(
                "SELECT session_id, project, summary, events, started_at, ended_at
                 FROM sessions WHERE project = ?1 ORDER BY started_at DESC LIMIT ?2",
            )
            .map_err(|e| Status::internal(e.to_string()))?;

        let sessions: Vec<proto::SessionLog> = stmt
            .query_map(rusqlite::params![req.project, limit], |row| {
                let events_str: String = row.get(3)?;
                let ended: Option<String> = row.get(5)?;
                Ok(proto::SessionLog {
                    session_id: row.get(0)?,
                    project: row.get(1)?,
                    summary: row.get(2)?,
                    events: serde_json::from_str(&events_str).unwrap_or_default(),
                    started_at: row.get(4)?,
                    ended_at: ended.unwrap_or_default(),
                })
            })
            .map_err(|e| Status::internal(e.to_string()))?
            .filter_map(|r| r.ok())
            .collect();

        Ok(Response::new(proto::ListSessionsResponse { sessions }))
    }

    async fn get_session(
        &self,
        request: Request<proto::GetSessionRequest>,
    ) -> Result<Response<proto::GetSessionResponse>, Status> {
        let req = request.into_inner();

        let conn = self.db.conn.lock().unwrap();
        let session = conn
            .query_row(
                "SELECT session_id, project, summary, events, started_at, ended_at
                 FROM sessions WHERE project = ?1 AND session_id = ?2",
                rusqlite::params![req.project, req.session_id],
                |row| {
                    let events_str: String = row.get(3)?;
                    let ended: Option<String> = row.get(5)?;
                    Ok(proto::SessionLog {
                        session_id: row.get(0)?,
                        project: row.get(1)?,
                        summary: row.get(2)?,
                        events: serde_json::from_str(&events_str).unwrap_or_default(),
                        started_at: row.get(4)?,
                        ended_at: ended.unwrap_or_default(),
                    })
                },
            )
            .map_err(|e| Status::not_found(e.to_string()))?;

        Ok(Response::new(proto::GetSessionResponse {
            session: Some(session),
        }))
    }
}
