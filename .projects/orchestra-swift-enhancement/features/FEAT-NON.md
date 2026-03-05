---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    Text-to-Speech reads the full raw markdown including agent ops data, tool outputs, and formatting syntax. It should only read the human-readable message content.

    ## Current State
    - `apps/swift/Shared/Sources/Shared/Services/VoiceService.swift` (496 lines) — uses macOS `/usr/bin/say` command
    - Reads the raw `content` field from `ChatMessage` without any filtering

    ## Requirements
    1. Strip all markdown syntax before TTS (remove #, **, `, ```, |, etc.)
    2. Strip tool call sections entirely (don't read tool inputs/outputs)
    3. Strip agent ops data (tokens, cost, model info)
    4. Strip code blocks entirely (or optionally say 'code block' placeholder)
    5. Strip table data (or optionally summarize: 'table with N rows and M columns')
    6. Convert links to just their display text
    7. Preserve natural sentence flow and paragraph breaks as pauses
    8. Optional: speak tool results as brief summaries ('file was created', 'search found 5 results')

    ## Affected Files
    - `apps/swift/Shared/Sources/Shared/Services/VoiceService.swift`
    - NEW: `apps/swift/Shared/Sources/Shared/Helpers/TTSTextCleaner.swift`
estimate: S
id: FEAT-NON
kind: bug
labels:
    - plan:PLAN-YST
priority: P1
project_id: orchestra-swift-enhancement
status: backlog
title: TTS Reads Only Message Content — Skip Markdown and Agent Ops Data
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# TTS Reads Only Message Content — Skip Markdown and Agent Ops Data

## Problem
Text-to-Speech reads the full raw markdown including agent ops data, tool outputs, and formatting syntax. It should only read the human-readable message content.

## Current State
- `apps/swift/Shared/Sources/Shared/Services/VoiceService.swift` (496 lines) — uses macOS `/usr/bin/say` command
- Reads the raw `content` field from `ChatMessage` without any filtering

## Requirements
1. Strip all markdown syntax before TTS (remove #, **, `, ```, |, etc.)
2. Strip tool call sections entirely (don't read tool inputs/outputs)
3. Strip agent ops data (tokens, cost, model info)
4. Strip code blocks entirely (or optionally say 'code block' placeholder)
5. Strip table data (or optionally summarize: 'table with N rows and M columns')
6. Convert links to just their display text
7. Preserve natural sentence flow and paragraph breaks as pauses
8. Optional: speak tool results as brief summaries ('file was created', 'search found 5 results')

## Affected Files
- `apps/swift/Shared/Sources/Shared/Services/VoiceService.swift`
- NEW: `apps/swift/Shared/Sources/Shared/Helpers/TTSTextCleaner.swift`
