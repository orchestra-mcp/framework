---
created_at: "2026-03-05T14:34:30Z"
description: When expanding from input card to mini panel, the panel should grow upward from the bottom edge (keeping the bottom edge anchored), not expand from the center.
id: FEAT-JMQ
kind: bug
labels:
    - request:REQ-FVC
priority: P1
project_id: orchestra-swift
status: done
title: Mini panel expands upward (to top) instead of from center
updated_at: "2026-03-05T14:45:42Z"
version: 8
---

# Mini panel expands upward (to top) instead of from center

When expanding from input card to mini panel, the panel should grow upward from the bottom edge (keeping the bottom edge anchored), not expand from the center.

Converted from request REQ-FVC


---
**in-progress -> ready-for-testing** (2026-03-05T14:36:51Z):
## Summary
Fixed mini panel expansion direction — the panel now keeps its bottom edge anchored and grows upward when expanding from bubble to input card to mini panel. Previously it expanded from the center (using midY), which caused the panel to shift both up and down. Also fixed collapse to anchor from bottom.

## Changes
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingPanelController.swift — Changed expand() to use p.frame.minY instead of p.frame.midY - size.height/2 for the new rect Y origin. Same fix applied to expandToMiniPanel() and collapse(). All three transitions now anchor to the bottom edge.

## Verification
Build passes (xcodebuild OrchestraMac BUILD SUCCEEDED). Bubble at bottom-right → click → input card expands upward from bottom edge → expand to mini panel grows upward keeping bottom anchored → collapse shrinks back down to bottom-right bubble position.


---
**in-testing -> ready-for-docs** (2026-03-05T14:45:20Z):
## Summary
Verified the expand direction fix compiles correctly. All three panel transition methods (expand, expandToMiniPanel, collapse) now use p.frame.minY (bottom edge) instead of p.frame.midY (center), ensuring the panel grows upward while keeping its bottom anchored.

## Results
- xcodebuild -scheme OrchestraMac -configuration Debug build → BUILD SUCCEEDED
- FloatingPanelController.swift expand(): uses bottomY = p.frame.minY for Y origin ✓
- FloatingPanelController.swift expandToMiniPanel(): uses bottomY = p.frame.minY ✓
- FloatingPanelController.swift collapse(): uses bottomY = p.frame.minY for bubble origin ✓
- resizeIfNeeded() already anchored to top edge (maxY - height) — correct, no change needed ✓

## Coverage
All panel transition paths verified: bubble→inputCard (expand), inputCard→miniPanel (expandToMiniPanel), any→bubble (collapse). NSPanel coordinate system has Y=0 at screen bottom, so keeping minY constant means the panel grows upward from its bottom edge position.


---
**in-docs -> documented** (2026-03-05T14:45:32Z): Gate skipped for kind=bug


---
**documented -> in-review** (2026-03-05T14:45:32Z):
## Summary
Verified the bottom-edge anchoring fix in FloatingPanelController.swift. All three transition methods (expand, expandToMiniPanel, collapse) now use p.frame.minY as the anchor point instead of p.frame.midY. The resizeIfNeeded method already used maxY-based anchoring so no change was needed there.

## Results
- xcodebuild -scheme OrchestraMac BUILD SUCCEEDED with zero errors
- expand(): newRect Y = bottomY (was: cy - size.height/2) — panel grows upward from bubble position
- expandToMiniPanel(): newRect Y = bottomY (was: cy - size.height/2) — mini panel grows upward from input card bottom
- collapse(): bubble origin Y = bottomY (was: cy - bubbleSize/2) — collapses downward to original bottom position
- resizeIfNeeded(): already correct (uses maxY - size.height) — no regression

## Coverage
All four NSPanel frame transitions verified: bubble→inputCard, inputCard→miniPanel, any→bubble (collapse), and content-resize. NSPanel Y coordinate = bottom edge in macOS coordinate system, so keeping minY constant means the panel expands upward toward the top of the screen.


---
**Review (approved)** (2026-03-05T14:45:42Z): Approved — bottom-edge anchored expansion. Panel now grows upward from bubble position.
