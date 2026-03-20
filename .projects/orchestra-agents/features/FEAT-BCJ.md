---
estimate: M
id: FEAT-BCJ
kind: bug
priority: high
project_slug: orchestra-agents
status: todo
title: Health data in-memory delta application in SyncEngine
type: feature
---

# Health data in-memory delta application in SyncEngine

Extend SyncEngine._applyDeltas() specifically for health tables: water_logs, caffeine_logs, meal_logs, pomodoro_sessions, sleep_configs, health_snapshots, health_profiles, sleep_logs. Create HealthRepository with applyDeltas() method. Invalidate health Riverpod providers when deltas arrive so health tabs update in real-time across devices. Test: change health data on device A, verify device B updates without manual refresh.
