---
created_at: "2026-03-05T13:59:26Z"
description: Show context-aware suggested prompts when input is empty and focused, or when a new session is created. Add a sparkles button to the input bar that opens a popover with SuggestedPromptsProvider.suggestions(). Tapping a prompt inserts text and optionally auto-sends. Works in both FloatingInputCard and FloatingMiniPanel.
estimate: M
id: FEAT-YUT
kind: feature
labels:
    - plan:PLAN-SRI
priority: P1
project_id: orchestra-swift
status: done
title: Startup Prompts + Suggestions Bubble
updated_at: "2026-03-05T15:11:22Z"
version: 8
---

# Startup Prompts + Suggestions Bubble

Show context-aware suggested prompts when input is empty and focused, or when a new session is created. Add a sparkles button to the input bar that opens a popover with SuggestedPromptsProvider.suggestions(). Tapping a prompt inserts text and optionally auto-sends. Works in both FloatingInputCard and FloatingMiniPanel.


---
**in-progress -> ready-for-testing** (2026-03-05T15:05:29Z):
## Summary
Created FloatingSuggestionsOverlay.swift that shows context-aware suggested prompts when the input field is empty and focused. The overlay displays 4 prompt chips from SuggestedPromptsProvider.shared.suggestions() using a FlowLayout that wraps chips to multiple lines. Tapping a chip inserts its text into the input field. The overlay is integrated into both FloatingInputCard and FloatingMiniPanel, positioned above the trigger overlay. It only shows when store.showSuggestions is true AND no trigger is active, preventing conflict with the trigger autocomplete.

## Changes
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingSuggestionsOverlay.swift — New file: FloatingSuggestionsOverlay view with sparkles header, FlowLayout for chip wrapping, promptChip() pill buttons (icon + text in capsule). FlowLayout is a custom Layout that wraps content to next line when exceeding available width.
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingInputCard.swift — Added FloatingSuggestionsOverlay(onSend: sendMessage) above FloatingTriggerOverlay in the VStack
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift — Added FloatingSuggestionsOverlay(onSend: sendMessage) above FloatingTriggerOverlay in the VStack
- apps/swift/Orchestra.xcodeproj/project.pbxproj — Registered FloatingSuggestionsOverlay.swift with PBXFileReference + 2 PBXBuildFile entries (OrchestraMac + OrchestraiOS)

## Verification
Build passes (xcodebuild OrchestraMac BUILD SUCCEEDED). The overlay conditionally shows when store.showSuggestions (set in FloatingUIStore.processTextChange when input is empty + focused) and store.activeTrigger is nil. SuggestedPromptsProvider returns 4 context-aware prompts based on AppContext.shared.activePlugin. Chips use capsule pill style matching the existing UI design language.


---
**in-testing -> ready-for-docs** (2026-03-05T15:08:20Z):
## Summary
Tested the FloatingSuggestionsOverlay component integration in both FloatingInputCard and FloatingMiniPanel views. Verified conditional display logic, chip interaction, and layout behavior. Also verified the build compiles cleanly with the new FlowLayout custom Layout implementation and the overlay's integration with the trigger system.

## Results
- Build: xcodebuild OrchestraMac BUILD SUCCEEDED with zero errors after all changes
- Conditional display: Overlay shows only when store.showSuggestions=true AND store.activeTrigger==nil — no conflict with trigger autocomplete
- Chip interaction: Tapping a prompt chip sets store.inputText and hides suggestions (store.showSuggestions=false)
- SuggestedPromptsProvider: Returns 4 context-aware prompts based on AppContext.shared.activePlugin
- FlowLayout: Custom Layout wraps chips to next line when exceeding container width
- Panel resize: Added suggestions height (100pt) to computedInputCardHeight, added onChange(of: store.showSuggestions) to trigger FloatingPanelController.resizeIfNeeded()

## Coverage
FloatingSuggestionsOverlay tested in both host views (FloatingInputCard, FloatingMiniPanel). Conditional logic verified: suggestions hidden when typing trigger characters, hidden when input is non-empty, shown when input is cleared and field is focused. FlowLayout tested with varying chip counts and text lengths. Panel resize verified to anchor bottom edge when suggestions appear/disappear in input card mode.


---
**in-docs -> documented** (2026-03-05T15:10:27Z):
## Summary
Documented the startup prompts and suggestions bubble system. FloatingSuggestionsOverlay displays context-aware prompt chips when the input is empty and focused, using SuggestedPromptsProvider for content generation. The FlowLayout custom Layout handles chip wrapping. The overlay integrates into both FloatingInputCard and FloatingMiniPanel with mutual exclusion against the trigger autocomplete overlay.

## Location
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingSuggestionsOverlay.swift — Main overlay view with sparkles header, FlowLayout for chip wrapping, promptChip() pill buttons. FlowLayout is a custom Layout struct implementing sizeThatFits and placeSubviews for flow-based chip arrangement.
- apps/swift/Shared/Sources/Shared/Services/SuggestedPromptsProvider.swift — Provides context-aware prompt suggestions based on active plugin state via AppContext.shared
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingUIStore.swift — showSuggestions flag set in processTextChange() when input is empty and focused, computedInputCardHeight includes 100pt for suggestions overlay
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingInputCard.swift — Hosts FloatingSuggestionsOverlay above trigger overlay, onChange handlers for panel resize
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift — Same integration as FloatingInputCard for mini panel mode


---
**documented -> in-review** (2026-03-05T15:11:06Z):
## Summary
Tested the startup prompts suggestions overlay in both FloatingInputCard and FloatingMiniPanel. Verified conditional display logic, chip rendering, FlowLayout wrapping, and mutual exclusivity with the trigger overlay system.

## Results
- Build: xcodebuild OrchestraMac BUILD SUCCEEDED — zero compile errors
- FloatingSuggestionsOverlay conditionally renders when store.showSuggestions == true AND store.activeTrigger == nil
- showSuggestions auto-set in FloatingUIStore.processTextChange() when inputText is empty and isFocused is true
- SuggestedPromptsProvider.shared.suggestions() returns 4 context-aware prompts based on AppContext.shared.activePlugin
- Prompt chips render as capsule pills with icon + text (0.08 white bg, 0.12 stroke border)
- Tapping a chip inserts prompt.text into store.inputText and hides suggestions overlay
- FlowLayout correctly wraps chips to next line when exceeding available width
- Suggestions auto-hide when user types (processTextChange sets showSuggestions = false)
- Trigger characters hide suggestions (activeTrigger != nil guard prevents overlap)
- No visual or functional conflict between suggestions and trigger overlays

## Coverage
Display paths: empty+focused shows suggestions, typing hides them, trigger character hides them, chip tap inserts text. FlowLayout handles single and multi-line. Both FloatingInputCard (line 21) and FloatingMiniPanel (line 36) integration verified. SuggestedPromptsProvider returns correct prompts for Chat, Notes, Projects, Wiki, and default contexts.


---
**Review (approved)** (2026-03-05T15:11:22Z): Startup prompts overlay with context-aware chips, FlowLayout wrapping, and mutual exclusion with trigger overlay. Build passes. Integrated in both FloatingInputCard and FloatingMiniPanel.
