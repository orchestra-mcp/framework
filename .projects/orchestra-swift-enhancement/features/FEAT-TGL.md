---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    No way to export code blocks as files or markdown.

    ## Requirements
    1. Right-click context menu on code blocks with export submenu
    2. 'Save as File': saves with appropriate extension based on language (e.g., .swift, .go, .ts)
    3. 'Copy as Markdown': copies with code fence and language tag
    4. 'Copy Code': copies raw code without formatting
    5. 'Open in Editor': opens in the built-in code editor (ties to feature #21)
    6. Save dialog defaults to detected filename if available from tool context

    ## Affected Files
    - `apps/swift/Shared/Sources/Shared/Services/ExportService.swift`
    - `apps/swift/Shared/Sources/Shared/Components/MarkdownContentView.swift`
estimate: S
id: FEAT-TGL
kind: feature
labels:
    - plan:PLAN-YST
priority: P2
project_id: orchestra-swift-enhancement
status: backlog
title: Export Code Block as File/Markdown
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# Export Code Block as File/Markdown

## Problem
No way to export code blocks as files or markdown.

## Requirements
1. Right-click context menu on code blocks with export submenu
2. 'Save as File': saves with appropriate extension based on language (e.g., .swift, .go, .ts)
3. 'Copy as Markdown': copies with code fence and language tag
4. 'Copy Code': copies raw code without formatting
5. 'Open in Editor': opens in the built-in code editor (ties to feature #21)
6. Save dialog defaults to detected filename if available from tool context

## Affected Files
- `apps/swift/Shared/Sources/Shared/Services/ExportService.swift`
- `apps/swift/Shared/Sources/Shared/Components/MarkdownContentView.swift`
