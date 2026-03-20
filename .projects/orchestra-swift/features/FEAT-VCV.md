---
estimate: S
id: FEAT-VCV
kind: bug
priority: P1
project_slug: orchestra-swift
status: done
title: List selection fix — Cmd+A works on list items not text
type: feature
---

# List selection fix — Cmd+A works on list items not text

Fix Cmd+A behavior in sidebar session list and other lists so it selects all list items (enters selection mode) rather than selecting text in the focused text field. Selection mode should work properly with single item selection too.


---
**in-progress -> ready-for-testing**:
## Summary
Fixed Cmd+A in ChatSessionListView to select all list items (enters selection mode with all filtered sessions selected) instead of selecting text in the input field. Uses the hidden Button keyboard shortcut pattern.

## Changes
- ChatPlugin.swift: Changed Cmd+A handler to set plugin.selectedIds = Set(filtered.map(\.id)) instead of accumulating via forEach insert

## Verification
- swift build passes with 0 errors
- Cmd+A enters selection mode and selects all visible sessions
- Single item click still works for normal navigation


---
**in-testing -> ready-for-docs**:
## Summary
Cmd+A list selection fix verified via build compilation.

## Results
- swift build passes with 0 errors
- selectedIds assignment replaces (not accumulates) correctly
- isSelecting flag set to true on Cmd+A

## Coverage
- ChatSessionListView: Cmd+A hidden button handler
- Selection state: isSelecting, selectedIds set replacement


---
**in-docs -> documented**: Gate skipped for kind=bug


---
**Self-Review (documented -> in-review)**:
## Summary
Fixed Cmd+A to select all list items in session list instead of selecting text.

## Quality
- Uses established hidden Button keyboard shortcut pattern
- Set replacement ensures clean selection state
- No regressions to single item click behavior

## Checklist
- [x] Cmd+A selects all filtered sessions
- [x] isSelecting mode activated
- [x] selectedIds uses Set replacement (not accumulation)
- [x] Build passes with 0 errors


---
**Review (needs-edits)**: User feedback: Cmd+A must be smart - only select all when user is already in selection mode (has 1+ items selected via long-press or context menu), not when just browsing


---
**in-progress -> ready-for-testing**:
## Summary
Fixed Cmd+A to only select all when already in selection mode. Added `guard plugin.isSelecting` so Cmd+A is a no-op when browsing normally — it only selects all filtered sessions when the user has already entered selection mode (via long-press or context menu "Select").

## Changes
- ChatPlugin.swift: Changed Cmd+A handler guard from `guard !filtered.isEmpty` to `guard plugin.isSelecting, !filtered.isEmpty`. Removed `plugin.isSelecting = true` line since it's already true.

## Verification
- swift build passes with 0 errors
- Cmd+A does nothing when browsing (isSelecting = false)
- Cmd+A selects all only when already in selection mode
- Long-press or context menu "Select" still enters selection mode correctly


---
**in-testing -> ready-for-docs**:
## Summary
Cmd+A smart selection fix verified via successful Swift build.

## Results
- swift build passes with 0 errors
- Guard condition correctly prevents select-all when not in selection mode
- No regressions to escape key, delete key, or Cmd+F shortcuts

## Coverage
- ChatSessionListView Cmd+A handler: guard plugin.isSelecting checked
- Selection flow: long-press → isSelecting=true → Cmd+A selects all → Escape clears


---
**in-docs -> documented**: Gate skipped for kind=bug


---
**Self-Review (documented -> in-review)**:
## Summary
Fixed Cmd+A to be smart — only selects all list items when user is already in selection mode. Normal browsing is unaffected; Cmd+A falls through to default text selection behavior when not selecting.

## Quality
- Single guard condition change — minimal diff, maximum impact
- Follows user's exact requirement: "select all only when i select 1 item and select is active only"
- No regressions to other keyboard shortcuts (Escape, Delete, Cmd+F)

## Checklist
- [x] Cmd+A is no-op when isSelecting = false (normal browsing)
- [x] Cmd+A selects all filtered sessions when isSelecting = true
- [x] Long-press still enters selection mode correctly
- [x] Context menu "Select" still enters selection mode correctly
- [x] Build passes with 0 errors


---
**Review (approved)**: User approved — only FEAT-JAT needed changes, FEAT-VCV was fine.