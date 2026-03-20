---
estimate: L
id: FEAT-VCW
kind: bug
priority: critical
project_slug: orchestra-agents
status: in-progress
title: Implement Go sync handlers: entity share, team updates check, team pull download
type: feature
---

# Implement Go sync handlers: entity share, team updates check, team pull download

Flutter TeamSyncService calls 3 endpoints that don't exist in Go backend: (1) POST /api/{entityType}/{entityId}/share — share entity with team members. (2) GET /api/team/updates — check for pending updates. (3) POST /api/team/pull — download pending updates. Implement in apps/web/internal/handlers/sync.go, services/sync_service.go. Use sync_log table.
