---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    No way to export table data in structured formats.

    ## Requirements
    1. Right-click context menu on tables with export submenu
    2. Export as CSV: comma-separated values with proper escaping
    3. Export as TSV: tab-separated (pasteable into Excel/Google Sheets)
    4. Export as Markdown: raw markdown table syntax
    5. Export as HTML: styled HTML table
    6. Save dialog with format picker
    7. Copy to clipboard option for each format

    ## Affected Files
    - `apps/swift/Shared/Sources/Shared/Services/ExportService.swift`
    - `apps/swift/Shared/Sources/Shared/Components/MarkdownContentView.swift`
estimate: S
id: FEAT-YDD
kind: feature
labels:
    - plan:PLAN-YST
priority: P2
project_id: orchestra-swift-enhancement
status: backlog
title: Export Table as CSV/Doc/Excel
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# Export Table as CSV/Doc/Excel

## Problem
No way to export table data in structured formats.

## Requirements
1. Right-click context menu on tables with export submenu
2. Export as CSV: comma-separated values with proper escaping
3. Export as TSV: tab-separated (pasteable into Excel/Google Sheets)
4. Export as Markdown: raw markdown table syntax
5. Export as HTML: styled HTML table
6. Save dialog with format picker
7. Copy to clipboard option for each format

## Affected Files
- `apps/swift/Shared/Sources/Shared/Services/ExportService.swift`
- `apps/swift/Shared/Sources/Shared/Components/MarkdownContentView.swift`
