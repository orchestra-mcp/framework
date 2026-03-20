---
estimate: L
id: FEAT-TBX
kind: feature
priority: P1
project_slug: orchestra-web
status: todo
title: Parse and display tool events in chat messages
type: feature
---

# Parse and display tool events in chat messages

The bridge-claude response includes tool call traces but they're currently stripped as metadata. Instead, parse them into ClaudeCodeEvent[] objects and attach to assistant messages via the events prop. ChatBox already has 50+ card renderers (BashCard, GrepCard, OrchestraCard, etc).