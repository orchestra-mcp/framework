---
id: FEAT-VTK
kind: feature
priority: P1
project_slug: orchestra-tools
status: done
title: Wiki / documentation plugin (tools.docs)
type: feature
---

# Wiki / documentation plugin (tools.docs)

Thin orchestration over engine-rag. Tools: doc_create, doc_get, doc_update, doc_delete, doc_list, doc_search, doc_generate, doc_index, doc_tree, doc_export. Storage: .projects/{project}/docs/{slug}.md. Cross-plugin calls to engine-rag for parse_file, get_symbols, search, search_memory, index_file. Depends on PLUGIN-MARKDOWN.

---
**in-progress -> done**: 14 tests passing (doc_create with category/tags, doc_get, doc_list with category filter, doc_delete, doc_search). In-memory mock StorageClient. Binary built to bin/tools-docs. Wired into plugins.yaml with depends_on: tools.markdown.