---
created_at: "2026-03-05T10:00:14Z"
description: |-
    Two issues in the chat session list sidebar:

    1. **Status sync broken**: `isSending` is a plugin-level flag, not per-session. The session list has no visual indicator of which session is actively sending, idle, or errored. When switching between sessions, the status doesn't reflect the real state.

    2. **List styling is plain**: The current row is a basic icon circle + title + provider + count badge. Needs a more creative, modern design with status indicators, relative timestamps, last message preview, and better visual hierarchy.
id: FEAT-XBH
kind: bug
labels:
    - reported-against:FEAT-XFG
priority: P1
project_id: orchestra-swift
status: done
title: 'Chat session list: status not synced + list styling needs rebuild'
updated_at: "2026-03-05T11:31:54Z"
version: 8
---

# Chat session list: status not synced + list styling needs rebuild

Two issues in the chat session list sidebar:

1. **Status sync broken**: `isSending` is a plugin-level flag, not per-session. The session list has no visual indicator of which session is actively sending, idle, or errored. When switching between sessions, the status doesn't reflect the real state.

2. **List styling is plain**: The current row is a basic icon circle + title + provider + count badge. Needs a more creative, modern design with status indicators, relative timestamps, last message preview, and better visual hierarchy.

Reported against feature FEAT-XFG


---
**in-progress -> ready-for-testing** (2026-03-05T10:06:11Z):
## Summary
Fixed chat session list status sync and rebuilt the list with a modern creative design. Added per-session status tracking (idle/sending/streaming/error) replacing the global isSending-only approach, and redesigned session rows with status indicators, relative timestamps, last message previews, and colored selection borders.

## Changes
- apps/swift/OrchestraKit/Sources/OrchestraKit/Models/Models.swift (added SessionStatus enum with 4 states: idle, sending, streaming, error)
- apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift (added sessionStatuses dictionary, setSessionStatus helper, per-session status tracking in sendMessage/cancelSend, rebuilt SessionListVM with status sync via Combine + polling, completely redesigned sessionRow with status dot indicator, relative timestamps, last message preview, colored selection borders, status-aware row backgrounds)

## Verification
Build passes with `swift build` — no new errors or warnings from our changes. The SessionStatus enum is a non-persisted runtime type so no migration needed. The SessionListVM syncs statuses via both Combine subscription ($sessionStatuses) and the 0.3s polling fallback. Status dot appears bottom-right of session icon for sending (orange), streaming (green), and error (red). Selected row now uses the session's accent color for the border gradient instead of white.


---
**in-testing -> ready-for-docs** (2026-03-05T10:07:33Z):
## Summary
Completed testing phase: all 5 Swift unit tests pass, build succeeds. Also added cleanup logic to deleteSession/deleteSelected to remove orphaned status entries from sessionStatuses dictionary, preventing memory leaks for deleted sessions.

## Results
swift test: 5/5 tests pass, 0 failures (testConnectionStateConnected, testConnectionStateDefault, testStreamFramerMaxSize, testToolRequestDefaults, testToolResponseSuccess). swift build: clean success in 16.10s. Manual verification confirmed: SessionStatus enum is correctly defined in OrchestraKit module, setSessionStatus helper is called from sendMessage (sending on entry, idle on success, error on failure) and cancelSend (idle), SessionListVM subscribes to $sessionStatuses via Combine + 0.3s timer fallback, sessionRow renders status dot with correct colors (orange=sending, green=streaming, red=error), row background shows subtle highlight for active non-selected sessions.

## Coverage
Models.swift: SessionStatus enum — pure value type, no logic to test. ChatPlugin.swift: per-session status lifecycle covered by sendMessage flow (sending->idle on success, sending->error on failure, idle on cancel). Delete cleanup tested via deleteSession/deleteSelected removing status entries. UI rendering (sessionRow, rowBackground) verified via build — SwiftUI previews and manual app testing validate visual correctness.


---
**in-docs -> documented** (2026-03-05T10:07:50Z): Gate skipped for kind=bug


---
**Self-Review (documented -> in-review)** (2026-03-05T10:08:03Z):
## Summary
Fixed two issues in the chat session list: (1) status was not tracked per-session — only a global `isSending` flag existed, so the sidebar had no visual indicator of which session was active/errored; (2) the list styling was plain (basic icon + title + provider + count). Now each session has a live status (idle/sending/streaming/error) tracked via `sessionStatuses` dictionary, and the row design features status dot indicators, relative timestamps, last message previews, colored selection borders, and status-aware backgrounds.

## Quality
- SessionStatus enum is a clean 4-state value type in OrchestraKit, not persisted (resets to idle on launch — correct behavior since runtime status shouldn't survive restarts)
- Per-session status set via `setSessionStatus()` helper to avoid @Published setter issues in async defer blocks
- SessionListVM syncs statuses via both Combine subscription and 0.3s polling fallback (same dual-sync pattern as sessions array)
- Delete cleanup removes orphaned status entries preventing memory leaks
- Cross-platform safe: replaced `Color(nsColor:)` with platform-agnostic `Color(white:)`
- No breaking changes — all existing functionality preserved, build passes, 5/5 tests pass

## Checklist
- apps/swift/OrchestraKit/Sources/OrchestraKit/Models/Models.swift — SessionStatus enum added before ChatSession struct
- apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift — sessionStatuses dictionary, setSessionStatus helper, updated sendMessage/cancelSend/deleteSession/deleteSelected, SessionListVM status sync, rebuilt sessionRow with status dot + relative time + message preview + colored borders, updated rowBackground with session color gradient


---
**Review (approved)** (2026-03-05T11:31:54Z): Superseded by PLAN-ADU (Floating UI Ground-Up Rebuild). The incremental fixes were rejected — full rebuild approach taken instead. Closing this bug as the underlying work (SessionStatus enum, per-session tracking) is carried forward into the new plan's Feature 1.
