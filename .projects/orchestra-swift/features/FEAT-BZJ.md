---
estimate: S
id: FEAT-BZJ
kind: feature
priority: P2
project_slug: orchestra-swift
status: done
title: Configurable loading words while agent responds
type: feature
---

# Configurable loading words while agent responds

Replace the static 3-dot typing indicator with animated loading words (e.g. 'Analyzing your codebase', 'Reading files', 'Writing code'). Make the loading words configurable in Settings. Cycle through them with a fade animation while waiting for response.


---
**in-progress -> ready-for-testing**:
## Summary
Configurable loading words feature implemented. Replaces static typing indicator with animated cycling words while waiting for AI response. Words configurable in settings.

## Changes
- ChatPlugin.swift: Loading word timer that cycles through configured phrases with fade animation while isLoading is true. Default words: "Analyzing your codebase", "Reading files", "Writing code", "Thinking deeply", "Crafting response"
- Settings integration for customizing the loading word list

## Verification
- Build succeeds on SPM (swift build) and Xcode (xcodebuild OrchestraMac)
- Loading words cycle with smooth fade transition during AI response
- Words stop cycling when response arrives


---
**in-testing -> ready-for-docs**:
## Summary
Loading words tested — cycling animation works during AI response, stops when response arrives.

## Results
- Build succeeds on SPM and Xcode
- Timer-based word cycling with fade transition verified
- Words reset when isLoading becomes false
- Default word list renders correctly

## Coverage
- Loading word timer lifecycle: start on isLoading=true, stop on isLoading=false
- Fade animation between words
- Edge case: empty word list, single word, rapid loading state changes


---
**in-docs -> documented**:
## Summary
Configurable loading words replace static typing indicator with animated cycling phrases during AI response. Words customizable in settings.

## Location
- ChatPlugin.swift: Loading word timer, fade animation, default word list
- Settings integration for word list customization


---
**Self-Review (documented -> in-review)**:
## Summary
Configurable loading words replace static typing indicator. Animated cycling phrases shown during AI response with fade transitions. Default words: "Analyzing your codebase", "Reading files", "Writing code", "Thinking deeply", "Crafting response".

## Quality
- Timer-based cycling with proper cleanup on state change
- Smooth fade animation between words
- Configurable word list via settings
- No memory leaks (timer invalidated on isLoading=false)

## Checklist
- [x] Words cycle with fade animation during loading
- [x] Animation stops when response arrives
- [x] Default word list provided
- [x] Build succeeds on SPM and Xcode


---
**Review (approved)**: User approved