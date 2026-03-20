---
id: REQ-JLU
kind: bug
priority: P1
project_slug: orchestra-agents
status: converted
title: Sleep tab not showing real HealthKit sleep data
type: request
---

# Sleep tab not showing real HealthKit sleep data

The sleep tab still shows mock/empty data instead of real HealthKit sleep data. Needs the same treatment as the Vitals tab — wire to HealthService.getSleepHours().
