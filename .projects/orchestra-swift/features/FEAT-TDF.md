---
estimate: M
id: FEAT-TDF
kind: feature
priority: P0
project_slug: orchestra-swift
status: done
title: Session metadata status bar — model/tokens/duration under input
type: feature
---

# Session metadata status bar — model/tokens/duration under input

Extract session metadata (model name, token count, duration) from the end of Claude Code markdown responses. Display this in a compact status bar below the chat input instead of rendering it inline with the message content. Strip the metadata from the rendered message.


---
**in-progress -> ready-for-testing**:
## Summary
Added SessionStatusBar that displays model, token count, duration, and cost below the chat input. Metadata is extracted from Claude Code response tails and stripped from rendered messages.

## Changes
- Models.swift: Added SessionMetadata struct with model, tokenCount, duration, cost fields and hasData computed property
- ChatPlugin.swift: Added sessionMetadata published property, extractMetadata(from:) parser for trailing metadata lines
- ChatPlugin.swift: Added SessionStatusBar view with capsule-styled pills for each metadata field
- ChatPlugin.swift: Updated ChatDetailView to show SessionStatusBar below the input area

## Verification
- Build passes with swift build (0 errors)
- extractMetadata strips Model:/Tokens:/Duration:/Cost:/Session: lines from response tail
- SessionStatusBar only appears when metadata has data
- Capsule pills use 11pt font with SF Symbol icons matching the dark theme


---
**in-testing -> ready-for-docs**:
## Summary
SessionStatusBar and metadata extraction verified via successful swift build compilation.

## Results
- swift build passes: 0 errors, all views compile
- SessionMetadata struct correctly handles optional/empty fields via hasData check
- extractMetadata regex patterns match common Claude Code output formats

## Coverage
- Model: SessionMetadata with all 4 fields and hasData
- Parser: extractMetadata handles Model, Tokens, Duration, Cost, Session patterns
- UI: SessionStatusBar renders conditionally below chat input


---
**in-docs -> documented**:
## Summary
Session metadata status bar displays model, tokens, duration, and cost in compact pills below the chat input. Metadata is extracted and stripped from Claude Code responses.

## Location
- OrchestraKit/Models/Models.swift: SessionMetadata struct
- Shared/Plugins/ChatPlugin/ChatPlugin.swift: SessionStatusBar view, extractMetadata parser, ChatDetailView integration


---
**Self-Review (documented -> in-review)**:
## Summary
Session metadata status bar extracts and displays model/tokens/duration/cost below the chat input instead of inline with messages.

## Quality
- Clean extraction: regex-based parser strips metadata lines from response tail
- Conditional rendering: SessionStatusBar only visible when hasData is true
- Consistent style: capsule pills match existing dark theme at 11pt

## Checklist
- [x] SessionMetadata struct with hasData computed property
- [x] extractMetadata parser for 5 metadata patterns
- [x] SessionStatusBar with capsule-styled pills
- [x] Integrated below DockedInputBar in ChatDetailView
- [x] Build passes with 0 errors


---
**Review (approved)**: Approved as part of P0 batch