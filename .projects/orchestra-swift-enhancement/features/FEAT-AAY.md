---
estimate: M
id: FEAT-AAY
kind: feature
priority: P1
project_slug: orchestra-swift-enhancement
status: backlog
title: CMD+F Search Within Current Session Messages
type: feature
---

# CMD+F Search Within Current Session Messages

## Problem
CMD+F does not search through the current session's messages. There is no in-session search.

## Current State
- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift` — no search functionality for messages
- CMD+F may be captured by the sidebar search (`.orchestraShowSearch` notification)

## Requirements
1. CMD+F opens a search bar at the top of the chat area (not sidebar)
2. Search through all messages in current session (user + assistant)
3. Highlight matching text in messages with yellow background
4. Up/down arrows to navigate between matches
5. Match count display: '3 of 12 matches'
6. Search is case-insensitive by default, with case-sensitive toggle
7. Regex search toggle for advanced users
8. ESC to close search bar
9. Search should include tool call content if expanded

## Affected Files
- `apps/swift/Shared/Sources/Shared/Plugins/ChatPlugin/ChatPlugin.swift`
- NEW: `apps/swift/Shared/Sources/Shared/Components/SessionSearchBar.swift`