---
estimate: L
id: FEAT-FNS
kind: feature
priority: P2
project_slug: orchestra-web
status: todo
title: Push permission requests to browser notifications and chatbox
type: feature
---

# Push permission requests to browser notifications and chatbox

When the AI session needs permission approval (pending_permission), push a browser Notification and show an inline permission card in the chatbox. Poll get_pending_permission periodically or use the event stream. The ChatBox already has a QuestionEvent type for inline prompts.