---
id: FEAT-KXR
kind: feature
priority: P1
project_slug: orchestra-rag
status: done
title: Search service (Tantivy)
type: feature
---

# Search service (Tantivy)

Full-text code search via Tantivy. Tools: index_file, search (fuzzy + filtered), delete_from_index, clear_index. Port from orch-ref/engine/src/index/.


---
**backlog -> todo**: Moving to todo - Search service is fully implemented


---
**in-progress -> ready-for-testing**: Implementation complete: index/schema.rs (Tantivy schema: path, content, language, symbols, metadata fields), index/writer.rs (add/delete/commit), index/reader.rs (search with scoring, snippets, line numbers, file type filter, pagination), index/manager.rs (lifecycle + clear). Tools: index_file (with upsert), search (query + limit + offset + file_types), delete_from_index, clear_index. All search/index tests pass.


---
**ready-for-testing -> in-testing**: Testing: All search tests pass - index_and_search_file, delete_from_index_tool, clear_index_tool, search_missing_query, all_search_tools_registered. Index writer/reader unit tests also pass (add_and_search, delete_document, search_with_offset, clear_index, reload_after_new_documents).


---
**in-testing -> ready-for-docs**: Coverage verified: Index add/search/delete/clear, upsert behavior (delete before add), search with offset/limit, file type filtering, missing query error, symbol extraction during indexing, index reload after writes.


---
**ready-for-docs -> in-docs**: Docs: Module-level rustdoc on index/schema.rs, index/writer.rs, index/reader.rs, index/manager.rs. Tool definitions include JSON Schema with descriptions. Search tool documents query, limit, offset, file_types parameters.


---
**in-docs -> documented**: Documentation complete for search service.


---
**documented -> in-review**: Review: Follows Orchestra conventions. Arc&lt;RwLock&lt;IndexManager&gt;&gt; for concurrent access. Tantivy schema with path/content/language/symbols/metadata fields. Upsert behavior (delete+add) prevents duplicates. Snippet extraction with line numbers for search results.


---
**in-review -> done**: Approved: Search service with Tantivy full-text indexing, fuzzy search, snippet extraction. 4 tools (index_file, search, delete_from_index, clear_index). All tests pass.