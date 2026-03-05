---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    Markdown tables are not rendered at all. Table syntax appears as raw text.

    ## Current State
    - `apps/swift/Shared/Sources/Shared/Components/MarkdownContentView.swift` (385 lines) — supports paragraphs, headings, code blocks, blockquotes, lists, horizontal rules but has NO table parsing or rendering
    - Uses custom regex-based markdown parser, not a library

    ## Requirements
    1. Parse GFM (GitHub Flavored Markdown) table syntax: `| col1 | col2 |` with `|---|---|` separator
    2. Render as a native SwiftUI table/grid with proper column alignment
    3. Support left/center/right alignment via `:---`, `:---:`, `---:` syntax
    4. Header row styled differently (bold, background color)
    5. Alternating row colors for readability
    6. Horizontal scroll for wide tables
    7. Cell content supports inline markdown (bold, code, links)
    8. Table must be selectable (cells copyable)

    ## Affected Files
    - `apps/swift/Shared/Sources/Shared/Components/MarkdownContentView.swift`
estimate: M
id: FEAT-LEK
kind: feature
labels:
    - plan:PLAN-YST
priority: P1
project_id: orchestra-swift-enhancement
status: backlog
title: Markdown Tables Rendering
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# Markdown Tables Rendering

## Problem
Markdown tables are not rendered at all. Table syntax appears as raw text.

## Current State
- `apps/swift/Shared/Sources/Shared/Components/MarkdownContentView.swift` (385 lines) — supports paragraphs, headings, code blocks, blockquotes, lists, horizontal rules but has NO table parsing or rendering
- Uses custom regex-based markdown parser, not a library

## Requirements
1. Parse GFM (GitHub Flavored Markdown) table syntax: `| col1 | col2 |` with `|---|---|` separator
2. Render as a native SwiftUI table/grid with proper column alignment
3. Support left/center/right alignment via `:---`, `:---:`, `---:` syntax
4. Header row styled differently (bold, background color)
5. Alternating row colors for readability
6. Horizontal scroll for wide tables
7. Cell content supports inline markdown (bold, code, links)
8. Table must be selectable (cells copyable)

## Affected Files
- `apps/swift/Shared/Sources/Shared/Components/MarkdownContentView.swift`
