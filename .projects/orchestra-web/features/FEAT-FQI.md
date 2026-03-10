---
created_at: "2026-03-09T10:28:27Z"
description: ChatBox has models/selectedModelId/onModelChange props but the model selection doesn't propagate to send_message. Wire onModelChange to store, and pass selectedModelId when creating sessions or sending messages.
estimate: S
id: FEAT-FQI
kind: feature
labels:
    - plan:PLAN-BSW
priority: P1
project_id: orchestra-web
status: todo
title: Wire model switcher to actually change session model
updated_at: "2026-03-09T10:28:27Z"
version: 0
---

# Wire model switcher to actually change session model

ChatBox has models/selectedModelId/onModelChange props but the model selection doesn't propagate to send_message. Wire onModelChange to store, and pass selectedModelId when creating sessions or sending messages.
