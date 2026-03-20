# Sync API Endpoints

PostgreSQL-backed sync endpoints for push/pull/delta synchronization across devices and teams.

## Overview

All endpoints are under `/api/sync` and require JWT authentication.

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/sync/devices/register` | Register a device for sync tracking |
| POST | `/api/sync/push` | Push local changes to server (with idempotency) |
| GET | `/api/sync/pull` | Pull changes since a given timestamp |
| GET | `/api/sync/delta` | Get changed entity IDs since a timestamp |
| GET | `/api/sync/export` | Bulk export all user/team data |
| GET | `/api/sync/status` | Sync status and pending count for a device |
| POST | `/api/sync/share` | Share an entity with a team |
| GET | `/api/sync/team-updates` | List recent team-authored changes |
| GET | `/api/sync/share/:entityType/:entityId` | Get shares for an entity |
| DELETE | `/api/sync/share/:shareId` | Revoke a share |

## Delta Endpoint

**GET `/api/sync/delta`**

Returns a lightweight list of changed entity IDs and actions since a given timestamp. Use this for efficient change detection before fetching full payloads via Pull or Export.

### Query Parameters

| Param | Required | Description |
|-------|----------|-------------|
| `since` | Yes | RFC3339 timestamp — return changes after this time |
| `entity_type` | No | Filter to a specific entity type (e.g., `feature`, `note`) |
| `limit` | No | Max results (default: 1000) |

### Response

```json
{
  "changes": [
    {
      "entity_type": "feature",
      "entity_id": "FEAT-ABC",
      "action": "upsert",
      "version": 5,
      "changed_at": "2026-03-20T10:00:00Z"
    },
    {
      "entity_type": "plan",
      "entity_id": "PLAN-XYZ",
      "action": "delete",
      "version": 2,
      "changed_at": "2026-03-20T10:01:00Z"
    }
  ],
  "count": 2,
  "since": "2026-03-20T09:00:00Z"
}
```

### Team Scoping

Results include changes from all teams the user belongs to. Ordered by `changed_at` ascending for deterministic cursor-based pagination.

## Push Endpoint

**POST `/api/sync/push`**

Accepts a batch of records. Each record is written to `sync_log` then applied via LWW (Last-Write-Wins) upsert. Idempotency keys prevent duplicate processing.

```json
{
  "device_id": "device-abc",
  "records": [
    {
      "entity_type": "feature",
      "entity_id": "FEAT-001",
      "action": "upsert",
      "payload": { "title": "My Feature", "status": "in-progress" },
      "version": 3,
      "idempotency_key": "unique-key-123",
      "team_id": "team-xyz"
    }
  ]
}
```

## Pull Endpoint

**GET `/api/sync/pull?since=<RFC3339>&device_id=<id>&limit=<n>`**

Returns full `SyncLog` records (including payload) since the given timestamp. Excludes records originating from the requesting device. Includes team-shared changes.

## Syncable Entity Types

`project`, `feature`, `plan`, `note`, `doc`, `skill`, `agent`, `hook`, `person`, `delegation`, `workflow`, `request`

## Storage

All sync operations write to the `sync_logs` PostgreSQL table:

| Column | Type | Notes |
|--------|------|-------|
| id | UUID | Auto-generated |
| user_id | INTEGER | Author |
| device_id | VARCHAR | Source device |
| entity_type | VARCHAR | Entity kind |
| entity_id | VARCHAR | Entity identifier |
| action | VARCHAR | `upsert` or `delete` |
| payload | JSONB | Full entity data |
| version | BIGINT | LWW version counter |
| idempotency_key | VARCHAR | Conditional unique index |
| team_id | UUID | Optional team scoping |
| tunnel_id | UUID | Optional tunnel routing |
| created_at | TIMESTAMPTZ | Server timestamp |

## Files

| File | Purpose |
|------|---------|
| `apps/web/internal/handlers/sync.go` | All sync handler methods |
| `apps/web/internal/models/sync_log.go` | SyncLog GORM model |
| `apps/web/internal/services/sync_service.go` | LWW apply logic |
| `apps/web/internal/routes/routes.go` | Route registration |
