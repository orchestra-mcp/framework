---
estimate: M
id: FEAT-LTZ
kind: feature
priority: P1
project_slug: orchestra-web
status: todo
title: Inject current page context into copilot messages
type: feature
---

# Inject current page context into copilot messages

The copilot must be aware of what page the user is on and reference it in messages. Use usePathname() to detect the current page, extract relevant IDs (project slug, feature ID, note ID) from the URL, and prepend context to messages sent to the AI. Also show context badge in ChatBox.