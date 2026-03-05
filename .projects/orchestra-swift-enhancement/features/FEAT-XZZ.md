---
created_at: "2026-03-04T15:44:32Z"
description: '## Problem\nWhen opening a chat session or sending a new message, the scroll position does not jump to the bottom of the message list. Users must manually scroll down to see the latest messages.\n\n## Requirements\n1. When opening an existing chat session, scroll to the very bottom (latest message)\n2. When sending a new message, scroll to bottom after the message appears\n3. When receiving a response (assistant message), scroll to bottom as content streams in\n4. Auto-scroll should be smooth (animated) not instant\n5. If user manually scrolls up to read history, do NOT auto-scroll back down until they scroll near the bottom again (within ~100pt of bottom)\n6. ''Scroll to bottom'' floating button appears when user is scrolled up and new messages arrive\n7. Use `ScrollViewReader` with `.scrollTo(id, anchor: .bottom)` or equivalent\n8. Handle edge case: very long messages should scroll to show the start of the new message, not the absolute bottom\n\n## Affected Files\n- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift` (message list ScrollView)'
id: FEAT-XZZ
kind: bug
priority: P0
project_id: orchestra-swift-enhancement
status: backlog
title: Chat Auto-Scroll to Bottom on New Message or Session Open
updated_at: "2026-03-04T15:44:32Z"
version: 0
---

# Chat Auto-Scroll to Bottom on New Message or Session Open

## Problem\nWhen opening a chat session or sending a new message, the scroll position does not jump to the bottom of the message list. Users must manually scroll down to see the latest messages.\n\n## Requirements\n1. When opening an existing chat session, scroll to the very bottom (latest message)\n2. When sending a new message, scroll to bottom after the message appears\n3. When receiving a response (assistant message), scroll to bottom as content streams in\n4. Auto-scroll should be smooth (animated) not instant\n5. If user manually scrolls up to read history, do NOT auto-scroll back down until they scroll near the bottom again (within ~100pt of bottom)\n6. 'Scroll to bottom' floating button appears when user is scrolled up and new messages arrive\n7. Use `ScrollViewReader` with `.scrollTo(id, anchor: .bottom)` or equivalent\n8. Handle edge case: very long messages should scroll to show the start of the new message, not the absolute bottom\n\n## Affected Files\n- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift` (message list ScrollView)
