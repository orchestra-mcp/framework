---
estimate: M
id: FEAT-EEH
kind: bug
priority: high
project_slug: orchestra-agents
status: todo
title: Health data in-memory delta application in SyncEngine
type: feature
---

# Health data in-memory delta application in SyncEngine

Extend SyncEngine._applyDeltas() for health tables: water_logs, caffeine_logs, meal_logs, pomodoro_sessions, sleep_configs, health_snapshots, health_profiles, sleep_logs. Create HealthRepository.applyDeltas(). Invalidate health Riverpod providers on delta arrival.
