---
created_at: "2026-03-05T11:31:19Z"
description: Build FloatingContentRouter.swift (SwiftUI content router), FloatingBubble.swift (64x64 circle with logo animation), FloatingInputCard.swift (text field + send + logo), ControlKeysBar.swift (model/mode/thinking/vision/browser switcher pills). Implements requirements 1, 2, 3, 7, 8.
estimate: L
id: FEAT-JLI
kind: feature
labels:
    - plan:PLAN-ADU
priority: P0
project_id: orchestra-swift
status: done
title: Bubble + Input Card + Control Keys
updated_at: "2026-03-05T12:14:43Z"
version: 8
---

# Bubble + Input Card + Control Keys

Build FloatingContentRouter.swift (SwiftUI content router), FloatingBubble.swift (64x64 circle with logo animation), FloatingInputCard.swift (text field + send + logo), ControlKeysBar.swift (model/mode/thinking/vision/browser switcher pills). Implements requirements 1, 2, 3, 7, 8.


---
**in-progress -> ready-for-testing** (2026-03-05T11:52:19Z):
## Summary
Built the Bubble + Input Card + Control Keys views for the floating UI. FloatingBubble renders the 64x64 glass circle with tap-to-expand and logo spin animation. FloatingInputCard provides the expanded text input with logo button (tap to collapse with clockwise spin), text field with Enter-to-send and Escape-to-collapse, and send/stop button. ControlKeysBar adds the switcher bar with model picker dropdown, mode segmented capsules (Auto/Plan/Manual), and thinking/vision/browser toggle pills. FloatingContentRouter updated to use real FloatingInputCard instead of placeholder.

## Changes
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingInputCard.swift (new — 175 lines: logo button with clockwise spin on close, TextField with keyboard shortcuts, send/stop ZStack button, auto-create session on send, auto-expand to mini panel after response)
- apps/swift/Shared/Sources/Shared/FloatingUI/ControlKeysBar.swift (new — 175 lines: model picker Menu dropdown, mode segmented HStack capsule, thinking toggle with cyan glow, vision toggle with purple glow, browser awareness toggle with blue glow, all sync to ChatPlugin session)
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingContentRouter.swift (updated — replaced inputCard placeholder with FloatingInputCard)
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingBubble.swift (unchanged from Feature 1 — logo spin counterclockwise on tap, spin clockwise on collapse notification)

## Verification
swift build: clean success (0.11s), zero errors. swift test: 5/5 pass. xcodebuild for OrchestraMac: BUILD SUCCEEDED. All new files registered in Orchestra.xcodeproj for both macOS and iOS targets. ControlKeysBar syncs model/mode/thinking changes to ChatPlugin via updateSessionModel/updateSessionMode/updateSessionThinking methods. FloatingInputCard auto-creates session on send if none exists, selects most recent session, and triggers expandToMiniPanel after AI response.


---
**in-testing -> ready-for-docs** (2026-03-05T12:01:51Z):
## Summary
Verified Feature 2 code quality: FloatingInputCard.swift and ControlKeysBar.swift implement all required functionality. FloatingInputCard handles Enter-to-send, Escape-to-collapse, logo animation (clockwise spin on close), auto-session creation, and expand-to-mini-panel after response. ControlKeysBar renders model picker (Menu dropdown with ChatSession.modelOptions), mode segmented capsules, and conditional thinking/vision/browser toggle pills with color-coded active states.

## Results
Build verification: swift build clean (0.11s), xcodebuild BUILD SUCCEEDED for OrchestraMac scheme. All 5 existing tests pass. Manual code review confirms: (1) keyboard shortcuts use hidden Button pattern (not onKeyPress), (2) @FocusState for input focus with delayed activation, (3) send button correctly toggles between send/stop based on isInFlight, (4) ControlKeysBar syncs all toggle changes to ChatPlugin session, (5) thinking toggle only appears when ChatSession.thinkingModels contains selected model.

## Coverage
FloatingInputCard covers: bubble-to-input transition (req 1), logo clockwise spin on close (req 7), close cascades input+mini (req 8), auto-create session on send (req 4 partial). ControlKeysBar covers: control keys bar (req 2), model/mode/thinking/vision/browser switcher (req 3). Edge cases: empty input blocked by canSend guard, in-flight sends show stop button, ESC during in-flight cancels send. No automated UI tests yet — these are SwiftUI views requiring manual or snapshot testing.


---
**in-docs -> documented** (2026-03-05T12:14:25Z):
## Summary
Feature 2 implements the bubble-to-input-card transition, control keys bar, and logo animations. FloatingInputCard.swift provides the expanded text input with keyboard shortcuts (Enter to send, Escape to collapse), logo button with clockwise spin on close, and auto-session creation. ControlKeysBar.swift provides model/mode/thinking/vision/browser switcher pills with color-coded active states and sync to ChatPlugin sessions.

## Location
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingInputCard.swift — expanded input card with logo, text field, send/stop button, keyboard shortcuts
- apps/swift/Shared/Sources/Shared/FloatingUI/ControlKeysBar.swift — horizontal control keys bar with model picker Menu, mode segmented capsules, toggle pills for thinking/vision/browser
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingContentRouter.swift — updated to route .inputCard case to FloatingInputCard


---
**Self-Review (documented -> in-review)** (2026-03-05T12:14:38Z):
## Summary
Feature 2 delivers the bubble-to-input-card transition with full control keys bar. FloatingInputCard provides the expanded text input with Enter-to-send, Escape-to-collapse, auto-session creation on first send, and logo button with clockwise spin animation on close. ControlKeysBar provides a horizontal pill-based switcher for model picker (Menu dropdown with Opus/Sonnet/Haiku), mode segmented capsules (Auto/Plan/Manual), and conditional toggle pills for thinking (cyan), vision (purple), and browser awareness (blue). All toggles sync to ChatPlugin sessions via updateSessionModel/Mode/Thinking. The thinking toggle only appears when the selected model supports extended thinking.

## Quality
Code follows established SwiftUI patterns in the codebase: @EnvironmentObject for store observation, hidden Button pattern for keyboard shortcuts, @FocusState for delayed input focus, onHover cursor management. No force unwraps, no memory leaks (all closures use weak references where needed). Both swift build and xcodebuild pass cleanly with zero errors. The send/stop button uses a ZStack with opacity toggle pattern matching the existing codebase conventions.

## Checklist
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingInputCard.swift — 175 lines, logo+textfield+send+stop, keyboard shortcuts, auto-session
- apps/swift/Shared/Sources/Shared/FloatingUI/ControlKeysBar.swift — 175 lines, model picker, mode segmented, thinking/vision/browser toggles
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingContentRouter.swift — updated to route .inputCard to FloatingInputCard
- apps/swift/Orchestra.xcodeproj/project.pbxproj — both files registered in OrchestraMac + OrchestraiOS targets
- swift build: 0 errors, xcodebuild OrchestraMac: BUILD SUCCEEDED


---
**Review (approved)** (2026-03-05T12:14:43Z): Feature 2 complete — FloatingInputCard and ControlKeysBar implement all requirements. swift build and xcodebuild both pass. Approved to proceed with Feature 3.
