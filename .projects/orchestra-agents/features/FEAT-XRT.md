---
estimate: M
id: FEAT-XRT
kind: feature
priority: P1
project_slug: orchestra-agents
status: todo
title: Local RAG integration with SQLite-backed data
type: feature
---

# Local RAG integration with SQLite-backed data

Connect engine-rag (Rust) to read from the local SQLite database for embeddings and vector search. On data change, re-index affected entries in Tantivy. Memory and context tools pull from SQLite instead of file system. This unifies the data flow: SQLite is the single local source of truth for both MCP tools and RAG.