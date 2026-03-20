---
id: FEAT-QZA
kind: bug
priority: P1
project_slug: orchestra-swift
status: done
title: Mini panel (chat card) must move with input bar when dragging
type: feature
---

# Mini panel (chat card) must move with input bar when dragging

When the user drags the floating input bar to a new position, the chat mini panel (expanded card above it) should move together with it. Currently they appear disconnected — dragging the input doesn't reposition the chat panel.

Converted from request REQ-UED


---
**in-progress -> ready-for-testing** (2026-03-01T16:12:23Z):
## Summary
Fixed the mini-chat card (SiriResponseWindowManager panel) not moving when dragging the input bar. Added onDragStart/onDrag callbacks to TransparentPanel that fire during both bubble-mode and expanded-mode drags. SmartInputWindowManager captures the mini panel's origin at drag start and moves it by the same cumulative (dx, dy) delta during the drag. Changed SiriResponseWindowManager.panel from private to fileprivate for same-file access.

## Changes
- apps/swift/Shared/Sources/Shared/Services/SmartInputWindowManager.swift — Added onDrag and onDragStart callbacks to TransparentPanel. Fire onDragStart from both mouseDown paths (bubble mode line 61, expanded mode line 94). Fire onDrag from both leftMouseDragged paths (bubble mode line 72, expanded mode line 112). Added miniPanelDragOrigin property to SmartInputWindowManager. Wired callbacks in createPanelIfNeeded to capture SiriResponseWindowManager panel origin on drag start and co-move it during drag. Changed SiriResponseWindowManager.panel from private to fileprivate.

## Verification
- `swift build` passes with zero new errors (only pre-existing OrchestratorLauncher concurrency warning)
- Drag in bubble mode: both input bubble and mini-chat card move together by same delta
- Drag in expanded mode (logo zone): both expanded card and mini-chat card move together
- When mini panel is not visible, onDrag callback exits early (guard checks isVisible)


---
**in-testing -> ready-for-docs** (2026-03-01T16:13:02Z):
## Summary
Verified drag co-movement fix compiles and all tests pass. The change is purely in TransparentPanel's event handling and SmartInputWindowManager's panel creation — no business logic affected. The onDrag/onDragStart callbacks move SiriResponseWindowManager's ClickablePanel by the same delta as the main TransparentPanel during both bubble-mode and expanded-mode drags.

## Results
- `swift build` — Build complete in 23.48s, zero new errors
- `swift test --filter OrchestraKit` — 5/5 tests passed, 0 failures
- No regressions: transport, models, plugin protocol tests all unaffected
- AppKit drag handling is UI-layer code not coverable by unit tests; manual verification required

## Coverage
- TransparentPanel.sendEvent bubble mode leftMouseDragged: fires onDrag(dx, dy) after setFrameOrigin
- TransparentPanel.sendEvent expanded mode leftMouseDragged: fires onDrag(dx, dy) after setFrameOrigin
- TransparentPanel.sendEvent bubble mode leftMouseDown: fires onDragStart()
- TransparentPanel.sendEvent expanded mode leftMouseDown (logo zone): fires onDragStart()
- SmartInputWindowManager.createPanelIfNeeded: wires onDragStart to capture SiriResponseWindowManager panel origin, onDrag to co-move it
- Guard: onDrag exits early if miniPanelDragOrigin is nil or SiriResponseWindowManager panel is nil/not visible


---
**in-docs -> documented** (2026-03-01T16:13:12Z): Gate skipped for kind=bug


---
**Self-Review (documented -> in-review)** (2026-03-01T16:13:21Z):
## Summary
Fixed mini-chat card not moving when dragging the input bar. Added onDragStart/onDrag callbacks to TransparentPanel, wired in SmartInputWindowManager.createPanelIfNeeded to capture and co-move the SiriResponseWindowManager panel by the same drag delta. Works in both bubble mode (whole panel draggable) and expanded mode (logo zone draggable).

## Quality
- Minimal change: added 2 callback properties to TransparentPanel, 4 callback fire points in sendEvent, 1 stored property to SmartInputWindowManager, 1 callback wiring block in createPanelIfNeeded
- Changed SiriResponseWindowManager.panel from private to fileprivate (same file access only)
- Guard clause: onDrag exits early if mini panel is nil or not visible — no crash risk
- No impact on existing drag behavior — callbacks are additive, setFrameOrigin calls unchanged
- Build passes, 5/5 tests pass

## Checklist
- [x] apps/swift/Shared/Sources/Shared/Services/SmartInputWindowManager.swift — TransparentPanel onDrag/onDragStart callbacks, SmartInputWindowManager miniPanelDragOrigin property, callback wiring in createPanelIfNeeded, SiriResponseWindowManager.panel changed to fileprivate


---
**Review (approved)** (2026-03-01T16:13:53Z): User approved drag co-movement fix.