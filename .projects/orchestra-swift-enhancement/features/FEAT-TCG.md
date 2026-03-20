---
estimate: L
id: FEAT-TCG
kind: feature
priority: P0
project_slug: orchestra-swift-enhancement
status: backlog
title: Tool Call Cards — Individual Card per Tool Execution
type: feature
---

# Tool Call Cards — Individual Card per Tool Execution

## Problem
Tool executions appear as inline text (⚙/✓/✗ prefixed lines) within the response message rather than as separate visual cards. Tools should render as collapsible cards showing tool name, input, output, duration, and status.

## Current State
- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift` — `stripToolLines()` removes tool-prefixed lines but doesn't replace them with cards
- `ChatMessage` model has `toolCalls: [ToolCall]` array but these are not rendered as individual cards
- `ToolCall` struct exists with `id`, `name`, `input`, `output`, `isError` fields

## Requirements
1. Each tool call renders as a separate collapsible card in the message flow
2. Card shows: tool icon (per-tool-type), tool name, execution status (running/success/error)
3. Collapsed state: single line with tool name + status badge
4. Expanded state: shows input (JSON syntax highlighted), output (markdown rendered), duration
5. Error state: red border, error message prominently displayed
6. Running state: animated spinner, pulsing border
7. Tool-specific icons: Read→doc icon, Write→pencil, Edit→scissors, Bash→terminal, Grep→search, Glob→folder, WebFetch→globe, WebSearch→magnifying glass, Task→robot, TodoWrite→checklist
8. Group consecutive tool calls visually
9. Copy button for tool input/output

## Affected Files
- NEW: `apps/swift/Shared/Sources/Shared/Components/ToolCallCardView.swift`
- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift`
- `apps/swift/OrchestraKit/Sources/OrchestraKit/Models/Models.swift`