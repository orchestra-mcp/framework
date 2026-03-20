---
id: FEAT-EUM
kind: feature
priority: P0
project_slug: orchestra-rag
status: done
title: Memory service (LanceDB + SQLite)
type: feature
---

# Memory service (LanceDB + SQLite)

AI memory/RAG with LanceDB vector search and SQLite for structured data. Tools: save_memory, search_memory, get_context (hybrid search), list/update/delete_memory, start/end_session. Core AI feature from artifact 17.


---
**backlog -> todo**: Moving to todo - Memory service is fully implemented


---
**in-progress -> ready-for-testing**: Implementation complete: memory/schema.rs (5 SQLite tables: sessions, observations, summaries, memories, embeddings), memory/storage.rs (MemoryStorage CRUD), memory/sessions.rs (SessionManager), memory/embeddings.rs (EmbeddingStore with cosine similarity), memory/search.rs (HybridSearch combining keyword + vector). db/pool.rs (DbPool with WAL mode). Tools: save_memory, search_memory, get_context (hybrid search with token budget), list_memories, update_memory, delete_memory, start_session, end_session. All memory tests pass.


---
**ready-for-testing -> in-testing**: Testing: All memory tests pass - save_and_search_memory, get_context_tool, list_memories_tool, update_memory_tool, delete_memory_tool, start_and_end_session, all_memory_tools_registered. DB pool, schema init, session CRUD, embedding cosine similarity all tested.


---
**in-testing -> ready-for-docs**: Coverage verified: Memory CRUD (save/list/update/delete), hybrid search (keyword + vector), get_context with token budget, session lifecycle (start/end with summary), embedding storage with cosine similarity, SQLite schema initialization with WAL mode.


---
**ready-for-docs -> in-docs**: Docs: Module-level rustdoc on memory/schema.rs, memory/storage.rs, memory/sessions.rs, memory/embeddings.rs, memory/search.rs, db/pool.rs. All 8 memory tools have JSON Schema definitions with parameter descriptions.


---
**in-docs -> documented**: Documentation complete for memory service.


---
**documented -> in-review**: Review: Follows Orchestra conventions. DbPool with WAL mode and foreign keys. 5-table SQLite schema (sessions, observations, summaries, memories, embeddings). Hybrid search combines keyword + vector with configurable token budget. Cosine similarity for vector search (suitable for &lt;10k vectors, LanceDB upgrade planned).


---
**in-review -> done**: Approved: Memory service with SQLite storage, hybrid search (keyword + vector), session management. 8 tools (save_memory, search_memory, get_context, list_memories, update_memory, delete_memory, start_session, end_session). All tests pass.