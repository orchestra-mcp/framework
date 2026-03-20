---
id: FEAT-LKV
kind: feature
priority: P1
project_slug: orchestra-rag
status: done
title: Parse service (Tree-sitter)
type: feature
---

# Parse service (Tree-sitter)

Code parsing for 14 languages via Tree-sitter. Tools: parse_file (AST extraction), get_symbols (function/class/variable extraction). Port from orch-ref/engine/src/parser/.


---
**backlog -> todo**: Moving to todo - Parse service is fully implemented


---
**in-progress -> ready-for-testing**: Implementation complete: parser/registry.rs (14 language grammars - Rust, Go, JS, TS, Python, C, C++, Java, HTML, CSS, JSON, TOML, YAML, Markdown), parser/wrapper.rs (Tree-sitter wrapper with language detection), parser/symbols.rs (SymbolExtractor with language-specific queries for Rust, Go, JS/TS, Python, Java + generic fallback). Tools: parse_file (AST + symbols), get_symbols (with type filter). All parser tests pass.


---
**ready-for-testing -> in-testing**: Testing: All parser tests pass - parse_file_rust, parse_file_auto_detect_language, parse_file_missing_content, get_symbols_rust, get_symbols_with_filter, get_symbols_empty_code, extract_symbol_names_works, extract_symbol_names_unsupported_language. 14 grammars verified.


---
**in-testing -> ready-for-docs**: Coverage verified: parse_file with/without AST, auto language detection from extension, missing content error, symbol extraction for all 5 language-specific extractors + generic fallback, symbol type filtering, empty code handling.


---
**ready-for-docs -> in-docs**: Docs: Module-level rustdoc on parser/registry.rs, parser/wrapper.rs, parser/symbols.rs. Tool definitions include JSON Schema with descriptions for all parameters. parse_file and get_symbols tools have complete parameter docs.


---
**in-docs -> documented**: Documentation complete for parse service.


---
**documented -> in-review**: Review: Follows Orchestra Rust conventions - thiserror/anyhow error handling, tracing logging, spawn_blocking for Tree-sitter (which is !Send), Mutex-protected parser. 14 language grammars with extensible registry pattern. Symbol extraction uses language-specific Tree-sitter queries.


---
**in-review -> done**: Approved: Parse service with 14 Tree-sitter grammars, symbol extraction, auto language detection. 2 tools (parse_file, get_symbols). All tests pass.