---
id: REQ-JZR
kind: feature
priority: P1
project_slug: orchestra-agents
status: pending
title: Desktop Vitals tab — fetch real data from API synced from mobile app
type: request
---

# Desktop Vitals tab — fetch real data from API synced from mobile app

The Vitals tab on the desktop app currently shows placeholder/hardcoded data. It needs to pull real vitals data (steps, heart rate, energy, weight, body fat, metabolic age, visceral fat, body water) from the API, which will be synced from the mobile app's HealthKit/Google Fit integration. Requires: API client methods for vitals endpoints, provider that watches the synced data, and wiring the VitalsTab to display live values instead of placeholders.
