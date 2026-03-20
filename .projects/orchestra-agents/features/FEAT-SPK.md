---
estimate: S
id: FEAT-SPK
kind: feature
priority: medium
project_slug: orchestra-agents
status: todo
title: Sync recovery: reset endpoint and status indicator
type: feature
---

# Sync recovery: reset endpoint and status indicator

POST /api/sync/reset — hard reset sync state for device. GET /api/sync/status — return last sync time, pending changes, conflicts per device. Flutter UI: sync status indicator on settings, manual reset button.
