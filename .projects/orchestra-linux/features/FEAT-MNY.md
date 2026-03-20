---
id: FEAT-MNY
kind: feature
priority: P2
project_slug: orchestra-linux
status: backlog
title: Browser context bridge (Chrome extension WebSocket)
type: feature
---

# Browser context bridge (Chrome extension WebSocket)

Implement ai.browser-context tool integration via WebSocket server listening on localhost:8765. GLib.SocketService + Soup.WebsocketConnection to handle Chrome extension connection. Protocol: extension sends PageContent JSON (title, url, selectedText, mainContent, metaDescription, headings, language, isArticle). Store last received page context in AppState. Tools: get_page_content(), get_page_dom(), get_selected_text(), get_open_tabs(), get_page_screenshot(), navigate_to(), execute_script() — all route via WebSocket message to extension and await response with GLib timeout. Show connection status badge in chat input tray.