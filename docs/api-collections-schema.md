# API Collections Schema

Database models for the API Collections feature — a Postman-like REST client built into Orchestra.

## Tables

### api_collections
Groups related API endpoints into a named collection.

| Column | Type | Description |
|--------|------|-------------|
| id | UUID (PK) | Auto-generated |
| user_id | uint | Owner |
| team_id | UUID | Optional team scope |
| name | string | Collection name |
| slug | string | URL-safe identifier |
| description | string | Description |
| base_url | string | Base URL for all endpoints |
| auth_type | string | none, bearer, basic, api_key, oauth2 |
| auth_config | JSONB | Auth configuration (token, credentials) |
| variables | JSONB | Collection-level variables |
| visibility | string | private, team, public |
| version | int | Optimistic concurrency |

### api_endpoints
Individual API requests within a collection.

| Column | Type | Description |
|--------|------|-------------|
| id | UUID (PK) | Auto-generated |
| collection_id | UUID (FK) | Parent collection |
| user_id | uint | Owner |
| name | string | Endpoint name |
| method | string | GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS |
| path | string | URL path (appended to base_url) |
| headers | JSONB | Request headers |
| query_params | JSONB | Query parameters |
| body | text | Request body content |
| body_type | string | none, json, form, xml, raw |
| description | string | Description |
| sort_order | int | Display order |
| folder_path | string | Virtual folder within collection |

### api_environments
Environment-specific variable sets for API collections.

| Column | Type | Description |
|--------|------|-------------|
| id | UUID (PK) | Auto-generated |
| collection_id | UUID (FK) | Parent collection |
| user_id | uint | Owner |
| name | string | Environment name (e.g., Production, Staging) |
| variables | JSONB | Key-value variable pairs |
| is_active | bool | Whether this environment is currently active |

## Files
- `apps/web/internal/models/api_collection.go` — GORM models
- `apps/web/internal/database/database.go` — AutoMigrate registration
