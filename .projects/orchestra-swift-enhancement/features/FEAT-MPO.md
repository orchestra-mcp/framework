---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    No way to view, create, or edit files within the app. Need a full code editor with LSP support for intelligent editing.

    ## Requirements
    1. Tabbed code editor panel (can be opened from tool cards or file explorer)
    2. Syntax highlighting for all supported languages (same as feature #7)
    3. LSP integration via Rust engine's `tower-lsp` for:
       - Autocomplete / IntelliSense
       - Go to definition
       - Find references
       - Hover documentation
       - Diagnostics (errors/warnings)
    4. Line numbers with clickable gutter
    5. Minimap scrollbar
    6. Find and replace (CMD+F within editor)
    7. Multiple cursors support
    8. Diff view mode: side-by-side and inline diff for file changes
    9. Read-only mode for viewing tool outputs
    10. File tabs with modified indicator (dot)
    11. CMD+S to save changes
    12. Undo/redo support
    13. Word wrap toggle
    14. Font size adjustment

    ## Affected Files
    - NEW: `apps/swift/Shared/Sources/Shared/Components/CodeEditor/` directory
    - NEW: `apps/swift/Shared/Sources/Shared/Components/CodeEditor/CodeEditorView.swift`
    - NEW: `apps/swift/Shared/Sources/Shared/Components/CodeEditor/DiffView.swift`
    - NEW: `apps/swift/Shared/Sources/Shared/Services/LSPService.swift`
estimate: XL
id: FEAT-MPO
kind: feature
labels:
    - plan:PLAN-YST
priority: P2
project_id: orchestra-swift-enhancement
status: backlog
title: Full Code Editor with LSP from Rust Engine
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# Full Code Editor with LSP from Rust Engine

## Problem
No way to view, create, or edit files within the app. Need a full code editor with LSP support for intelligent editing.

## Requirements
1. Tabbed code editor panel (can be opened from tool cards or file explorer)
2. Syntax highlighting for all supported languages (same as feature #7)
3. LSP integration via Rust engine's `tower-lsp` for:
   - Autocomplete / IntelliSense
   - Go to definition
   - Find references
   - Hover documentation
   - Diagnostics (errors/warnings)
4. Line numbers with clickable gutter
5. Minimap scrollbar
6. Find and replace (CMD+F within editor)
7. Multiple cursors support
8. Diff view mode: side-by-side and inline diff for file changes
9. Read-only mode for viewing tool outputs
10. File tabs with modified indicator (dot)
11. CMD+S to save changes
12. Undo/redo support
13. Word wrap toggle
14. Font size adjustment

## Affected Files
- NEW: `apps/swift/Shared/Sources/Shared/Components/CodeEditor/` directory
- NEW: `apps/swift/Shared/Sources/Shared/Components/CodeEditor/CodeEditorView.swift`
- NEW: `apps/swift/Shared/Sources/Shared/Components/CodeEditor/DiffView.swift`
- NEW: `apps/swift/Shared/Sources/Shared/Services/LSPService.swift`
