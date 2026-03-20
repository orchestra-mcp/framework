# SharedContent Extensions

Added 3 columns to the `shared_content` model to support Orchestra Preview.

## New Columns

| Column | Type | Description |
|--------|------|-------------|
| entity_id | string | UUID linking to the source entity (api_collection, presentation, doc) |
| unique_views | int | Count of unique visitors (deduplicated) |
| custom_domain | string | Custom domain for public sharing (future) |

## Extended Entity Types

Previously: `note`, `skill`, `agent`, `workflow`, `prompt`

Now also: `api_collection`, `presentation`, `doc`

## File
- `apps/web/internal/models/shared_content.go`
