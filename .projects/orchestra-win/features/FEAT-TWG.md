---
id: FEAT-TWG
kind: feature
priority: P2
project_slug: orchestra-win
status: backlog
title: Browser context plugin — Chrome extension WebSocket bridge
type: feature
---

# Browser context plugin — Chrome extension WebSocket bridge

Implement `Orchestra.Desktop/Services/BrowserContextService.cs` — real-time page content from Chrome/Edge via the Orchestra Chrome extension WebSocket bridge.

**Architecture:**
```
Chrome Extension (content script)
    ↕ chrome.runtime.sendMessage
Chrome Extension (background service worker)
    ↕ WebSocket ws://localhost:7891
BrowserContextService.cs
    ↕ MCP tool call
ai.browser-context plugin (Go)
```

**`BrowserContextService` (ai.browser-context — 7 tools):**
- `get_page_content` — current tab: title, URL, full text content
- `get_page_dom` — serialized DOM structure (simplified, no scripts)
- `get_selected_text` — text highlighted by user in browser
- `get_open_tabs` — list all open tabs (title, URL, active)
- `get_page_screenshot` — screenshot of current tab via `chrome.tabs.captureVisibleTab`
- `navigate_to` — `chrome.tabs.update({url})` to navigate active tab
- `execute_script` — run JS in page context via `chrome.scripting.executeScript`

**`BrowserContextService.cs`:** hosts a `WebSocket` server on `ws://localhost:7891`, accepts extension connection. Registers as named pipe alternative for Edge/Chrome native messaging if needed.

**Status indicator:** green "Browser Connected" badge in chat toolbar when extension is active

**Platform:** Desktop only (requires Chrome/Edge browser + extension)