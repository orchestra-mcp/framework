---
created_at: "2026-03-09T10:28:27Z"
description: The bridge-claude response includes tool call traces but they're currently stripped as metadata. Instead, parse them into ClaudeCodeEvent[] objects and attach to assistant messages via the events prop. ChatBox already has 50+ card renderers (BashCard, GrepCard, OrchestraCard, etc).
estimate: L
id: FEAT-TBX
kind: feature
labels:
    - plan:PLAN-BSW
priority: P1
project_id: orchestra-web
status: todo
title: Parse and display tool events in chat messages
updated_at: "2026-03-09T10:28:27Z"
version: 0
---

# Parse and display tool events in chat messages

The bridge-claude response includes tool call traces but they're currently stripped as metadata. Instead, parse them into ClaudeCodeEvent[] objects and attach to assistant messages via the events prop. ChatBox already has 50+ card renderers (BashCard, GrepCard, OrchestraCard, etc).
