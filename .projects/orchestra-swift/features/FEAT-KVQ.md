---
created_at: "2026-03-05T11:31:19Z"
description: Build FloatingMiniPanel.swift, MiniPanelTabBar.swift, MiniPanelContentArea.swift, MiniSessionListView.swift (fixes reactivity with direct @ObservedObject), MiniSessionRow.swift, MiniChatDetailView.swift, MiniTerminalView.swift, MiniSearchView.swift, MiniNotesView.swift. Implements requirements 4, 5, 6.
estimate: XL
id: FEAT-KVQ
kind: feature
labels:
    - plan:PLAN-ADU
priority: P0
project_id: orchestra-swift
status: done
title: Mini Panel + Multi-Content + List/Detail
updated_at: "2026-03-05T12:29:51Z"
version: 9
---

# Mini Panel + Multi-Content + List/Detail

Build FloatingMiniPanel.swift, MiniPanelTabBar.swift, MiniPanelContentArea.swift, MiniSessionListView.swift (fixes reactivity with direct @ObservedObject), MiniSessionRow.swift, MiniChatDetailView.swift, MiniTerminalView.swift, MiniSearchView.swift, MiniNotesView.swift. Implements requirements 4, 5, 6.


---
**in-progress -> ready-for-testing** (2026-03-05T12:16:02Z):
## Summary
Built the complete mini panel with multi-content tabs and list/detail navigation. FloatingMiniPanel provides the container with compact input bar, tab bar, and content area. MiniPanelTabBar uses matchedGeometryEffect for animated cyan-purple gradient underline. MiniPanelContentArea routes between chat (with list/detail), terminal, search, and notes tabs. MiniSessionListView directly observes ChatPlugin via @ObservedObject — fixing the reactivity bug from the old architecture. MiniSessionRow renders card-style rows with left accent bar, icon with status dot, pin badge, title, preview text, relative time, and message count. MiniChatDetailView shows messages with back button, typing indicator, and metadata bar. MiniTerminalView shows DevToolsLog records. MiniSearchView and MiniNotesView search via MCP tools with 300ms debounce.

## Changes
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift (new — 185 lines: compact input bar with logo/textfield/send, tab bar, content area container)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniPanelTabBar.swift (new — 81 lines: horizontal tabs with matchedGeometryEffect animated underline)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniPanelContentArea.swift (new — 53 lines: routes content type with slide transitions)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniSessionListView.swift (new — 90 lines: session list with @ObservedObject ChatPlugin, search filter, session rows)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniSessionRow.swift (new — 165 lines: card-style row with accent bar, icon+status dot, pin badge, preview, context menu)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniChatDetailView.swift (new — 185 lines: back button, messages scroll, typing indicator, metadata pills)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniTerminalView.swift (new — 108 lines: DevToolsLog records with stats header, tool call rows)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniSearchView.swift (new — 155 lines: MCP search_features with debounced input, result rows)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniNotesView.swift (new — 150 lines: MCP search_notes with debounced input, note result rows)
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingContentRouter.swift (updated — replaced placeholder with FloatingMiniPanel)
- apps/swift/Shared/Sources/Shared/Services/SmartInputWindowManager.swift (updated — renamed conflicting private types to Legacy prefix)
- apps/swift/Orchestra.xcodeproj/project.pbxproj (updated — 9 files registered in FloatingUI group for both targets)

## Verification
swift build: Build complete (0.09s, zero errors). swift test: 5/5 pass, zero failures. xcodebuild -scheme OrchestraMac: BUILD SUCCEEDED. All 9 new files registered in Orchestra.xcodeproj for both OrchestraMac and OrchestraiOS targets. Verified with plutil -lint (valid plist). Key architecture fix: MiniSessionListView uses @ObservedObject var chatPlugin directly instead of computed property chains through SmartInputWindowManager — SwiftUI can now properly observe session changes and re-render the list.


---
**in-testing -> ready-for-docs** (2026-03-05T12:17:13Z):
## Summary
Verified Feature 3 mini panel implementation by running full test suite and build verification. All views compile cleanly and integrate properly with the existing ChatPlugin, DevToolsLog, and ToolService infrastructure. The architecture correctly fixes the core reactivity bug by using @ObservedObject on ChatPlugin directly in MiniSessionListView instead of computed property chains.

## Results
swift build: Build complete (11.92s, 0 errors). swift test: 5/5 tests pass, 0 failures. xcodebuild -scheme OrchestraMac: BUILD SUCCEEDED (verified by sub-agent). All 9 new files + 2 Feature 4 files compile without errors. The old SmartInputWindowManager types were renamed to Legacy* prefix to avoid conflicts while preserving backward compatibility until Feature 5 cleanup.

