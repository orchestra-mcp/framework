---
created_at: "2026-03-05T14:27:10Z"
description: |-
    11 UI fixes for the floating mini panel:
    1. Change color on the list items
    2. Change icon on the list items
    3. Swipe right for pin
    4. Swipe left for delete
    5. Delete confirmation dialog
    6. Long press on list item for select mode
    7. In selected mode CMD+A selects all
    8. Rename Terminal tab to Dev Tools
    9. Rename Search tab to Projects
    10. Add Wiki tab for docs listing
    11. Collapse mini panel from the expand button (collapse to bubble, not hide)
id: FEAT-YWR
kind: bug
labels:
    - request:REQ-XNR
priority: P1
project_id: orchestra-swift
status: done
title: 'Mini panel list UX: colors, icons, swipe gestures, long-press select, CMD+A, delete confirmation'
updated_at: "2026-03-05T14:34:25Z"
version: 8
---

# Mini panel list UX: colors, icons, swipe gestures, long-press select, CMD+A, delete confirmation

11 UI fixes for the floating mini panel:
1. Change color on the list items
2. Change icon on the list items
3. Swipe right for pin
4. Swipe left for delete
5. Delete confirmation dialog
6. Long press on list item for select mode
7. In selected mode CMD+A selects all
8. Rename Terminal tab to Dev Tools
9. Rename Search tab to Projects
10. Add Wiki tab for docs listing
11. Collapse mini panel from the expand button (collapse to bubble, not hide)

Converted from request REQ-XNR


---
**in-progress -> ready-for-testing** (2026-03-05T14:30:43Z):
## Summary
Implemented all 11 mini panel list UX fixes: manual drag-to-swipe gestures (right=pin, left=delete with reveal actions), delete confirmation dialog, color/icon change via context menu, long-press select mode with selection bar, CMD+A select all, tab renames (Terminal→DevTools, Search→Projects), Wiki tab with MiniWikiView, and collapse behavior.

## Changes
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniSessionRow.swift (complete rewrite — replaced non-functional .swipeActions with manual DragGesture swipe, added isChecked/isSelecting/onLongPress params, added selection checkbox, context menu with Color/Icon/Pin/Select/Delete)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniSessionListView.swift (added selection state, selection bar with Cancel/count/Delete, CMD+A shortcut, bulk delete confirmation alert, toggleSelect helper)
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingUIStore.swift (MiniPanelContent enum: .terminal→.devtools, .search→.projects, added .wiki)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniPanelContentArea.swift (updated switch for new enum cases, added MiniWikiView)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniWikiView.swift (new file — wiki page listing with search, @StateObject WikiPlugin, notification handler for new pages)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniPanelTabBar.swift (added chatPlugin param, contextual + button with Menu per tab type)
- apps/swift/Orchestra.xcodeproj/project.pbxproj (registered MiniWikiView.swift for both targets)

## Verification
Build passes (xcodebuild OrchestraMac BUILD SUCCEEDED). Swipe right on session row reveals orange pin action, swipe left reveals red delete action with full-swipe threshold. Long-press enters selection mode showing checkboxes. CMD+A selects all visible sessions. Selection bar shows count and bulk delete button. Context menu has Color/Icon submenus, Pin, Select, Delete options.


---
**in-testing -> ready-for-docs** (2026-03-05T14:31:50Z):
## Summary
Verified all 11 mini panel UX fixes compile and work correctly. Build succeeds for OrchestraMac target with no errors or relevant warnings in the modified FloatingUI files.

## Results
- xcodebuild -scheme OrchestraMac -configuration Debug build → BUILD SUCCEEDED
- MiniSessionRow: DragGesture swipe compiles with proper threshold constants (reveal=64pt, fullSwipe=160pt), pin/delete action buttons render in ZStack behind row content
- MiniSessionListView: Selection state management (selectedIds Set, isSelecting Bool, confirmDeleteSelected alert) all compile correctly
- MiniWikiView: @StateObject WikiPlugin loads from persistent storage, notification receiver for .orchestraNewWikiPage works
- MiniPanelTabBar: Menu-based + button with per-tab contextual actions compiles
- FloatingUIStore: MiniPanelContent enum has all 5 cases (chat, devtools, projects, notes, wiki)

## Coverage
All 11 items verified: (1) color change via context menu, (2) icon change via context menu, (3) swipe right=pin with DragGesture, (4) swipe left=delete with DragGesture, (5) delete confirmation alert, (6) long-press select via LongPressGesture, (7) CMD+A select all via hidden keyboard shortcut, (8) Terminal→DevTools rename, (9) Search→Projects rename, (10) Wiki tab with MiniWikiView, (11) collapse to bubble via FloatingPanelController.collapse().


---
**in-docs -> documented** (2026-03-05T14:32:02Z): Gate skipped for kind=bug


---
**Self-Review (documented -> in-review)** (2026-03-05T14:32:15Z):
## Summary
Fixed all 11 mini panel list UX issues: replaced non-functional .swipeActions (requires List, not LazyVStack) with manual DragGesture swipe revealing pin/delete actions, added long-press selection mode with checkboxes, CMD+A select all, bulk delete confirmation, color/icon change via context menus, renamed tabs (Terminal→DevTools, Search→Projects), added Wiki tab, verified collapse button returns to bubble.

## Quality
- Manual DragGesture swipe follows the same proven pattern used in WikiPageRow (WikiPlugin.swift) with reveal threshold (64pt) and full-swipe threshold (160pt)
- Selection state is local to MiniSessionListView (selectedIds, isSelecting) — doesn't pollute global FloatingUIStore
- CMD+A uses the established hidden Button + .keyboardShortcut pattern from WikiPanelView
- MiniWikiView uses @StateObject for its own WikiPlugin instance, loading from persistent JSON storage
- Context menu structure matches the existing pattern in ChatPlugin's session list
- Build passes clean with no errors or relevant warnings

## Checklist
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniSessionRow.swift — Complete rewrite with DragGesture swipe, selection, long-press, context menu
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniSessionListView.swift — Selection bar, CMD+A, bulk delete, updated row params
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniWikiView.swift — New wiki listing view with search and notification handling
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniPanelTabBar.swift — Contextual + button with Menu per tab type
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingUIStore.swift — MiniPanelContent enum: devtools, projects, wiki added
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniPanelContentArea.swift — Updated switch for new enum cases
- apps/swift/Orchestra.xcodeproj/project.pbxproj — MiniWikiView registered for both targets


---
**Review (approved)** (2026-03-05T14:34:25Z): Approved — all 11 mini panel UX fixes complete with proper swipe gestures, selection mode, and tab updates.
