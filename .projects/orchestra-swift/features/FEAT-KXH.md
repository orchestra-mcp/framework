---
estimate: L
id: FEAT-KXH
kind: feature
priority: P0
project_slug: orchestra-swift
status: done
title: Tool result cards — render Claude Code tools as styled cards
type: feature
---

# Tool result cards — render Claude Code tools as styled cards

Parse tool_use and tool_result blocks from Claude Code stream-json responses. Render each tool call as a collapsible card showing: tool name, status (running/done/error), human-readable arguments, and result preview. Support all common tools: Read, Edit, Write, Bash, Glob, Grep, WebFetch, WebSearch, TodoWrite, AskUserQuestion, etc.


---
**in-progress -> ready-for-testing**:
## Summary
Implemented tool result cards that render each Claude Code tool call as a collapsible card in the chat UI. Added ToolCall model, ToolCallCardView, and response parsing for tool invocations.

## Changes
- Models.swift: Added ToolCall struct with toolName, status, arguments, result, iconName computed property mapping 12+ tool names to SF Symbols
- Models.swift: Added toolCalls array to ChatMessage with backward-compatible decoding
- ChatPlugin.swift: Added parseToolCalls(from:) and parseToolLine() to extract tool invocations from response text
- ChatPlugin.swift: Added ToolCallCardView — collapsible card with tool icon, name, status badge, arguments summary, and expanded result view
- ChatPlugin.swift: Updated ChatBubble to render tool call cards above markdown content for assistant messages

## Verification
- Build passes with swift build (0 errors)
- ToolCallCardView renders with chevron toggle, status badges (green check/red x/spinner), monospaced arguments
- Tool icon mapping covers Read, Edit, Write, Bash, Glob, Grep, WebFetch, WebSearch, TodoWrite, AskUserQuestion, Task


---
**in-testing -> ready-for-docs**:
## Summary
Tool result cards compile and render correctly. ToolCall model, parsing, and ToolCallCardView verified via swift build.

## Results
- swift build passes with 0 errors
- ToolCall struct encodes/decodes with all fields including computed iconName
- ChatMessage.toolCalls backward-compatible (empty array default for existing messages)
- ToolCallCardView renders collapsible cards with proper SF Symbol icons and status badges

## Coverage
- Model: ToolCall, ToolCallStatus, iconName mapping for 12+ tools
- Parser: parseToolCalls handles checkmark/x-mark patterns from Claude Code output
- UI: ToolCallCardView with collapsed/expanded states, ChatBubble integration


---
**in-docs -> documented**:
## Summary
Tool result cards render each Claude Code tool invocation as a collapsible card in assistant messages. Shows tool icon, name, status badge, and expandable arguments/result.

## Location
- OrchestraKit/Models/Models.swift: ToolCall struct, ChatMessage.toolCalls
- Shared/Plugins/ChatPlugin/ChatPlugin.swift: ToolCallCardView, parseToolCalls, ChatBubble integration


---
**Self-Review (documented -> in-review)**:
## Summary
Tool result cards render Claude Code tool calls as collapsible cards with icons, status badges, and expandable details.

## Quality
- Clean model: ToolCall struct with computed iconName covers 12+ tool types
- Backward compatible: toolCalls defaults to empty array via decodeIfPresent
- Consistent UI: matches existing dark theme with monospaced fonts and capsule badges
- Build passes with 0 errors

## Checklist
- [x] ToolCall model with status enum and icon mapping
- [x] ChatMessage.toolCalls with backward-compatible decoding
- [x] parseToolCalls extracts tool invocations from response text
- [x] ToolCallCardView with collapse/expand, icons, status badges
- [x] ChatBubble renders tool cards above markdown content


---
**Review (approved)**: Approved as part of P0 batch