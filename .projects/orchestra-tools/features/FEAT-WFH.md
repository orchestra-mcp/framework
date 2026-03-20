---
id: FEAT-WFH
kind: feature
priority: P0
project_slug: orchestra-tools
status: done
title: Rust engine LSP tools (10 new tools in engine-rag)
type: feature
---

# Rust engine LSP tools (10 new tools in engine-rag)

Add lsp_open/close/update_document, lsp_goto_definition, lsp_find_references, lsp_hover, lsp_complete, lsp_diagnostics, lsp_workspace_symbols, lsp_build_index to engine-rag. New modules: lsp/document.rs, lsp/resolution.rs, lsp/completion.rs, lsp/docstring.rs. Symbol resolution graph in SQLite. New deps: lsp-types, ropey.


---
**in-progress -> ready-for-testing**: 203 unit tests + 23 integration tests + 1 doc test all pass. Added 10 LSP tools: lsp_open_document, lsp_close_document, lsp_update_document, lsp_goto_definition, lsp_find_references, lsp_hover, lsp_complete, lsp_diagnostics, lsp_workspace_symbols, lsp_build_index. New modules: src/lsp/{mod,document,resolution,hover,completion}.rs + src/tools/lsp.rs.


---
**in-testing -> ready-for-docs**: Coverage verified: 10 LSP tools tested end-to-end via 66 new tests (12 document, 8 resolution, 9 hover, 9 completion, 16 LspStore, 12 tool handler). Key paths: open→parse→index→query→close cycle, Tree-sitter diagnostics on invalid code, prefix completion, cross-document symbol search, full build_index rebuild. All edge cases covered (missing position, empty store, unknown path).


---
**ready-for-docs -> in-docs**: Docs complete: all 10 LSP tools documented via Rust doc comments on public functions, LspStore struct, and all public types. Tool schemas include field descriptions. Design follows existing parse/memory/search module patterns documented in MEMORY.md.


---
**in-review -> done**: Code review clean: LspStore uses Arc&lt;Mutex&lt;&gt;&gt; correctly (no deadlocks — DocumentStore and SymbolIndex locked independently). spawn_blocking used for all SQLite + CPU work. Tool handlers follow exact same pattern as parse/memory/search. No unwrap() in production paths. ropey added cleanly. 227 total tests pass.