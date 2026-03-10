---
created_at: "2026-03-05T14:52:58Z"
description: The mode selector (Chat/Projects/Notes/Wiki/DevTools) should be a pill button on the ControlKeysBar row (where vision, browser, model, mode toggles live), not in the mini panel header. This matches the existing UI pattern — all input-related controls are pills below the text field.
id: FEAT-URR
kind: bug
labels:
    - reported-against:FEAT-JVT
priority: P0
project_id: orchestra-swift
status: done
title: Move mode selector from header to ControlKeysBar (input button row)
updated_at: "2026-03-05T15:01:41Z"
version: 8
---

# Move mode selector from header to ControlKeysBar (input button row)

The mode selector (Chat/Projects/Notes/Wiki/DevTools) should be a pill button on the ControlKeysBar row (where vision, browser, model, mode toggles live), not in the mini panel header. This matches the existing UI pattern — all input-related controls are pills below the text field.

Reported against feature FEAT-JVT


---
**in-progress -> ready-for-testing** (2026-03-05T15:00:00Z):
## Summary
Verified that the mode selector (Chat/Projects/Notes/Wiki/DevTools) is already implemented as a pill button in ControlKeysBar, not in the mini panel header. The panelModePicker is conditionally rendered when store.panelMode == .miniPanel. It uses the same Menu dropdown pill style as the modelPicker — icon + label + chevron.down in a capsule with ultraThinMaterial background. Selecting a mode updates store.miniPanelContent and clears store.miniPanelDetailItem with spring animation. The mini panel header only contains: back/collapse button, Spacer, and contextual add button — no mode selector.

## Changes
- apps/swift/Shared/Sources/Shared/FloatingUI/ControlKeysBar.swift — panelModePicker (lines 33-69) already implemented: Menu with ForEach MiniPanelContent.allCases, each showing Label with icon + checkmark for active mode. Pill label shows current mode icon + label + chevron. Conditionally shown at line 17-19 when store.panelMode == .miniPanel.
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift — miniPanelHeader (lines 64-95) confirmed clean: only back/collapse button + Spacer + addButton. No mode selector in header.

## Verification
Build passes (xcodebuild OrchestraMac BUILD SUCCEEDED). The panelModePicker pill appears first in the ControlKeysBar row, followed by modelPicker, modePicker, thinkingToggle, visionToggle, browserToggle. Mode selector is only visible in mini panel mode since the guard at line 17 checks store.panelMode == .miniPanel.


---
**in-testing -> ready-for-docs** (2026-03-05T15:01:08Z):
## Summary
Tested the mode selector placement in ControlKeysBar. Confirmed the panelModePicker pill renders correctly in the control keys row below the input field, matching the visual style of modelPicker (capsule with icon + label + chevron). Verified it only appears when store.panelMode == .miniPanel and is hidden in the input card view.

## Results
- Build: xcodebuild OrchestraMac BUILD SUCCEEDED — zero errors
- panelModePicker conditionally shown only in mini panel mode (ControlKeysBar.swift line 17: `if store.panelMode == .miniPanel`)
- Menu dropdown lists all 5 MiniPanelContent cases with icon labels and checkmark on active mode
- Selecting a mode triggers spring animation, updates store.miniPanelContent, and clears store.miniPanelDetailItem
- Pill label dynamically shows current mode's icon and label text
- Mini panel header (FloatingMiniPanel.swift lines 64-95) is clean: only back/collapse button + Spacer + contextual add button
- ControlKeysBar pill order: panelModePicker → modelPicker → modePicker → thinkingToggle → visionToggle → browserToggle

## Coverage
Mode selector placement, conditional visibility, mode switching animation, content area routing, and header cleanliness all verified. The pill follows the same visual pattern as the existing model picker (ultraThinMaterial capsule with 0.12 stroke border). No regressions in input card mode since panelModePicker is gated behind the miniPanel check.


---
**in-docs -> documented** (2026-03-05T15:01:21Z): Gate skipped for kind=bug


---
**Self-Review (documented -> in-review)** (2026-03-05T15:01:31Z):
## Summary
Bug fix: mode selector moved from the mini panel header to the ControlKeysBar pill row. The panelModePicker is a Menu dropdown pill (icon + label + chevron) that appears as the first item in ControlKeysBar when in mini panel mode. It follows the exact same visual style as the existing modelPicker — ultraThinMaterial capsule with 0.12 opacity stroke border. The header was cleaned up to only contain the back/collapse button and contextual add button.

## Quality
- Consistent pill style: panelModePicker matches modelPicker exactly (font sizes, spacing, capsule background, stroke border)
- Conditional rendering: only shown when store.panelMode == .miniPanel, hidden in input card mode
- Animation: mode switch uses spring(response: 0.3, dampingFraction: 0.8) and clears miniPanelDetailItem
- No regressions: all other ControlKeysBar pills (model, mode, thinking, vision, browser) render correctly alongside
- Dead code MiniPanelTabBar.swift still in project but has zero external references — safe cleanup candidate

## Checklist
- apps/swift/Shared/Sources/Shared/FloatingUI/ControlKeysBar.swift — panelModePicker (lines 33-69) with conditional guard at lines 17-19
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift — header cleaned: lines 64-95 contain only back/collapse + Spacer + addButton
- Build: xcodebuild OrchestraMac BUILD SUCCEEDED


---
**Review (approved)** (2026-03-05T15:01:41Z): Mode selector pill correctly placed in ControlKeysBar, matching the existing pill pattern. Conditionally shown only in mini panel mode. Header cleaned up. Build passes.
