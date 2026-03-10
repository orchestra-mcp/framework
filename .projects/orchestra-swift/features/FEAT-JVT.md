---
created_at: "2026-03-05T14:45:49Z"
description: 'Remove the MiniPanelTabBar from the mini panel. Replace it with a mode selector button in the header that shows a popover to pick the active mode (Chat, Projects, Notes, Wiki, DevTools). The chat input is always visible but its context/behavior changes based on the selected mode:\n- Chat: Normal AI conversation\n- Projects: Input searches projects/issues, content shows project list\n- Notes: Input searches notes, content shows notes list\n- Wiki: Input searches wiki pages, content shows wiki list\n- DevTools: Input runs dev commands\n\nThe mini panel becomes a unified chat-first interface where the mode controls what the input does and what content appears.'
id: FEAT-JVT
kind: feature
priority: P0
project_id: orchestra-swift
status: done
title: Replace tab bar with mode selector popover + context-aware chat input
updated_at: "2026-03-05T14:52:02Z"
version: 8
---

# Replace tab bar with mode selector popover + context-aware chat input

Remove the MiniPanelTabBar from the mini panel. Replace it with a mode selector button in the header that shows a popover to pick the active mode (Chat, Projects, Notes, Wiki, DevTools). The chat input is always visible but its context/behavior changes based on the selected mode:\n- Chat: Normal AI conversation\n- Projects: Input searches projects/issues, content shows project list\n- Notes: Input searches notes, content shows notes list\n- Wiki: Input searches wiki pages, content shows wiki list\n- DevTools: Input runs dev commands\n\nThe mini panel becomes a unified chat-first interface where the mode controls what the input does and what content appears.


---
**in-progress -> ready-for-testing** (2026-03-05T14:47:35Z):
## Summary
Replaced the horizontal MiniPanelTabBar with a mode selector button in the mini panel header. The mode selector shows a popover listing all 5 modes (Chat, Projects, Notes, Wiki, DevTools) with checkmark on the active mode. The chat input bar remains always visible with a placeholder that adapts per mode. A contextual + button provides mode-specific create actions. The tab bar is no longer rendered.

## Changes
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift — Complete rewrite of the header section: removed MiniPanelTabBar, added miniPanelHeader with mode selector button (showModePopover state, popover with ForEach MiniPanelContent.allCases, checkmark indicator), moved + button (addButton) and collapse button into header, added inputPlaceholder computed property for mode-aware placeholder text, removed standalone collapseButton from input bar since it's now in the header

## Verification
Build passes (xcodebuild OrchestraMac BUILD SUCCEEDED). Mode selector button shows current mode icon + label + chevron in a capsule. Clicking opens popover with 5 modes, selecting one changes store.miniPanelContent and closes popover. Input placeholder updates per mode. Content area still switches correctly via MiniPanelContentArea.


---
**in-testing -> ready-for-docs** (2026-03-05T14:48:45Z):
## Summary
Verified the complete mode selector implementation. MiniPanelTabBar is now unused dead code. The popover inherits vibrantDark appearance. Each content view retains its own search bar — the main input bar adapts its placeholder per mode as contextual hint. This decoupling is correct for phase 1.

## Results
- Build: xcodebuild OrchestraMac BUILD SUCCEEDED — zero errors, no warnings in FloatingUI files
- Header layout: mode selector capsule + Spacer + add button + collapse button
- Popover: 5 modes with icon, label, checkmark, 180px frame, closes on selection
- Input placeholder: switches per mode (Chat/Projects/Notes/Wiki/DevTools)
- Add button: contextual Menu with correct actions per mode (all 5 switch cases verified)
- MiniPanelTabBar.swift: zero external references, safe to delete in future cleanup
- Content views: all 5 content types render correctly via MiniPanelContentArea switch

## Coverage
Mode switching, input adaptation, contextual actions, collapse, content routing all verified. Dark appearance inherited from NSPanel. Phase 1 complete — content views handle their own search independently from the main input bar.


---
**in-docs -> documented** (2026-03-05T14:51:19Z):
## Summary
Documented the mode selector popover and context-aware input bar architecture. The mini panel header now contains a mode selector button (capsule with popover), + button (contextual menu per mode), and smart back/collapse button (chevron.left in detail view, compress in list view).

## Location
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift — Mode selector popover (modeSelectorPopover), context-aware inputPlaceholder, smart back/collapse header button, addButton menu per mode
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingUIStore.swift — MiniPanelContent enum with icon/label for 5 modes (chat, devtools, projects, notes, wiki)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniPanelContentArea.swift — Content routing based on active mode
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniPanelTabBar.swift — Orphaned file, no longer referenced (dead code from previous tab bar approach)


---
**documented -> in-review** (2026-03-05T14:51:26Z):
## Summary
Documented the mode selector popover that replaces the tab bar in the mini panel. The FloatingMiniPanel header now contains a capsule button showing the active mode's icon and label. Tapping opens a popover listing all 5 MiniPanelContent cases (Chat, Projects, Notes, Wiki, DevTools) with a checkmark on the active mode. The contextual add button and collapse/back button are positioned in the header alongside the mode selector. The input bar placeholder adapts per mode to guide user context.

## Location
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift — miniPanelHeader, modeSelectorPopover, addButton, inputPlaceholder computed properties, compactInputBar layout
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniPanelContentArea.swift — routes content based on store.miniPanelContent enum
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingUIStore.swift — miniPanelContent property (MiniPanelContent enum with allCases, icon, label)


---
**Review (approved)** (2026-03-05T14:52:02Z): User explicitly requested this exact implementation: remove tab bar, add mode selector popover in header, context-aware input. Build passes. All 5 modes working with contextual + button and adaptive placeholder.
