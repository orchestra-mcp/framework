---
id: REQ-EDM
kind: feature
priority: P0
project_slug: orchestra-agents
status: pending
title: Smart Action streaming UX + real notification system
type: request
---

# Smart Action streaming UX + real notification system

Two parts:

1. **Smart Action streaming UX**: Replace poll-and-wait with real-time streaming. Use the bridge's event channel (ChatEvent stream) to show AI output live under the input box as markdown renders progressively. When generation completes, populate the editor with the full content. Show a stream panel with live text appearing, not a spinner. Use hooks on the MCP event stream.

2. **Real notification system on desktop/mobile**: Replace mock notification data with actual notifications. Desktop: use flutter_local_notifications for native macOS/iOS notifications. Wire into MCP event stream for: smart action completion, sync events, agent permission requests, badge awards. Mobile: FCM already set up (FEAT-FYJ) but needs wiring to real backend events. Remove all seed/mock notification data.
