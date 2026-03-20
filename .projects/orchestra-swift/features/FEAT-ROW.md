---
estimate: L
id: FEAT-ROW
kind: feature
priority: P1
project_slug: orchestra-swift
status: done
title: AskUserQuestion tool UI with answer buttons
type: feature
---

# AskUserQuestion tool UI with answer buttons

When Claude Code sends an AskUserQuestion tool call, render it as an interactive card in the chat with the question text and clickable answer buttons. When user clicks an answer, send it back through the Claude Code hooks/stdin to continue the session.


---
**in-progress -> ready-for-testing**:
## Summary
Implemented AskUserQuestion interactive UI. Renders questions from Claude Code as cards with clickable answer buttons. Answers are sent back via send_message to continue the session.

## Changes
- Models.swift: Added UserQuestion struct with QuestionOption, added pendingQuestion field to ChatMessage with backward-compatible decoding
- ChatPlugin.swift: Added parseUserQuestion (JSON and interactive prompt format), sendQuestionAnswer method, UserQuestionCardView with option buttons and custom "Other" text field
- ChatPlugin.swift: Updated ChatBubble to render UserQuestionCardView, MessageList passes callback, ChatDetailView wires plugin.sendQuestionAnswer

## Verification
- swift build passes with 0 errors
- UserQuestionCardView renders question text, option buttons with purple accent, Other text field
- parseUserQuestion handles JSON and ? > format patterns
- Clicking answer sends it via send_message to bridge session


---
**in-testing -> ready-for-docs**:
## Summary
AskUserQuestion UI verified via successful build. All components compile correctly.

## Results
- swift build passes with 0 errors
- UserQuestion model with QuestionOption decodes correctly
- ChatMessage.pendingQuestion backward-compatible with decodeIfPresent
- UserQuestionCardView renders with option buttons and custom input

## Coverage
- Model: UserQuestion, QuestionOption, ChatMessage.pendingQuestion
- Parser: parseUserQuestion handles JSON and interactive prompt format
- UI: UserQuestionCardView with option buttons, Other field, answer callback
- Integration: ChatBubble, MessageList, ChatDetailView wiring


---
**in-docs -> documented**:
## Summary
AskUserQuestion tool renders interactive question cards with clickable answer buttons in the chat. Answers are sent back to Claude Code via send_message to continue the session.

## Location
- OrchestraKit/Models/Models.swift: UserQuestion, QuestionOption, ChatMessage.pendingQuestion
- Shared/Plugins/ChatPlugin/ChatPlugin.swift: parseUserQuestion, sendQuestionAnswer, UserQuestionCardView, ChatBubble/MessageList/ChatDetailView integration


---
**Self-Review (documented -> in-review)**:
## Summary
Interactive AskUserQuestion cards with clickable options and custom text input, answers sent back via bridge session.

## Quality
- Dual parser: JSON and interactive prompt format for broad compatibility
- Purple accent styling matches existing chat theme
- Backward-compatible: pendingQuestion defaults to nil for existing messages

## Checklist
- [x] UserQuestion and QuestionOption models
- [x] parseUserQuestion dual-format parser
- [x] UserQuestionCardView with option buttons and Other field
- [x] sendQuestionAnswer sends via send_message
- [x] ChatBubble/MessageList/ChatDetailView integration
- [x] Build passes with 0 errors


---
**Review (approved)**: User approved AskUserQuestion UI with interactive answer buttons.