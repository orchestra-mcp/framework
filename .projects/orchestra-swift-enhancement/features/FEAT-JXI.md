---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    No way to export individual messages from the chat.

    ## Requirements
    1. Right-click / long-press on any message shows context menu
    2. 'Copy as Markdown': copies the full message as markdown
    3. 'Export as Markdown File': saves as .md file
    4. 'Export as PDF': renders markdown to PDF
    5. 'Export as HTML': standalone HTML with styling
    6. Include tool call results in export if present
    7. Include thinking section if present (collapsible in HTML/PDF)
    8. Message metadata header: timestamp, model, token count

    ## Affected Files
    - `apps/swift/Shared/Sources/Shared/Services/ExportService.swift`
    - `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift` (message context menu)
estimate: M
id: FEAT-JXI
kind: feature
labels:
    - plan:PLAN-YST
priority: P2
project_id: orchestra-swift-enhancement
status: backlog
title: Export Any Message as Markdown/Docs via Context Menu
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# Export Any Message as Markdown/Docs via Context Menu

## Problem
No way to export individual messages from the chat.

## Requirements
1. Right-click / long-press on any message shows context menu
2. 'Copy as Markdown': copies the full message as markdown
3. 'Export as Markdown File': saves as .md file
4. 'Export as PDF': renders markdown to PDF
5. 'Export as HTML': standalone HTML with styling
6. Include tool call results in export if present
7. Include thinking section if present (collapsible in HTML/PDF)
8. Message metadata header: timestamp, model, token count

## Affected Files
- `apps/swift/Shared/Sources/Shared/Services/ExportService.swift`
- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift` (message context menu)
