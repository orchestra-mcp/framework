---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    Code blocks have no syntax highlighting. All code appears as monospace plain text.

    ## Current State
    - `apps/swift/Shared/Sources/Shared/Components/MarkdownContentView.swift` — renders code blocks with monospace font and background color but no language-aware syntax highlighting
    - No syntax highlighting library is currently integrated

    ## Requirements
    1. Detect language from code fence (```swift, ```go, ```typescript, etc.)
    2. Apply syntax highlighting with theme-aware colors (light/dark mode)
    3. Support at minimum: Swift, Go, Rust, TypeScript, JavaScript, Python, JSON, YAML, SQL, Bash, HTML, CSS, Protobuf, Markdown
    4. Use Tree-sitter grammars via Rust engine OR a pure Swift highlighting library (Splash, Highlightr)
    5. Line numbers (toggleable)
    6. Copy button on code blocks
    7. Language label badge in top-right corner
    8. Horizontal scroll for long lines (no wrapping in code blocks)

    ## Affected Files
    - `apps/swift/Shared/Sources/Shared/Components/MarkdownContentView.swift`
    - NEW: `apps/swift/Shared/Sources/Shared/Components/SyntaxHighlightView.swift`
    - Possibly integrate Highlightr or similar Swift package
estimate: M
id: FEAT-BUY
kind: feature
labels:
    - plan:PLAN-YST
priority: P1
project_id: orchestra-swift-enhancement
status: backlog
title: Code Block Syntax Highlighting
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# Code Block Syntax Highlighting

## Problem
Code blocks have no syntax highlighting. All code appears as monospace plain text.

## Current State
- `apps/swift/Shared/Sources/Shared/Components/MarkdownContentView.swift` — renders code blocks with monospace font and background color but no language-aware syntax highlighting
- No syntax highlighting library is currently integrated

## Requirements
1. Detect language from code fence (```swift, ```go, ```typescript, etc.)
2. Apply syntax highlighting with theme-aware colors (light/dark mode)
3. Support at minimum: Swift, Go, Rust, TypeScript, JavaScript, Python, JSON, YAML, SQL, Bash, HTML, CSS, Protobuf, Markdown
4. Use Tree-sitter grammars via Rust engine OR a pure Swift highlighting library (Splash, Highlightr)
5. Line numbers (toggleable)
6. Copy button on code blocks
7. Language label badge in top-right corner
8. Horizontal scroll for long lines (no wrapping in code blocks)

## Affected Files
- `apps/swift/Shared/Sources/Shared/Components/MarkdownContentView.swift`
- NEW: `apps/swift/Shared/Sources/Shared/Components/SyntaxHighlightView.swift`
- Possibly integrate Highlightr or similar Swift package
