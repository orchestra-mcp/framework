---
created_at: "2026-03-04T15:44:39Z"
description: '## Problem\nAll messages in a session are loaded at once, which causes performance issues for long conversations. Should load only the latest 20 messages initially and load more when scrolling to the top.\n\n## Requirements\n1. Initial load: only the latest 20 messages are rendered\n2. When user scrolls to the top of the message list, trigger ''load more'' — fetch the next 20 older messages\n3. Show a subtle loading spinner at the top while fetching older messages\n4. Preserve scroll position when prepending older messages (user should not jump to the top)\n5. Messages loaded incrementally in batches of 20\n6. If total messages < 20, show all (no load-more needed)\n7. ''Beginning of conversation'' indicator when all messages are loaded\n8. Keep rendered message count reasonable — consider recycling/virtualizing for very long sessions (500+ messages)\n9. The message fetch should work with both local session storage and MCP `get_session` tool\n\n## Affected Files\n- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift` (message list, data loading)'
id: FEAT-YOA
kind: feature
priority: P1
project_id: orchestra-swift-enhancement
status: backlog
title: Paginated Message Loading — 20 Messages with Load More on Scroll Up
updated_at: "2026-03-04T15:44:39Z"
version: 0
---

# Paginated Message Loading — 20 Messages with Load More on Scroll Up

## Problem\nAll messages in a session are loaded at once, which causes performance issues for long conversations. Should load only the latest 20 messages initially and load more when scrolling to the top.\n\n## Requirements\n1. Initial load: only the latest 20 messages are rendered\n2. When user scrolls to the top of the message list, trigger 'load more' — fetch the next 20 older messages\n3. Show a subtle loading spinner at the top while fetching older messages\n4. Preserve scroll position when prepending older messages (user should not jump to the top)\n5. Messages loaded incrementally in batches of 20\n6. If total messages < 20, show all (no load-more needed)\n7. 'Beginning of conversation' indicator when all messages are loaded\n8. Keep rendered message count reasonable — consider recycling/virtualizing for very long sessions (500+ messages)\n9. The message fetch should work with both local session storage and MCP `get_session` tool\n\n## Affected Files\n- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift` (message list, data loading)
