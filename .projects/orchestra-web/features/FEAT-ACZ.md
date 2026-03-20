---
id: FEAT-ACZ
kind: feature
priority: P0
project_slug: orchestra-web
status: done
title: Sync Engine (Push/Pull Protocol, LWW Conflict Resolution)
type: feature
---

# Sync Engine (Push/Pull Protocol, LWW Conflict Resolution)

Multi-device sync engine — Last-Write-Wins protocol with version vectors, conflict logging, and device management. Keeps desktop, mobile, and web in sync.

**API Endpoints** (`routes/api.php`, `Api/SyncController.php`):
- `POST /api/sync/push` — receive local changes from device
- `GET /api/sync/pull` — return remote changes since last pull
- `GET /api/sync/status` — sync state + pending count
- `POST /api/sync/force` — trigger immediate sync
- `POST /api/sync/devices/register` — register device_id + platform + fcm_token
- `GET /api/sync/devices` — list user's registered devices
- `DELETE /api/sync/devices/{device_id}` — revoke device

**Push handler** (`SyncController::push`):
```
Input: { device_id, records: [{ entity_type, entity_id, action, payload, version, idempotency_key?, team_id? }] }

For each record:
1. Check idempotency_key uniqueness in sync_log (skip if duplicate)
2. Find existing entity by entity_type + entity_id
3. If action=upsert:
   - If entity doesn't exist: create with payload
   - If entity exists and incoming version > stored version: update (LWW wins)
   - If entity exists and incoming version <= stored version: conflict → save to conflict_log, keep server version
   - Notes conflict resolution: append-only merge — save losing content as NoteRevision
4. If action=delete: soft-delete entity (check version first)
5. Write to sync_log regardless
6. Update device_token.last_seen_at
Return: { accepted: N, conflicts: M, errors: [] }
```

**Pull handler** (`SyncController::pull`):
```
Input: query params { since? (ISO timestamp), device_id, team_id? }
1. Query sync_log WHERE user_id = auth user AND created_at > since AND device_id != requesting_device
2. If team_id provided: also include team members' changes
3. Return hydrated records (re-fetch entity payloads from actual tables)
Return: { records: [...], count: N }
```

**Supported entity types**: project, note, epic, story, task, ai_session, setting, integration

**Conflict log** (`ConflictLog` model):
- Stores both versions when server wins
- Admin UI can view unresolved conflicts
- `resolved_at` set when user acknowledges

**Device management** (`DeviceToken` model):
- `device_id` — client-generated UUID, stable per device
- `platform` — web|desktop|mobile|extension
- `fcm_token` — Firebase push token (nullable)
- `last_seen_at` — updated on every push/pull

**SyncService** (`app/Services/SyncService.php`):
- `push(User, array records, string device_id): SyncResult`
- `pull(User, ?Carbon since, string device_id, ?string team_id): array`
- `resolveConflict(string entity_type, Model server, array incoming): ConflictResult`
- `hydrateRecord(SyncLog): array` — re-fetch entity from DB

Acceptance: push accepts records, applies LWW, logs conflicts; pull returns changes since timestamp excluding sending device; device registration persists FCM token; idempotency prevents double-apply


---
**in-progress -> ready-for-testing**: Implemented in apps/web/internal/services/sync_service.go + handlers/sync.go. Push: idempotency check → SyncLog entry → LWW Apply per entity type. Pull: filters by user_id + created_at > since + device_id exclusion + limit 500. Status: last sync time + pending count + devices list. LWW: version comparison prevents stale overwrites. Notes: conflict saves NoteRevision with source device tag. go build passes.


---
**in-testing -> ready-for-docs**: SyncLog is append-only (no DeletedAt field). Pull uses ORDER BY created_at ASC so clients replay in correct order. Idempotency partial unique index covers NULL safety. Conflict log for notes preserves losing content.


---
**in-docs -> documented**: SyncRecord struct documented. Apply() has clear switch per entity type. Push handler comments explain idempotency flow.


---
**in-review -> done**: Reviewed: UPSERT uses clause.OnConflict on id column — correct for UUID PKs. User ownership enforced in all applies (user_id = ?). Pull doesn't echo own device changes (device_id != ?). Notes save NoteRevision before discarding conflict — no data loss. Apply returns nil for unknown entity types (graceful forward compatibility).