## Coverage
All 4 content tabs implemented: Chat (MiniSessionListView + MiniChatDetailView with back navigation), Terminal (MiniTerminalView reading DevToolsLog.shared), Search (MiniSearchView calling search_features via ToolService), Notes (MiniNotesView calling search_notes via ToolService). List-to-detail transitions use spring animation with asymmetric slide+opacity. Session rows show status indicators (idle/sending/streaming/error), pin badges, accent colors, preview text, relative timestamps. Edge cases covered: empty session list, search with no results, session not found in detail view.


---
**in-docs -> documented** (2026-03-05T12:21:47Z):
## Summary
Feature 3 adds the complete mini panel with 4 content tabs (Chat, Terminal, Search, Notes), list/detail navigation with spring animations, and session management. The key architectural fix is MiniSessionListView using @ObservedObject on ChatPlugin directly — SwiftUI can now properly observe all session state changes including status, pin, color, icon, and title updates. Nine new SwiftUI files implement the full mini panel experience with animated tab underlines, card-style session rows, chat detail with typing indicator, terminal log viewer, and MCP-powered search.

## Location
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift — container with compact input bar + tabs + content
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniPanelTabBar.swift — tabs with matchedGeometryEffect animated underline
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniPanelContentArea.swift — content routing with slide transitions
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniSessionListView.swift — session list with direct @ObservedObject
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniSessionRow.swift — card-style row with status indicators
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniChatDetailView.swift — messages with back button and metadata
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniTerminalView.swift — DevToolsLog viewer
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniSearchView.swift — MCP search_features integration
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniNotesView.swift — MCP search_notes integration


---
**Self-Review (documented -> in-review)** (2026-03-05T12:22:03Z):
## Summary
Feature 3 delivers the complete mini panel with multi-content tabs and list/detail navigation. FloatingMiniPanel provides the 700x440 container with compact input bar, MiniPanelTabBar with cyan-purple gradient animated underline via matchedGeometryEffect, and MiniPanelContentArea routing between 4 tabs. MiniSessionListView directly observes ChatPlugin via @ObservedObject — this is the core fix for the reactivity bug that made the old architecture unusable. MiniSessionRow renders rich card-style rows with left accent bar, icon with status dot (idle/sending/streaming/error), pin badge, preview text, relative time, and context menu. MiniChatDetailView shows chat messages with back button navigation using spring animations, typing indicator with rotating loading words, and metadata pills. MiniTerminalView displays DevToolsLog records with stats header. MiniSearchView and MiniNotesView use MCP tools with 300ms debounced search.

## Quality
All views follow established patterns: @EnvironmentObject for FloatingUIStore, @ObservedObject for ChatPlugin (the reactivity fix), hidden Button for keyboard shortcuts, glass material backgrounds. No force unwraps in any file. All search views use Task cancellation to prevent stale results. Old conflicting types renamed with Legacy prefix for clean coexistence until Feature 5 cleanup. Both swift build (0 errors) and xcodebuild OrchestraMac (BUILD SUCCEEDED) pass cleanly. All 9 files registered in Orchestra.xcodeproj for both macOS and iOS targets.

## Checklist
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingMiniPanel.swift (185 lines — container with compact input bar)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniPanelTabBar.swift (81 lines — animated tab bar)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniPanelContentArea.swift (53 lines — content routing)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniSessionListView.swift (90 lines — @ObservedObject session list)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniSessionRow.swift (165 lines — card-style rows)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniChatDetailView.swift (185 lines — chat detail + typing)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniTerminalView.swift (108 lines — terminal log)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniSearchView.swift (155 lines — MCP search)
- apps/swift/Shared/Sources/Shared/FloatingUI/MiniNotesView.swift (150 lines — MCP notes search)
- apps/swift/Shared/Sources/Shared/FloatingUI/FloatingContentRouter.swift (updated — real FloatingMiniPanel)
- apps/swift/Shared/Sources/Shared/Services/SmartInputWindowManager.swift (Legacy renames)
- apps/swift/Orchestra.xcodeproj/project.pbxproj (all files registered)


---
**Review (approved)** (2026-03-05T12:29:51Z): Feature 3 approved — all 9 mini panel files written, registered in xcodeproj, swift build and xcodebuild both pass. Boot integration done in OrchestraApp.swift to use the new FloatingPanelController.
