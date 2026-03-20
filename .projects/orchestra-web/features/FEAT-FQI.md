---
estimate: S
id: FEAT-FQI
kind: feature
priority: P1
project_slug: orchestra-web
status: todo
title: Wire model switcher to actually change session model
type: feature
---

# Wire model switcher to actually change session model

ChatBox has models/selectedModelId/onModelChange props but the model selection doesn't propagate to send_message. Wire onModelChange to store, and pass selectedModelId when creating sessions or sending messages.