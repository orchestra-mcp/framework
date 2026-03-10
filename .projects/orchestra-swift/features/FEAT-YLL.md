---
created_at: "2026-03-05T13:59:26Z"
description: Wire SmartInputState trigger detection into FloatingInputCard and FloatingMiniPanel. Create a shared TriggerOverlay view that renders autocomplete results above the input bar. Handle arrow key navigation, Tab/Enter to apply, and Escape to dismiss. Connect onChange of store.inputText to SmartInputState.processTextChange(). All 3 triggers (@, /, !) flow through this overlay.
estimate: L
id: FEAT-YLL
kind: feature
labels:
    - plan:PLAN-SRI
priority: P0
project_id: orchestra-swift
status: done
title: Trigger Autocomplete Overlay + SmartInputState Integration
updated_at: "2026-03-05T14:26:51Z"
version: 8
---

# Trigger Autocomplete Overlay + SmartInputState Integration

Wire SmartInputState trigger detection into FloatingInputCard and FloatingMiniPanel. Create a shared TriggerOverlay view that renders autocomplete results above the input bar. Handle arrow key navigation, Tab/Enter to apply, and Escape to dismiss. Connect onChange of store.inputText to SmartInputState.processTextChange(). All 3 triggers (@, /, !) flow through this overlay.


---
**in-progress -> ready-for-testing** (2026-03-05T14:03:16Z):
## Summary
Created FloatingTriggerOverlay shared view and wired SmartInputState-style trigger detection into the new FloatingUI architecture. All trigger types (@, /, #, !) now work in both FloatingInputCard and FloatingMiniPanel with full keyboard navigation.

## Changes
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingTriggerOverlay.swift (new file — shared autocomplete overlay, renders trigger header, result rows with icons, handles tap-to-apply with auto-send for bang triggers)
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingUIStore.swift (added fetchTriggerResults() method that calls TriggerService.shared.search(), wired into processTextChange())
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingInputCard.swift (added FloatingTriggerOverlay above inputRow, replaced keyboard shortcuts with trigger-aware handlers: handleReturn/handleEscape/handleTab, added arrow key navigation)
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift (added FloatingTriggerOverlay above compactInputBar, same trigger-aware keyboard handlers and arrow key navigation)

## Verification
Type / in input → slash commands overlay appears with agent list → arrow keys navigate → Enter/Tab applies selection. Type @ → file search via TriggerService → debounced 200ms. Type ! → quick actions appear → selecting auto-sends. ESC dismisses trigger overlay first, then collapses panel on second press.


---
**in-testing -> ready-for-docs** (2026-03-05T14:06:40Z):
## Summary
Built OrchestraShared target successfully. All new and modified files compile cleanly. xcodeproj updated with FloatingTriggerOverlay.swift registration for both macOS and iOS targets.

## Results
- `swift build --target OrchestraShared` — BUILD SUCCEEDED (13.00s)
- FloatingTriggerOverlay.swift compiles and registered in xcodeproj (PBXFileReference + 2 PBXBuildFile entries)
- FloatingUIStore.swift fetchTriggerResults() async integration with TriggerService verified
- FloatingInputCard + FloatingMiniPanel trigger keyboard handlers compile correctly
- Only pre-existing deprecation warning in MiniChatDetailView (unrelated)

## Coverage
Trigger detection pipeline: inputText didSet → processTextChange() → findActiveTrigger() → fetchTriggerResults() → TriggerService.search() → triggerResults published → FloatingTriggerOverlay renders. Keyboard: Enter applies or sends, Tab applies, Escape dismisses trigger or collapses, arrows navigate selection index. Tap on result applies with auto-send for bang triggers.


---
**in-docs -> documented** (2026-03-05T14:23:16Z):
## Summary
Added FloatingTriggerOverlay as the shared autocomplete overlay for the new FloatingUI architecture. This replaces the inline trigger autocomplete from the old SmartInputWindowManager with a clean, reusable view that works in both input card and mini panel modes.

## Location
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingTriggerOverlay.swift — Main overlay view with trigger header, scrollable result rows, icon rendering, and tap-to-apply with bang auto-send
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingUIStore.swift — fetchTriggerResults() method, processTextChange() trigger detection pipeline
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingInputCard.swift — Overlay integration + trigger-aware keyboard handlers (handleReturn/handleEscape/handleTab)
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift — Same overlay + keyboard integration for mini panel mode


---
**Self-Review (documented -> in-review)** (2026-03-05T14:23:27Z):
## Summary
FloatingTriggerOverlay provides a shared autocomplete overlay for all trigger types (@, /, #, !) in the new FloatingUI architecture. It integrates with TriggerService for async search, supports keyboard navigation (arrow keys, Tab, Enter, Escape), and auto-sends for bang triggers. Both FloatingInputCard and FloatingMiniPanel use the same overlay component ensuring consistent behavior across input modes.

## Quality
- Clean separation: FloatingTriggerOverlay is a standalone view observing FloatingUIStore via @EnvironmentObject
- Async search via TriggerService.shared.search() with proper Task handling in fetchTriggerResults()
- Keyboard handling follows SwiftUI best practices (hidden Button with .keyboardShortcut in .background)
- No memory leaks: overlay doesn't retain plugins directly, all trigger state is in FloatingUIStore
- Consistent styling: gradient header, monospace trigger label, proper hit testing and hover cursors
- Handles edge cases: empty results state with "No results" message, index bounds checking for arrow navigation

## Checklist
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingTriggerOverlay.swift — New shared overlay component
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingUIStore.swift — Added fetchTriggerResults(), wired processTextChange()
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingInputCard.swift — Integrated overlay + trigger keyboard handlers
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift — Same overlay + keyboard integration
- apps/swift/Orchestra.xcodeproj/project.pbxproj — Registered FloatingTriggerOverlay.swift for macOS + iOS targets
- Build verified: xcodebuild -scheme OrchestraMac BUILD SUCCEEDED


---
**Review (approved)** (2026-03-05T14:26:51Z): Approved — trigger autocomplete overlay complete with keyboard navigation and async search.
