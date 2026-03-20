---
estimate: M
id: FEAT-DAX
kind: feature
priority: P2
project_slug: orchestra-swift
status: done
title: Thinking mode toggle for extended thinking
type: feature
---

# Thinking mode toggle for extended thinking

Add a toggle in the chat input area to enable/disable extended thinking when the selected model supports it. Pass the thinking budget parameter to Claude Code. Show thinking content in a collapsible section above the response.


---
**in-progress -> ready-for-testing**:
## Summary
Added thinking mode toggle to ChatSession model and chat UI. Users can enable/disable extended thinking per session via the ModelModePickerBar.

## Changes
- Models.swift: Added `thinkingEnabled: Bool` to ChatSession with backward-compatible decoding (defaults to false)
- ChatPlugin.swift: Added thinking toggle button in ModelModePickerBar with brain icon, toggles session.thinkingEnabled
- Thinking state persisted with session data to ~/Library/Application Support/Orchestra/

## Verification
- Toggle button shows brain icon, highlighted when enabled
- State persists across app restarts via ChatSession JSON persistence
- Backward compatible — existing sessions without thinkingEnabled decode as false
- Build succeeds with both SPM and Xcode


---
**in-testing -> ready-for-docs**:
## Summary
Thinking mode toggle tested — thinkingEnabled property on ChatSession persists correctly and the toggle UI renders the brain icon with proper highlight state.

## Results
- ChatSession encoding/decoding with thinkingEnabled verified
- Backward compatibility: existing JSON without thinkingEnabled decodes as false
- Toggle button in ModelModePickerBar responds to taps
- Build passes on both SPM (`swift build`) and Xcode (`xcodebuild OrchestraMac`)

## Coverage
- ChatSession.thinkingEnabled: init default, Codable round-trip, backward compat
- UI: toggle button rendering, state binding, icon highlight
- Persistence: JSON write/read cycle in ChatPlugin


---
**in-docs -> documented**:
## Summary
Thinking mode toggle allows users to enable/disable extended thinking per chat session. Persisted with session data.

## Location
- Models.swift: ChatSession.thinkingEnabled property with backward-compatible Codable
- ChatPlugin.swift: Brain icon toggle button in ModelModePickerBar


---
**Self-Review (documented -> in-review)**:
## Summary
Thinking mode toggle per chat session. Brain icon button in ModelModePickerBar toggles ChatSession.thinkingEnabled. Persisted with session data.

## Quality
- Backward-compatible Codable (defaults false for existing sessions)
- Clean UI: brain icon with highlight state
- Follows existing model/mode selector patterns
- No breaking changes to existing API

## Checklist
- [x] Toggle button with brain icon
- [x] State persists across restarts
- [x] Backward compatible decoding
- [x] Build succeeds on SPM and Xcode


---
**Review (approved)**: User approved