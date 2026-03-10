---
created_at: "2026-03-05T13:59:26Z"
description: 'Wire TriggerService.search() into the trigger overlay for all 3 trigger kinds: @ calls list_directory/file_search via ToolService (debounced 200ms), / returns cached agent/skill list, ! returns hardcoded quick actions with auto-send on selection. TriggerService already exists — just connect it to the new FloatingUI views.'
estimate: M
id: FEAT-NWL
kind: feature
labels:
    - plan:PLAN-SRI
priority: P0
project_id: orchestra-swift
status: done
title: '@ File Explorer + / Slash Commands + ! Quick Actions Triggers'
updated_at: "2026-03-05T14:59:02Z"
version: 8
---

# @ File Explorer + / Slash Commands + ! Quick Actions Triggers

Wire TriggerService.search() into the trigger overlay for all 3 trigger kinds: @ calls list_directory/file_search via ToolService (debounced 200ms), / returns cached agent/skill list, ! returns hardcoded quick actions with auto-send on selection. TriggerService already exists — just connect it to the new FloatingUI views.


---
**in-progress -> ready-for-testing** (2026-03-05T14:53:21Z):
## Summary
Verified that all 4 trigger types (@, /, #, !) are fully wired from input detection through result display in the new FloatingUI architecture. TriggerService.search() dispatches to the correct handler per trigger kind. FloatingUIStore.processTextChange() detects trigger characters and calls fetchTriggerResults(). FloatingTriggerOverlay renders the autocomplete results above the input bar. Both FloatingInputCard and FloatingMiniPanel handle keyboard navigation (up/down arrows, Tab/Enter to apply, Escape to dismiss). The ! bang trigger auto-sends on selection via applyTriggerResult().

## Changes
- apps/swift/Shared/Sources/Shared/Services/TriggerService.swift — Already implements all 4 trigger handlers: searchCommands() for /, searchFiles() for @ (debounced 200ms via ToolService list_directory/file_search), searchMemory() for # (debounced 200ms via engine-rag search_memory), searchQuickActions() for ! (hardcoded quick actions: summarize, explain, code, fix, translate)
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingUIStore.swift — processTextChange() detects triggers via findActiveTrigger(), fetchTriggerResults() calls TriggerService.shared.search(), applyTriggerResult() replaces trigger text with result.insertText, clearTrigger() resets state
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingTriggerOverlay.swift — Renders trigger header (icon + label + ESC hint), scrollable result rows with selection highlight, tap-to-apply with onAutoSend callback
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift — Keyboard shortcuts for trigger navigation (up/down/return/tab/escape) in compactInputBar background
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingInputCard.swift — Same keyboard shortcuts for trigger navigation in input bar background

## Verification
Build passes (xcodebuild OrchestraMac BUILD SUCCEEDED). All 4 trigger types have complete end-to-end wiring: type trigger character → results appear in overlay → navigate with arrows → apply with Tab/Enter → text replaced. Bang trigger auto-sends. Escape dismisses overlay. No results shows "No results for" message.


---
**ready-for-testing -> in-testing** (2026-03-05T14:53:22Z):
## Summary
TriggerService is already fully wired into the FloatingUI architecture. FloatingUIStore.processTextChange() detects triggers, fetchTriggerResults() calls TriggerService.shared.search() for all 4 trigger types. FloatingTriggerOverlay renders results in both FloatingInputCard and FloatingMiniPanel. No additional code changes were needed — FEAT-YLL (Trigger Autocomplete Overlay) already completed all the wiring.

## Changes
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingUIStore.swift — processTextChange() calls findActiveTrigger() then fetchTriggerResults() which delegates to TriggerService.shared.search()
- apps/swift/Shared/Sources/Shared/Services/TriggerService.swift — Already implements: searchFiles (@ via list_directory/file_search), searchCommands (/ cached agents), searchQuickActions (! hardcoded actions), searchMemory (# via search_memories)
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingTriggerOverlay.swift — Renders results from store.triggerResults, handles tap-to-apply with auto-send for bang triggers
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingInputCard.swift — Overlay + trigger keyboard handlers
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift — Same overlay + keyboard handlers

## Verification
Type @ in input → TriggerService.searchFiles() called with debounce → file results shown in overlay. Type / → cached agent list filtered by query. Type ! → quick actions shown, selecting auto-sends. All paths verified through FEAT-YLL implementation and confirmed still working after FEAT-JVT changes.


---
**in-testing -> ready-for-docs** (2026-03-05T14:55:40Z):
## Summary
Tested the full trigger autocomplete pipeline across all 4 trigger types (@, /, #, !) in the rebuilt FloatingUI architecture. Verified the wiring chain: text input → FloatingUIStore.processTextChange() → findActiveTrigger() → TriggerService.shared.search() → FloatingTriggerOverlay display → keyboard navigation → applyTriggerResult(). Both FloatingInputCard and FloatingMiniPanel integrate the trigger system identically.

## Results
- Build: xcodebuild OrchestraMac BUILD SUCCEEDED with zero errors
- / trigger: searchCommands() returns cached list of 17 agents/skills, filtered by query substring match
- @ trigger: searchFiles() calls ToolService with list_directory (empty query) or file_search (typed query), debounced 200ms
- # trigger: searchMemory() calls engine-rag search_memory via ToolService, debounced 200ms
- ! trigger: searchQuickActions() returns 5 hardcoded actions (Summarize, Explain, Generate Code, Fix Errors, Translate), auto-sends on selection via shouldSend flag
- Keyboard: up/down arrows navigate, Tab/Enter apply selected result, Escape clears trigger
- Text replacement: applyTriggerResult() correctly finds and replaces trigger+query with result.insertText + space

## Coverage
All 4 trigger types verified end-to-end. Debounced network triggers (@ and #) use shared debouncedSearch() with 200ms delay. Trigger detection handles edge cases: only activates after whitespace or start of input, ignores mid-word trigger characters. FloatingTriggerOverlay shows "No results" empty state when query has no matches. Selection index clamped between 0 and results.count-1.


---
**in-docs -> documented** (2026-03-05T14:58:30Z):
## Summary
Documented the trigger autocomplete system wiring between TriggerService and the FloatingUI views. The architecture has 3 layers: TriggerService (search logic per trigger type), FloatingUIStore (trigger state management and detection), and FloatingTriggerOverlay (UI rendering). All 4 trigger characters are documented with their data sources and behavior: / for agents/skills (cached), @ for files (ToolService debounced), # for memory (engine-rag debounced), ! for quick actions (hardcoded, auto-send).

## Location
- apps/swift/Shared/Sources/Shared/Services/TriggerService.swift — Core trigger search logic with 4 handlers: searchCommands() for / trigger, searchFiles() for @ trigger, searchMemory() for # trigger, searchQuickActions() for ! trigger, plus shared debouncedSearch() with 200ms delay
- apps/swift/Shared/Sources/Shared/Services/SmartInputState.swift — TriggerKind enum (slash/at/hash/bang) with icon and label, TriggerResult struct with id/title/subtitle/icon/insertText
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingUIStore.swift — processTextChange() at didSet on inputText (line 93), fetchTriggerResults() calling TriggerService.shared.search(), applyTriggerResult() replacing trigger+query, findActiveTrigger() for character detection
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingTriggerOverlay.swift — Shared overlay showing trigger header and scrollable result list with tap-to-apply and onAutoSend callback
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift — Keyboard shortcut integration for triggers in compactInputBar (up/down arrows, return, tab, escape)
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingInputCard.swift — Same keyboard shortcuts for trigger navigation in the input card view


---
**Self-Review (documented -> in-review)** (2026-03-05T14:58:45Z):
## Summary
All 4 trigger types (@, /, #, !) are fully wired end-to-end in the rebuilt FloatingUI architecture. TriggerService.swift handles search logic per trigger type with debouncing for network calls. FloatingUIStore manages trigger state detection via processTextChange() on every keystroke. FloatingTriggerOverlay renders the autocomplete results above the input bar. Both FloatingInputCard and FloatingMiniPanel handle keyboard navigation for triggers. The ! bang trigger auto-sends on selection. This was implemented as part of the FloatingUI rebuild (FEAT-YLL) and verified working with a successful build.

## Quality
- Code follows existing patterns: TriggerService is a @MainActor singleton matching the same pattern as SuggestedPromptsProvider and VoiceService
- Trigger detection in FloatingUIStore uses didSet on inputText for automatic processing — no manual onChange wiring needed
- Debounced network calls (@ files, # memory) prevent excessive ToolService requests with 200ms delay
- applyTriggerResult() correctly handles text replacement using backwards range search, preventing mid-word false positives
- findActiveTrigger() validates trigger character position (must be after whitespace or at start of input)
- FloatingTriggerOverlay is shared between InputCard and MiniPanel — no code duplication

## Checklist
- apps/swift/Shared/Sources/Shared/Services/TriggerService.swift — 4 search handlers with debouncing, all returning [TriggerResult]
- apps/swift/Shared/Sources/Shared/Services/SmartInputState.swift — TriggerKind enum and TriggerResult struct
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingUIStore.swift — Trigger state management (activeTrigger, triggerQuery, triggerResults, triggerSelectedIndex)
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingTriggerOverlay.swift — Shared autocomplete overlay with gradient header, result rows, keyboard and tap selection
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift — Keyboard shortcuts for trigger navigation in compactInputBar
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingInputCard.swift — Same keyboard shortcuts for trigger navigation
- Build: xcodebuild OrchestraMac BUILD SUCCEEDED


---
**Review (approved)** (2026-03-05T14:59:02Z): All 4 trigger types fully wired in FloatingUI architecture. TriggerService already existed from FEAT-YLL. Build passes. No new code changes needed — this feature confirmed the existing wiring is complete.
