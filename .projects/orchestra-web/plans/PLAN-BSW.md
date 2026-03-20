---
id: PLAN-BSW
project_slug: orchestra-web
status: in-progress
title: Copilot Bubble — Full Feature Wiring & AI Awareness
type: plan
---

# Copilot Bubble — Full Feature Wiring & AI Awareness

Wire up all ChatBox capabilities that are currently unused in CopilotBubble, plus add new AI awareness features (screenshot, browser control, context awareness).

12 items from user:
1. Model switcher — wire onModelChange to actually switch the model used in send_message
2. Session search — already in ChatHeader dropdown, verify it works
3. / slash commands — wire commandItems with agents + skills from MCP
4. Loading/typing — show rotating status messages, not just fixed "Thinking..."
5. Tool events — parse and display tool call events in chat messages
6. Permission notifications — push permission requests to browser/chatbox
7. Session reconnection — fix session breaking on tool/command usage
8. @ file mentions — wire mentionItems with file search
9. Page context awareness — inject current page context into messages
10. Screenshot tool — auto-screenshot current tunnel page
11. Vision/image preview — screenshot + send as image to user
12. Browser awareness — Chrome extension for browser control + emulator screenshots