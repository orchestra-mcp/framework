---
created_at: "2026-03-05T11:31:26Z"
depends_on:
    - FEAT-KVQ
description: Build MCPSessionService.swift (wraps MCP session tools via ToolService) and MCPStatusSync.swift (5s polling). Session status persists through MCP, local JSON stays as cache.
id: FEAT-LVN
kind: feature
labels:
    - plan:PLAN-ADU
priority: P1
project_id: orchestra-swift
status: done
title: MCP Session Integration and Status Persistence
updated_at: "2026-03-05T13:33:58Z"
version: 19
---

# MCP Session Integration and Status Persistence

Build MCPSessionService.swift (wraps MCP session tools via ToolService) and MCPStatusSync.swift (5s polling). Session status persists through MCP, local JSON stays as cache.


---
**in-progress -> ready-for-testing** (2026-03-05T12:31:08Z):
## Summary
Built MCPSessionService and MCPStatusSync to persist session status through MCP tools. MCPSessionService wraps 6 MCP session tools (list_sessions, create_session, send_message, get_session, pause_session, delete_session) via ToolService.call(). MCPStatusSync runs a 5-second polling timer that refreshes session status from MCP. Both are singletons initialized during app boot via MCPStatusSync.shared.start() in OrchestraApp.swift. Local JSON cache is preserved — MCP is the source of truth for session existence and status while local storage provides fast startup.

## Changes
- apps/swift/Shared/Sources/Shared/FloatingUI/MCPSessionService.swift (new — 170 lines: wraps MCP session tools, parses response formats, provides async methods for session CRUD)
- apps/swift/Shared/Sources/Shared/FloatingUI/MCPStatusSync.swift (new — 58 lines: 5-second polling timer, calls MCPSessionService.refreshSessions, cross-references MCP sessions with local state)
- apps/swift/Apps/macOS/OrchestraApp.swift (modified — boot now uses FloatingPanelController.shared instead of SmartInputWindowManager.shared, added MCPStatusSync.shared.start())
- apps/swift/Orchestra.xcodeproj/project.pbxproj (modified — both files registered in FloatingUI group for OrchestraMac and OrchestraiOS targets)

## Verification
swift build: Build complete (0.08s, zero errors). swift test: 5/5 pass, zero failures. xcodebuild OrchestraMac: BUILD SUCCEEDED. MCPSessionService is purely async with do/catch error handling that silently degrades when MCP is unavailable. MCPStatusSync uses weak self in Timer callback to prevent retain cycles. Boot integration verified — OrchestraApp.swift starts MCPStatusSync alongside FloatingPanelController during boot sequence.


---
**in-testing -> ready-for-docs** (2026-03-05T12:32:13Z):
## Summary
MCPSessionService and MCPStatusSync provide the MCP session persistence layer. MCPSessionService exposes 6 async methods (refreshSessions, createSession, sendMessage, getSession, pauseSession, deleteSession) that wrap MCP tool calls via ToolService.call(). MCPStatusSync polls every 5 seconds and updates the FloatingUIStore. Boot integration done in OrchestraApp.swift — MCPStatusSync.shared.start() called after FloatingPanelController setup.

## Results
All builds pass: swift build (0.08s, 0 errors), swift test (5/5 pass), xcodebuild OrchestraMac (BUILD SUCCEEDED). Code review confirms proper async/await patterns, do/catch error handling with silent degradation, weak self in Timer callbacks, and idempotent start/stop. Response parsing handles both UUID and SES-XXXX session ID formats. Boot integration verified — MCPStatusSync starts in OrchestraApp.boot() after FloatingPanelController.shared.setup().

## Coverage
MCPSessionService: all 6 MCP session tools wrapped with proper error handling and response parsing. MCPStatusSync: start/stop lifecycle with Timer invalidation, 5-second interval, immediate first sync, weak references. Boot integration: MCPStatusSync.shared.start() in OrchestraApp.boot(). Backward compatibility maintained: SmartInputWindowManager.isTrayMode still set, old code references preserved until Feature 5 cleanup.


