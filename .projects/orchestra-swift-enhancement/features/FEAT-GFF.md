---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    All tool executions look the same. Each Claude Code tool should have its own card design reflecting the nature of the operation.

    ## Requirements
    1. **Read** — File icon, shows file path as title, content preview (first 5 lines), line count badge
    2. **Write** — Pencil icon, file path, 'New File' or 'Overwrite' badge, line count
    3. **Edit** — Diff icon, file path, shows old→new change with red/green diff highlighting
    4. **Bash** — Terminal icon, shows command, expandable output with ANSI color support
    5. **Grep** — Search icon, pattern badge, file match count, expandable results with highlighted matches
    6. **Glob** — Folder tree icon, pattern badge, matched files list
    7. **WebFetch** — Globe icon, URL as title, response preview
    8. **WebSearch** — Magnifying glass, query as title, result count, source links
    9. **Task** — Robot icon, agent type badge, description, status (running/complete)
    10. **TodoWrite** — Checklist icon, shows todo items with status indicators
    11. **AskUserQuestion** — Question mark icon, shows question with interactive options
    12. **NotebookEdit** — Notebook icon, cell number, edit type badge
    13. **MCP tools** (orchestra) — Orchestra logo icon, tool name, expandable input/output

    ## Affected Files
    - `apps/swift/Shared/Sources/Shared/Components/ToolCallCardView.swift`
    - NEW: `apps/swift/Shared/Sources/Shared/Components/ToolCards/` directory with per-tool views
estimate: L
id: FEAT-GFF
kind: feature
labels:
    - plan:PLAN-YST
priority: P1
project_id: orchestra-swift-enhancement
status: backlog
title: Per-Tool Card Designs for All Claude Code Tools
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# Per-Tool Card Designs for All Claude Code Tools

## Problem
All tool executions look the same. Each Claude Code tool should have its own card design reflecting the nature of the operation.

## Requirements
1. **Read** — File icon, shows file path as title, content preview (first 5 lines), line count badge
2. **Write** — Pencil icon, file path, 'New File' or 'Overwrite' badge, line count
3. **Edit** — Diff icon, file path, shows old→new change with red/green diff highlighting
4. **Bash** — Terminal icon, shows command, expandable output with ANSI color support
5. **Grep** — Search icon, pattern badge, file match count, expandable results with highlighted matches
6. **Glob** — Folder tree icon, pattern badge, matched files list
7. **WebFetch** — Globe icon, URL as title, response preview
8. **WebSearch** — Magnifying glass, query as title, result count, source links
9. **Task** — Robot icon, agent type badge, description, status (running/complete)
10. **TodoWrite** — Checklist icon, shows todo items with status indicators
11. **AskUserQuestion** — Question mark icon, shows question with interactive options
12. **NotebookEdit** — Notebook icon, cell number, edit type badge
13. **MCP tools** (orchestra) — Orchestra logo icon, tool name, expandable input/output

## Affected Files
- `apps/swift/Shared/Sources/Shared/Components/ToolCallCardView.swift`
- NEW: `apps/swift/Shared/Sources/Shared/Components/ToolCards/` directory with per-tool views
