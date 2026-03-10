---
created_at: "2026-03-09T10:28:27Z"
description: Currently setTypingStatus is hardcoded to 'Thinking...'. Use the LOADING_MESSAGES array already defined in CopilotBubble to rotate status messages during sending. Implement a timer that cycles through messages every 4-5 seconds.
estimate: S
id: FEAT-CDL
kind: bug
labels:
    - plan:PLAN-BSW
priority: P1
project_id: orchestra-web
status: todo
title: Fix typing indicator to show rotating loading messages
updated_at: "2026-03-09T10:28:27Z"
version: 0
---

# Fix typing indicator to show rotating loading messages

Currently setTypingStatus is hardcoded to 'Thinking...'. Use the LOADING_MESSAGES array already defined in CopilotBubble to rotate status messages during sending. Implement a timer that cycles through messages every 4-5 seconds.
