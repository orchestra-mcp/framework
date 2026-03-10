---
created_at: "2026-03-09T10:28:27Z"
description: The copilot must be aware of what page the user is on and reference it in messages. Use usePathname() to detect the current page, extract relevant IDs (project slug, feature ID, note ID) from the URL, and prepend context to messages sent to the AI. Also show context badge in ChatBox.
estimate: M
id: FEAT-LTZ
kind: feature
labels:
    - plan:PLAN-BSW
priority: P1
project_id: orchestra-web
status: todo
title: Inject current page context into copilot messages
updated_at: "2026-03-09T10:28:27Z"
version: 0
---

# Inject current page context into copilot messages

The copilot must be aware of what page the user is on and reference it in messages. Use usePathname() to detect the current page, extract relevant IDs (project slug, feature ID, note ID) from the URL, and prepend context to messages sent to the AI. Also show context badge in ChatBox.
