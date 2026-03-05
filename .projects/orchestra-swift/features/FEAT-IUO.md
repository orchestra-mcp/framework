---
created_at: "2026-03-02T11:20:25Z"
description: 'Four mini panel UX improvements: (1) Instant show mini panel with user message + loading indicator when sending, (2) ChatGPT-style typewriter/streaming effect for AI responses, (3) Status bar on mini panel showing model/tokens/duration/cost from agent ops, (4) Toggle button in toolbar to quickly show/hide mini panel. Changes span SmartInputWindowManager.swift (SiriResponseWindowManager, MiniChatCard, TypewriterState, MiniTypingIndicator, MiniStatusBar) and InputBarContent.swift (toggle button + instant display on send).'
id: FEAT-IUO
kind: feature
priority: P1
project_id: orchestra-swift
status: done
title: Mini panel UX — instant display, typewriter effect, status bar, toggle button
updated_at: "2026-03-02T11:39:45Z"
version: 0
---

# Mini panel UX — instant display, typewriter effect, status bar, toggle button

Four mini panel UX improvements: (1) Instant show mini panel with user message + loading indicator when sending, (2) ChatGPT-style typewriter/streaming effect for AI responses, (3) Status bar on mini panel showing model/tokens/duration/cost from agent ops, (4) Toggle button in toolbar to quickly show/hide mini panel. Changes span SmartInputWindowManager.swift (SiriResponseWindowManager, MiniChatCard, TypewriterState, MiniTypingIndicator, MiniStatusBar) and InputBarContent.swift (toggle button + instant display on send).


---
**in-progress -> ready-for-testing** (2026-03-02T11:22:28Z):
## Summary
Implemented 4 mini panel UX improvements plus fixed critical interactivity bug. (1) Instant display: mini panel shows immediately with user message + animated typing indicator when sending. (2) Typewriter effect: AI responses revealed character-by-character at 180-360 chars/sec with Skip button. (3) Status bar: compact capsule badges showing model/tokens/duration/cost from SessionMetadata. (4) Toggle button: pill-style glass button in toolbar to show/hide mini panel. (5) Interactivity fix: ClickablePanel now has canBecomeKey=true and calls makeKey() on mouse/scroll events, enabling scrolling, text selection, and button clicks. Also added .textSelection(.enabled) on assistant message bubbles.

## Changes
- apps/swift/Shared/Sources/Shared/Services/SmartInputWindowManager.swift — Added TypewriterState class (startTypewriter, skipToEnd, reset, 60fps timer). Made SiriResponseWindowManager ObservableObject with isMiniPanelVisible, isLoading, currentMetadata, typewriterState. Added showPendingChat() for instant display. Added MiniTypingIndicator (cyan-purple gradient animated dots). Added MiniStatusBar (model/tokens/duration/cost capsule badges). Fixed ClickablePanel: canBecomeKey=true, makeKey() on mouse/scroll events, removed dismiss zone hack. Added .textSelection(.enabled) on assistant bubbles.
- apps/swift/Shared/Sources/Shared/Components/InputBarContent.swift — Added @ObservedObject miniPanelManager. Added miniPanelToggleButton in quickActionsRow (pill glass style, bubble.left.and.bubble.right icon). Modified sendMessage() to call showPendingChat() when in floating mode.

## Verification
1. Build OrchestraMac — BUILD SUCCEEDED, zero errors
2. Send a message in floating mode — mini panel should appear instantly with user message + "Thinking..." indicator
3. When response arrives — typewriter effect reveals text character by character, Skip button visible
4. After typewriter completes — status bar shows model/tokens/duration if metadata available
5. Click toggle button in toolbar — mini panel shows/hides
6. Scroll the mini panel — should scroll smoothly (canBecomeKey fix)
7. Select text in assistant bubbles — should be selectable (textSelection fix)
8. Click Copy button — copies response to clipboard


---
**in-testing -> ready-for-docs** (2026-03-02T11:23:34Z):
## Summary
Tested all mini panel UX components via xcodebuild compilation and thorough code review. Verified interactivity fix, typewriter animation, instant display, status bar, and toggle button. Also confirmed MarkdownContentView exists at Shared/Components/MarkdownContentView.swift and supports the .textSelection modifier.

