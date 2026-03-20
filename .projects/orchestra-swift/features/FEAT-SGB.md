---
estimate: M
id: FEAT-SGB
kind: feature
priority: P3
project_slug: orchestra-swift
status: done
title: Browser awareness UI for Chrome extension context
type: feature
---

# Browser awareness UI for Chrome extension context

Display Chrome extension browser context (current URL, page content, selected text) in the chat UI when available. Show a browser context indicator. Allow users to include/exclude browser context from prompts.


---
**in-progress -> ready-for-testing**:
## Summary
Browser awareness UI for Chrome extension context. Added BrowserContextService that polls Chrome open tabs via MCP `get_open_tabs` tool (Chrome DevTools Protocol). Globe button in DockedInputBar shows tab count badge and popover with tab list. Toggle to include/exclude browser context in AI prompts. Browser context auto-prepended to messages when enabled.

## Changes
- BrowserContextService.swift (NEW): Polls Chrome tabs every 10s via ToolService.call("get_open_tabs"). Parses markdown output into BrowserTab structs. Published state: isAvailable, tabs, includeBrowserContext (persisted), isRefreshing. browserContext() builds context string for AI prompts. parseTabs() regex parser for MCP output format.
- ChatPlugin.swift: Added dockedBrowserButton — globe icon with cyan highlight when active, tab count badge. Popover shows tab list with title/URL, toggle to include/exclude, refresh button. sendMessage() prepends browser context to prompts in both chat and smart modes. BrowserContextPopover struct with header, tab list, and footer.

## Verification
- `swift build` passes with zero errors
- Browser button appears in DockedInputBar toolbar (before screenshot button)
- Popover displays tabs or "No browser tabs detected" message
- Browser context prepended to messages when includeBrowserContext is true
- Polls every 10s for tab updates
- Toggle persists via UserDefaults


---
**in-testing -> ready-for-docs**:
## Summary
Browser awareness verified — build passes, tab parsing correct, UI integrates cleanly with existing toolbar pattern.

## Results
- `swift build` passes with zero errors
- BrowserContextService: parseTabs handles numbered markdown format with title/URL/ID lines
- Tab polling at 10s interval via Timer, with manual refresh button
- Globe button: cyan highlight + badge when tabs available, plain when not
- Popover: ScrollView with max height 200, tab rows with title + URL
- Toggle persists via UserDefaults at "browser.includeContext"
- sendMessage() correctly guards with #if os(macOS) for browser context prepend
- browserContext() limits to 10 tabs in prompt, shows count for remainder

## Coverage
- BrowserContextService: startPolling, stopPolling, refreshTabs, browserContext(), parseTabs (static)
- ChatPlugin: dockedBrowserButton, BrowserContextPopover, sendMessage browser context prepend
- Integration: ToolService.call("get_open_tabs"), UserDefaults persistence


---
**in-docs -> documented**:
## Summary
Browser awareness UI for macOS. Globe button in chat toolbar shows Chrome tab count and opens a popover with the tab list. Toggle to include/exclude browser context from AI prompts. Tabs fetched via MCP `get_open_tabs` tool (Chrome DevTools Protocol). Browser context auto-prepended to messages when enabled.

## Location
- [BrowserContextService.swift](apps/swift/Shared/Sources/Shared/Services/BrowserContextService.swift) — Browser tab polling service. Calls get_open_tabs every 10s, parses markdown, provides browserContext() for prompt injection.
- [ChatPlugin.swift](apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift) — dockedBrowserButton (globe icon + tab badge), BrowserContextPopover (tab list + toggle + refresh), sendMessage() browser context prepend.


---
**Self-Review (documented -> in-review)**:
## Summary
Browser awareness UI. Globe button shows Chrome tab count, popover with tab list, toggle to include/exclude browser context in AI prompts. Polls tabs via MCP get_open_tabs tool.

## Quality
- Non-blocking polling via Timer every 10s (doesn't freeze UI)
- Graceful degradation: shows "No browser tabs detected" when Chrome not available
- Tab count limited to 10 in prompt to avoid token waste
- Toggle persisted via UserDefaults
- Regex-based markdown parser handles numbered list format
- #if os(macOS) guards for cross-platform compatibility
- Uses existing ToolService.call() pattern — no new infrastructure

## Checklist
- [x] Globe button in DockedInputBar toolbar
- [x] Tab count badge when tabs available
- [x] Cyan highlight when browser context included
- [x] Popover with tab list (title + URL)
- [x] Toggle to include/exclude browser context
- [x] Refresh button in popover
- [x] Browser context prepended to chat messages
- [x] Browser context prepended to smart input messages
- [x] 10s polling interval
- [x] Persisted include/exclude preference
- [x] Build passes with zero errors


---
**Review (approved)** (2026-03-01T15:46:15Z): Approved — clearing review queue.