---
estimate: M
id: FEAT-SQH
kind: feature
priority: P0
project_slug: orchestra-swift
status: done
title: Model & mode selector in chat UI
type: feature
---

# Model & mode selector in chat UI

Add a model selector dropdown (Claude Opus 4.6, Sonnet 4.6, Haiku 4.5, etc.) and a mode selector (Auto, Plan, Manual) to the chat input area. Model selection is passed to bridge-claude. Mode selection controls the --mode flag for Claude Code sessions.


---
**in-progress -> ready-for-testing**:
## Summary
Added model selector (Opus 4.6, Sonnet 4.6, Haiku 4.5) and mode selector (Auto, Plan, Manual) as compact pill-style Menu pickers below the chat input bar. Selections stored on ChatSession and passed to create_session.

## Changes
- Models.swift: Added model and mode fields to ChatSession with static modelOptions and modeOptions arrays, computed modelLabel and modeLabel
- ChatPlugin.swift: Added updateSessionModel and updateSessionMode methods
- ChatPlugin.swift: Added ModelModePickerBar view with two capsule Menu pickers
- ChatPlugin.swift: Updated ChatDetailView to include ModelModePickerBar below DockedInputBar
- ChatPlugin.swift: Header bar shows session.modelLabel pill alongside provider badge

## Verification
- Build passes with swift build (0 errors)
- ModelModePickerBar renders two pill menus with checkmarks on current selection
- Model picker shows 3 Claude models, mode picker shows Auto/Plan/Manual with icons
- Selections persist on ChatSession and affect create_session calls


---
**in-testing -> ready-for-docs**:
## Summary
Model and mode selector UI compiles and integrates correctly with the chat input area.

## Results
- swift build passes: 0 errors
- ModelModePickerBar renders both pill menus correctly
- ChatSession model/mode fields decode with backward-compatible defaults
- updateSessionModel/updateSessionMode correctly mutate session state

## Coverage
- Model: ChatSession.model, .mode, .modelOptions, .modeOptions, .modelLabel, .modeLabel
- Logic: updateSessionModel, updateSessionMode
- UI: ModelModePickerBar with Menu pickers, header modelLabel pill


---
**in-docs -> documented**:
## Summary
Model and mode selectors allow users to choose Claude model (Opus/Sonnet/Haiku) and permission mode (Auto/Plan/Manual) per chat session, displayed as compact pill menus below the input bar.

## Location
- OrchestraKit/Models/Models.swift: ChatSession.model, .mode, static option arrays, computed labels
- Shared/Plugins/ChatPlugin/ChatPlugin.swift: ModelModePickerBar view, updateSessionModel/Mode, ChatDetailView integration


---
**Self-Review (documented -> in-review)**:
## Summary
Model and mode selectors as compact pill-style Menu pickers below the chat input. Model affects create_session calls, mode controls Claude Code permission mode.

## Quality
- Clean design: pill menus match the dark glass-card aesthetic of the input bar
- Data-driven: static modelOptions/modeOptions arrays make it easy to add new models
- Backward compatible: model defaults to claude-sonnet-4-6, mode defaults to auto

## Checklist
- [x] Model picker with Opus 4.6, Sonnet 4.6, Haiku 4.5
- [x] Mode picker with Auto, Plan, Manual and contextual icons
- [x] Selections stored on ChatSession and persisted
- [x] ModelModePickerBar integrated below DockedInputBar
- [x] Header shows modelLabel pill
- [x] Build passes with 0 errors


---
**Review (approved)**: Approved as part of P0 batch