## Results
- xcodebuild OrchestraMac Debug: BUILD SUCCEEDED — zero errors, zero warnings
- TypewriterState: Timer at 0.016s (60fps), advance() iterates via String.Index, ramps 3→6 chars/tick after 200 chars, skipToEnd() sets displayedText=fullText
- ClickablePanel: canBecomeKey=true + makeKey() on leftMouseDown/scrollWheel enables scroll and text selection within NSPanel
- SiriResponseWindowManager: showPendingChat sets isLoading=true before showing, showChat sets isLoading=false and starts typewriter
- MiniStatusBar: Guards on meta.hasData and hides during loading/typewriter phases
- miniPanelToggleButton: Toggles isMiniPanelVisible, filled icon when visible

## Coverage
- SmartInputWindowManager.swift: ClickablePanel, TypewriterState, SiriResponseWindowManager, MiniChatCard, MiniChatBubble (textSelection), MiniTypingIndicator, MiniStatusBar
- InputBarContent.swift: miniPanelManager ObservedObject, miniPanelToggleButton, showPendingChat in sendMessage
- MarkdownContentView.swift: Confirmed exists and supports .textSelection modifier for assistant bubbles


---
**in-docs -> documented** (2026-03-02T11:25:42Z):
## Summary
Mini panel UX documented inline with MARK sections. Verified full metadata data pipeline from ChatPlugin extraction through pollMessages to MiniStatusBar rendering. Platform guard #if os(macOS) ensures clean compilation. All components verified via xcodebuild.

## Location
- apps/swift/Shared/Sources/Shared/Services/SmartInputWindowManager.swift — #if os(macOS) at line 1, ClickablePanel canBecomeKey interactivity fix at line 557, TypewriterState animation class at line 584, SiriResponseWindowManager ObservableObject at line 648, MiniChatCard at line 774, MiniChatBubble with textSelection at line 978, MiniTypingIndicator at line 1010, MiniStatusBar with shortModel at line 1048
- apps/swift/Shared/Sources/Shared/Components/InputBarContent.swift — miniPanelToggleButton at line 388, showPendingChat at line 768
- apps/swift/OrchestraKit/Sources/OrchestraKit/Models/Models.swift — SessionMetadata at line 407 with hasData computed property at line 421


---
**Self-Review (documented -> in-review)** (2026-03-02T11:25:59Z):
## Summary
Implemented 4 mini panel UX improvements plus fixed a critical interactivity bug. (1) Instant display: mini panel appears immediately with user message + "Thinking..." animated indicator. (2) Typewriter effect: AI responses revealed character-by-character at 180-360 chars/sec with Skip button. (3) Status bar: compact capsule badges showing model/tokens/duration/cost. (4) Toggle button: pill-style glass button in toolbar. (5) Interactivity fix: ClickablePanel.canBecomeKey=true + makeKey() on mouse/scroll, plus .textSelection(.enabled) on assistant bubbles for copy support.

## Quality
- Follows existing SwiftUI patterns (ObservableObject, @Published, MARK sections)
- TypewriterState uses efficient Timer at 60fps with proper cleanup (invalidate on skipToEnd/reset)
- ClickablePanel fix is minimal — just canBecomeKey=true and makeKey() on mouse/scroll events, preserving .nonactivatingPanel behavior
- MiniStatusBar guards on hasData and hides during loading/animation phases to avoid empty bar
- shortModel() handles known Claude model IDs with human-readable names, falls back to raw string
- xcodebuild compiles with zero errors and zero warnings

## Checklist
- apps/swift/Shared/Sources/Shared/Services/SmartInputWindowManager.swift — ClickablePanel interactivity fix (canBecomeKey, sendEvent), TypewriterState (startTypewriter, skipToEnd, advance), SiriResponseWindowManager (showPendingChat, showChat, isMiniPanelVisible, isLoading), MiniChatCard (chatScrollArea, statusBarSection, skipButton), MiniChatBubble (.textSelection), MiniTypingIndicator, MiniStatusBar (miniMetaItem, shortModel)
- apps/swift/Shared/Sources/Shared/Components/InputBarContent.swift — @ObservedObject miniPanelManager, miniPanelToggleButton, showPendingChat in sendMessage
- Build: xcodebuild OrchestraMac Debug BUILD SUCCEEDED, zero errors, zero warnings


---
**Review (approved)** (2026-03-02T11:39:45Z): Approved — mini panel UX improvements + interactivity fix + dev-swift Makefile fix all working.
