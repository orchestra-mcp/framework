---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    Headings (#, ##, ###) are not rendered with proper styling. They appear as plain text with # prefix.

    ## Current State
    - `apps/swift/Shared/Sources/Shared/Components/MarkdownContentView.swift` — has heading detection in the parser but styling may not differentiate heading levels properly

    ## Requirements
    1. H1: 28pt bold, extra bottom padding, optional bottom border
    2. H2: 24pt bold, bottom padding
    3. H3: 20pt semibold
    4. H4: 18pt semibold
    5. H5: 16pt medium
    6. H6: 14pt medium, muted color
    7. Proper spacing before/after headings
    8. Headings should be anchorable (for future table-of-contents linking)

    ## Affected Files
    - `apps/swift/Shared/Sources/Shared/Components/MarkdownContentView.swift`
estimate: S
id: FEAT-DTH
kind: bug
labels:
    - plan:PLAN-YST
priority: P1
project_id: orchestra-swift-enhancement
status: backlog
title: Markdown Headings Rendering (H1-H6)
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# Markdown Headings Rendering (H1-H6)

## Problem
Headings (#, ##, ###) are not rendered with proper styling. They appear as plain text with # prefix.

## Current State
- `apps/swift/Shared/Sources/Shared/Components/MarkdownContentView.swift` — has heading detection in the parser but styling may not differentiate heading levels properly

## Requirements
1. H1: 28pt bold, extra bottom padding, optional bottom border
2. H2: 24pt bold, bottom padding
3. H3: 20pt semibold
4. H4: 18pt semibold
5. H5: 16pt medium
6. H6: 14pt medium, muted color
7. Proper spacing before/after headings
8. Headings should be anchorable (for future table-of-contents linking)

## Affected Files
- `apps/swift/Shared/Sources/Shared/Components/MarkdownContentView.swift`
