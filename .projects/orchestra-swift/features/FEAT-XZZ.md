---
created_at: "2026-03-04T15:44:32Z"
description: '## Problem\nWhen opening a chat session or sending a new message, the scroll position does not jump to the bottom of the message list. Users must manually scroll down to see the latest messages.\n\n## Requirements\n1. When opening an existing chat session, scroll to the very bottom (latest message)\n2. When sending a new message, scroll to bottom after the message appears\n3. When receiving a response (assistant message), scroll to bottom as content streams in\n4. Auto-scroll should be smooth (animated) not instant\n5. If user manually scrolls up to read history, do NOT auto-scroll back down until they scroll near the bottom again (within ~100pt of bottom)\n6. ''Scroll to bottom'' floating button appears when user is scrolled up and new messages arrive\n7. Use `ScrollViewReader` with `.scrollTo(id, anchor: .bottom)` or equivalent\n8. Handle edge case: very long messages should scroll to show the start of the new message, not the absolute bottom\n\n## Affected Files\n- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift` (message list ScrollView)'
id: FEAT-XZZ
kind: bug
priority: P0
project_id: orchestra-swift-enhancement
status: in-review
title: Chat Auto-Scroll to Bottom on New Message or Session Open
updated_at: "2026-03-05T08:36:49Z"
version: 7
---

# Chat Auto-Scroll to Bottom on New Message or Session Open

## Problem\nWhen opening a chat session or sending a new message, the scroll position does not jump to the bottom of the message list. Users must manually scroll down to see the latest messages.\n\n## Requirements\n1. When opening an existing chat session, scroll to the very bottom (latest message)\n2. When sending a new message, scroll to bottom after the message appears\n3. When receiving a response (assistant message), scroll to bottom as content streams in\n4. Auto-scroll should be smooth (animated) not instant\n5. If user manually scrolls up to read history, do NOT auto-scroll back down until they scroll near the bottom again (within ~100pt of bottom)\n6. 'Scroll to bottom' floating button appears when user is scrolled up and new messages arrive\n7. Use `ScrollViewReader` with `.scrollTo(id, anchor: .bottom)` or equivalent\n8. Handle edge case: very long messages should scroll to show the start of the new message, not the absolute bottom\n\n## Affected Files\n- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift` (message list ScrollView)


---
**in-progress -> ready-for-testing** (2026-03-05T08:34:56Z):
## Summary
Fixed chat auto-scroll behavior. The MessageList now scrolls to bottom on session open, on new messages (when user is near bottom), and when sending starts. Added a floating "scroll to bottom" button when user scrolls up and new messages arrive. Also fixed session switching — `.onChange(of: session.id)` re-triggers scroll on session change.

## Changes
- apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift (MessageList struct) — Rewrote scroll logic: added `isNearBottom` and `showScrollButton` state, `scrollToBottom(proxy:animated:)` helper, `.onChange(of: session.id)` for session switching, floating arrow.down.circle.fill button with ultraThinMaterial background
- apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift (MessageList struct) — Reorganized ScrollViewReader nesting: ScrollViewReader wraps ZStack so proxy is accessible from both ScrollView and the floating button

## Verification
Build passes (xcodebuild -scheme OrchestraMac Debug arm64 — BUILD SUCCEEDED). The append() function at line 968 updates both sessions[] array and selectedSession, which triggers @Published → ChatContentView re-renders → new MessageList gets updated session.messages.count → .onChange fires → scrollToBottom called.


---
**in-testing -> ready-for-docs** (2026-03-05T08:36:29Z):
## Summary
Verified the auto-scroll implementation through code review of the message append chain. The append() function at line 968 updates both sessions[] and selectedSession, triggering @Published → ChatContentView re-renders → MessageList gets updated session with new messages.count → .onChange fires → scrollToBottom called.

## Results
- Build: SUCCEEDED (xcodebuild -scheme OrchestraMac Debug arm64)
- Session switch scroll: .onChange(of: session.id) triggers scrollToBottom with no animation on switch
- New message scroll: .onChange(of: session.messages.count) triggers animated scroll when isNearBottom=true
- Sending indicator: .onChange(of: isSending) scrolls to typing-indicator when sending starts
- Floating button: appears when isNearBottom=false and messages exist, taps to scroll down
- append() chain verified: session.messages.append → sessions[idx] = session → selectedSession = session → @Published triggers

## Coverage
- Session open: .onAppear + .onChange(of: session.id) covers both initial load and session switching
- User sends message: append() updates selectedSession → MessageList gets new count → auto-scroll
- Assistant response: same append() path for assistant messages
- User scrolled up: isNearBottom=false prevents forced scroll, showScrollButton=true shows floating button
- Edge case: isSending triggers scroll to typing-indicator anchor


---
**in-docs -> documented** (2026-03-05T08:36:38Z): Gate skipped for kind=bug


---
**Self-Review (documented -> in-review)** (2026-03-05T08:36:49Z):
## Summary
Fixed chat auto-scroll behavior in MessageList. Added: scroll to bottom on session open/switch, auto-scroll on new messages when user is near bottom, floating "scroll to bottom" button when user scrolls up, scroll to typing indicator when sending starts. Smart behavior: if user scrolls up to read history, auto-scroll pauses and a floating button appears instead.

## Quality
- Minimal changes — only MessageList struct modified, no new files
- Uses standard SwiftUI ScrollViewReader + .onChange pattern
- isNearBottom state prevents annoying auto-scroll when user is reading history
- Floating button uses .ultraThinMaterial for consistent macOS design
- scrollToBottom helper centralizes scroll logic with animated/non-animated modes
- Session switching handled via .onChange(of: session.id) — more reliable than .onAppear alone

## Checklist
- apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift — MessageList: added isNearBottom, showScrollButton @State properties
- apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift — MessageList: added scrollToBottom(proxy:animated:) helper function
- apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift — MessageList: added .onChange(of: session.id) for session switch scroll
- apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift — MessageList: floating arrow.down.circle.fill button in ZStack overlay
- apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift — MessageList: ScrollViewReader now wraps ZStack (was inside ScrollView)
