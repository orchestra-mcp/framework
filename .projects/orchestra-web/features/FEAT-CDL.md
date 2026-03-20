---
estimate: S
id: FEAT-CDL
kind: bug
priority: P1
project_slug: orchestra-web
status: todo
title: Fix typing indicator to show rotating loading messages
type: feature
---

# Fix typing indicator to show rotating loading messages

Currently setTypingStatus is hardcoded to 'Thinking...'. Use the LOADING_MESSAGES array already defined in CopilotBubble to rotate status messages during sending. Implement a timer that cycles through messages every 4-5 seconds.