---
id: REQ-KQQ
kind: bug
priority: P0
project_slug: orchestra-agents
status: converted
title: Health data changes don't sync in realtime across all screens
type: request
---

# Health data changes don't sync in realtime across all screens

When updating health data (hydration, nutrition, caffeine, daily flow, weight, sleep) on one screen, the changes don't propagate in realtime to other screens/widgets. For example: logging water on the Hydration tab doesn't update the hydration widget card on the Dashboard, the Health Score ring, or the Daily Flow component breakdown. All health data consumers need to reactively watch the same provider state so changes sync instantly across the dashboard widget cards, health score calculations, daily flow components, and any other screen displaying that data.
