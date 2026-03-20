# PowerSync — Preview Sync Rules

Added sync rules for API Collections and Presentations to enable offline-first Flutter access.

## New Buckets

### user_api_collections
Syncs per-user API collections, endpoints, and environments.

| Table | Columns |
|-------|---------|
| api_collections | id, user_id, name, slug, description, base_url, auth_type, auth_config, variables, visibility, version |
| api_endpoints | id, collection_id, user_id, name, method, path, headers, query_params, body, body_type, description, sort_order, folder_path |
| api_environments | id, collection_id, user_id, name, variables, is_active |

### user_presentations
Syncs per-user presentations and slides.

| Table | Columns |
|-------|---------|
| presentations | id, user_id, title, slug, description, theme, visibility, slide_count, version |
| presentation_slides | id, presentation_id, user_id, slide_number, layout, title, content, notes, properties |

## CRUD Allowlist
All 5 tables added to `allowedTables` in `powersync_crud.go` — Flutter clients can write locally and batch-upload.

## Flutter Schema
Matching `Table()` definitions added to `schema.dart` with appropriate column types (text for JSONB, integer for booleans).

## Files
- `scripts/deploy/powersync/sync-rules.yaml` — Sync rule buckets
- `apps/web/internal/handlers/powersync_crud.go` — CRUD allowlist
- `apps/flutter/lib/core/powersync/schema.dart` — Client-side schema
