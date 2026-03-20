---
estimate: M
id: FEAT-FVY
kind: feature
priority: P2
project_slug: orchestra-swift-enhancement
status: backlog
title: Export Code Block and Table as Image
type: feature
---

# Export Code Block and Table as Image

## Problem
No way to export code blocks or tables as images for sharing.

## Requirements
1. Long-press / right-click context menu on code blocks with 'Export as Image' option
2. Long-press / right-click context menu on tables with 'Export as Image' option
3. Render the content to an NSImage with configurable background
4. Save dialog or copy to clipboard
5. Image includes: content, language badge (for code), proper padding
6. Configurable image background color/gradient (ties to feature #11)
7. Retina resolution export (2x)
8. Option to include/exclude line numbers in code export

## Affected Files
- NEW: `apps/swift/Shared/Sources/Shared/Services/ExportService.swift`
- `apps/swift/Shared/Sources/Shared/Components/MarkdownContentView.swift` (context menus)