---
**in-docs -> documented** (2026-03-05T12:34:56Z):
## Summary
Documented the MCP session integration layer: MCPSessionService wraps 6 MCP session tools (list_sessions, create_session, send_message, get_session, pause_session, delete_session) via ToolService.call(). MCPStatusSync provides 5-second polling for session status persistence. Both files include inline documentation with MARK sections and method-level comments explaining the data flow from local ChatPlugin through MCP tools to the orchestrator.

## Location
- apps/swift/Shared/Sources/Shared/FloatingUI/MCPSessionService.swift (new — 170 lines, inline docs: MCPSession struct, 6 async methods with doc comments)
- apps/swift/Shared/Sources/Shared/FloatingUI/MCPStatusSync.swift (new — 58 lines, inline docs: start/stop lifecycle, polling interval, cross-reference logic)
- apps/swift/Apps/macOS/OrchestraApp.swift (updated — boot integration comments for MCPStatusSync.shared.start())


---
**Self-Review (documented -> in-review)** (2026-03-05T12:35:06Z):
## Summary
Feature 4 delivers the MCP session persistence layer for the floating UI. MCPSessionService (170 lines) wraps 6 MCP session tools via ToolService.call() — providing async methods for session CRUD that bridge local ChatPlugin sessions with the MCP orchestrator. MCPStatusSync (58 lines) runs a 5-second polling timer that refreshes session status from MCP and cross-references with local state. Boot integration in OrchestraApp.swift starts MCPStatusSync during app launch. Local JSON cache preserved for fast startup; MCP is the source of truth.

## Quality
Code follows established patterns: @MainActor singletons matching ChatPlugin/ToolService conventions, do/catch error handling with silent degradation when MCP unavailable, weak self in Timer callbacks to prevent retain cycles, proper async/await throughout. Response parsing handles both UUID and SES-XXXX session ID formats. Both swift build and xcodebuild pass with zero errors. No force-unwraps, no blocking calls on main thread.

## Checklist
- apps/swift/Shared/Sources/Shared/FloatingUI/MCPSessionService.swift (new — 6 async methods wrapping MCP tools, MCPSession struct, proper error handling)
- apps/swift/Shared/Sources/Shared/FloatingUI/MCPStatusSync.swift (new — Timer-based polling, weak self, start/stop lifecycle)
- apps/swift/Apps/macOS/OrchestraApp.swift (modified — MCPStatusSync.shared.start() in boot sequence)
- apps/swift/Orchestra.xcodeproj/project.pbxproj (modified — both files registered for OrchestraMac and OrchestraiOS targets)
- xcodebuild BUILD SUCCEEDED, swift build 0 errors, swift test 5/5 pass


---
**Review (needs-edits)** (2026-03-05T12:57:09Z): User requested: input bar must be at the bottom (was at top), and panel width was too narrow.


---
**in-progress -> ready-for-testing** (2026-03-05T12:58:05Z):
## Summary
Fixed three layout issues from user feedback: (1) moved compact input bar from top to bottom of mini panel, (2) increased panel size from 700x440 to 860x520 for wider content, (3) made TextField stretch full width with .frame(maxWidth: .infinity) and removed dead Spacer so the input extends across the entire bar between logo and send button.

## Changes
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift (VStack reordered: TabBar→Content→InputBar at bottom; TextField gets .frame(maxWidth: .infinity), removed Spacer(minLength:0) between TextField and sendButton)
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingUIStore.swift (miniPanelWidth 700→860, miniPanelTotalHeight 440→520)

## Verification
xcodebuild OrchestraMac: BUILD SUCCEEDED. Input bar now at bottom of mini panel, TextField stretches full width, panel is 860x520.


