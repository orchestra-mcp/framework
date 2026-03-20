---
estimate: M
id: FEAT-SZA
kind: feature
priority: P1
project_slug: orchestra-agents
status: todo
title: Sync conflict resolution (last-write-wins with version vectors)
type: feature
---

# Sync conflict resolution (last-write-wins with version vectors)

Implement conflict detection and resolution in the sync engine. Each entity has a version counter incremented on every write. On push, server compares client version with stored version. If client version < server version, conflict detected. Resolution strategy: last-write-wins based on updated_at timestamp. Conflicts logged to conflict_log table for audit. Client receives resolved state on next pull.