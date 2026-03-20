---
estimate: M
id: FEAT-AAM
kind: feature
priority: P2
project_slug: orchestra-web
status: todo
title: Wire @ file mentions with backend search
type: feature
---

# Wire @ file mentions with backend search

ChatBox has mentionItems prop and useMentionSearch hook that POSTs to /api/search/mentions. Wire mentionItems with file/task/session groups. Either implement the /api/search/mentions endpoint or provide static items from MCP tools.