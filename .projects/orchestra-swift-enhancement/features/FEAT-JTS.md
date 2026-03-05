---
created_at: "2026-03-04T15:34:25Z"
description: |-
    ## Problem
    Agent thinking/reasoning content appears inline with the response or not at all. Should have its own collapsible card.

    ## Requirements
    1. Thinking events render as a dedicated collapsible card
    2. Card header: brain icon + 'Thinking...' (while streaming) or 'Thought for Xs' (after complete)
    3. Collapsed by default after thinking is complete
    4. Expandable to show full thinking content
    5. Thinking content rendered as markdown
    6. Subtle styling: slightly muted text, different background from regular messages
    7. Duration badge showing how long the thinking took
    8. Multiple thinking blocks per message supported (for extended thinking)

    ## Affected Files
    - NEW: `apps/swift/Shared/Sources/Shared/Components/ThinkingCardView.swift`
    - `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift`
estimate: M
id: FEAT-JTS
kind: feature
labels:
    - plan:PLAN-YST
priority: P1
project_id: orchestra-swift-enhancement
status: backlog
title: Thinking Card — Dedicated Card for Agent Thinking
updated_at: "2026-03-04T15:34:25Z"
version: 0
---

# Thinking Card — Dedicated Card for Agent Thinking

## Problem
Agent thinking/reasoning content appears inline with the response or not at all. Should have its own collapsible card.

## Requirements
1. Thinking events render as a dedicated collapsible card
2. Card header: brain icon + 'Thinking...' (while streaming) or 'Thought for Xs' (after complete)
3. Collapsed by default after thinking is complete
4. Expandable to show full thinking content
5. Thinking content rendered as markdown
6. Subtle styling: slightly muted text, different background from regular messages
7. Duration badge showing how long the thinking took
8. Multiple thinking blocks per message supported (for extended thinking)

## Affected Files
- NEW: `apps/swift/Shared/Sources/Shared/Components/ThinkingCardView.swift`
- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift`