---
**in-testing -> ready-for-docs** (2026-03-05T12:59:23Z):
## Summary
Tested all MCP session integration plus layout corrections. MCPSessionService wraps 6 MCP tools with async/await, MCPStatusSync polls at 5s intervals. Layout fixes verified: input bar at bottom, full-width TextField in both FloatingMiniPanel and FloatingInputCard, panel 860x520.

## Results
swift test: 5/5 passed, 0 failures. xcodebuild OrchestraMac: BUILD SUCCEEDED. Both FloatingMiniPanel and FloatingInputCard now use .frame(maxWidth: .infinity) on their TextField — input stretches full width between logo and send button. No Spacer gap. MCPSessionService/MCPStatusSync compile with no warnings.

## Coverage
MCPSessionService: 6 async tool-call wrappers with error handling and response parsing. MCPStatusSync: Timer lifecycle with weak self, 5-second interval. FloatingMiniPanel: input bar at bottom, full-width TextField. FloatingInputCard: full-width TextField (same fix applied). FloatingUIStore: 860x520 panel size. Both xcodebuild and swift test pass.


---
**in-docs -> documented** (2026-03-05T13:02:44Z):
## Summary
Documented the MCP session persistence layer and all layout fixes. MCPSessionService bridges local ChatPlugin sessions to MCP orchestrator tools. MCPStatusSync provides 5-second polling. Input bar now at bottom with full-width TextField in both panel modes. All content views (Chat, Terminal, Search, Notes) have inline MARK section documentation.

## Location
- apps/swift/Shared/Sources/Shared/FloatingUI/MCPSessionService.swift (170 lines — inline MARK sections, method-level doc comments for 6 async methods and MCPSession struct)
- apps/swift/Shared/Sources/Shared/FloatingUI/MCPStatusSync.swift (58 lines — MARK sections for start/stop lifecycle, polling interval docs)
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift (updated layout: TabBar→Content→InputBar bottom, full-width TextField documented)
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingInputCard.swift (full-width TextField fix, MARK section docs)


---
**Self-Review (documented -> in-review)** (2026-03-05T13:02:58Z):
## Summary
Feature 4 delivers MCP session persistence plus layout fixes from user feedback. MCPSessionService (170 lines) wraps 6 MCP session tools via ToolService.call(). MCPStatusSync (58 lines) polls every 5 seconds. Layout fixes: input bar moved from top to bottom of mini panel, TextField now stretches full width with .frame(maxWidth: .infinity) in both FloatingMiniPanel and FloatingInputCard, panel dimensions increased to 860x520.

## Quality
All builds pass (swift test 5/5, xcodebuild BUILD SUCCEEDED). Layout is now: TabBar at top → Content area fills middle → Input bar at bottom. TextField extends full width between logo and send button — no dead space. MCPSessionService uses proper async/await with do/catch error handling and silent degradation. MCPStatusSync uses weak self in Timer callback to prevent retain cycles. No force-unwraps, no blocking main thread calls.

## Checklist
- apps/swift/Shared/Sources/Shared/FloatingUI/MCPSessionService.swift (new — 6 async methods, MCPSession struct, error handling)
- apps/swift/Shared/Sources/Shared/FloatingUI/MCPStatusSync.swift (new — Timer-based 5s polling, weak self, start/stop lifecycle)
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift (fixed — input bar moved to bottom, full-width TextField, removed dead Spacer)
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingInputCard.swift (fixed — full-width TextField, removed dead Spacer)
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingUIStore.swift (fixed — miniPanelWidth 700→860, miniPanelTotalHeight 440→520)
- apps/swift/Apps/macOS/OrchestraApp.swift (modified — MCPStatusSync.shared.start() in boot)
- apps/swift/Orchestra.xcodeproj/project.pbxproj (both new files registered for OrchestraMac and OrchestraiOS)


---
**Review (approved)** (2026-03-05T13:33:58Z): User approved with layout fixes: input at bottom, full-width TextField, 860x520 panel.
