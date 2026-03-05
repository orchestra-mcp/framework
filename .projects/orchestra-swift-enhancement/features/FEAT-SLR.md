---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    The @ file mention trigger uses `list_directory` MCP tool for browsing, which is slow. Should use the Rust engine's Tantivy index for instant file search.

    ## Current State
    - `apps/swift/Shared/Sources/Shared/Services/TriggerService.swift` — uses `list_directory` and `file_search` MCP tools
    - `#` memory trigger already uses Rust engine's `search_memory`
    - Rust engine has `index_directory`, `search`, `search_symbols` tools

    ## Requirements
    1. On workspace open, trigger `index_directory` via Rust engine to index the workspace
    2. @ trigger uses Rust engine `search` tool for instant file name matching
    3. Results show file path, file type icon, last modified date
    4. Fuzzy matching support (e.g., 'mrkdwn' matches 'MarkdownContentView.swift')
    5. Directory browsing mode: typing `@src/` shows contents of src/ directory
    6. Recent files section at top of dropdown
    7. File preview on hover (first few lines)
    8. Fallback to `list_directory` if Rust engine is unavailable

    ## Affected Files
    - `apps/swift/Shared/Sources/Shared/Services/TriggerService.swift`
    - `apps/swift/Shared/Sources/Shared/Components/InputBarContent.swift`
estimate: M
id: FEAT-SLR
kind: feature
labels:
    - plan:PLAN-YST
priority: P2
project_id: orchestra-swift-enhancement
status: backlog
title: '@ File Explorer Uses Rust Engine for Fast File Search'
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# @ File Explorer Uses Rust Engine for Fast File Search

## Problem
The @ file mention trigger uses `list_directory` MCP tool for browsing, which is slow. Should use the Rust engine's Tantivy index for instant file search.

## Current State
- `apps/swift/Shared/Sources/Shared/Services/TriggerService.swift` — uses `list_directory` and `file_search` MCP tools
- `#` memory trigger already uses Rust engine's `search_memory`
- Rust engine has `index_directory`, `search`, `search_symbols` tools

## Requirements
1. On workspace open, trigger `index_directory` via Rust engine to index the workspace
2. @ trigger uses Rust engine `search` tool for instant file name matching
3. Results show file path, file type icon, last modified date
4. Fuzzy matching support (e.g., 'mrkdwn' matches 'MarkdownContentView.swift')
5. Directory browsing mode: typing `@src/` shows contents of src/ directory
6. Recent files section at top of dropdown
7. File preview on hover (first few lines)
8. Fallback to `list_directory` if Rust engine is unavailable

## Affected Files
- `apps/swift/Shared/Sources/Shared/Services/TriggerService.swift`
- `apps/swift/Shared/Sources/Shared/Components/InputBarContent.swift`
