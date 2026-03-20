# Admin Settings & Content API

All endpoints require `Authorization: Bearer <jwt>` with `role == "admin"`. Non-admin users receive **403 Forbidden**.

## Settings

System settings use a composite key of `(key, locale)` with default locale `"en"`.

### GET /api/admin/settings

List all settings with optional `?search=` filter (ILIKE on key or value).

Response: `{ "settings": [{ key, value, locale, updated_at }] }`

### PUT /api/admin/settings

Upsert a setting. Creates if not found, updates if exists.

Body: `{ "key": "site_name", "value": "Orchestra", "locale": "en" }`

Response: `{ "setting": { key, value, locale, updated_at } }`

### GET /api/admin/settings/:key

Get a single setting by key. Accepts optional `?locale=` (default `"en"`).

Response: `{ "setting": { key, value, locale, updated_at } }`

### PATCH /api/admin/settings/:key

Partial update — only `value` and/or `locale` fields.

Body: `{ "value": "New Value" }`

### DELETE /api/admin/settings/:key

Delete a setting by key and optional `?locale=` (default `"en"`). Returns **204 No Content**.

## Pages

### GET /api/admin/pages

List all pages with optional `?search=` (ILIKE on title or slug) and `?limit=`/`?offset=` pagination.

Response: `{ "pages": [{ id, title, slug, body, status, author_id, created_at, updated_at }] }`

### GET /api/admin/pages/:id

Single page by ID.

Response: `{ "page": { id, title, slug, body, status, author_id, created_at, updated_at } }`

### POST /api/admin/pages

Create a page. Auto-generates slug from title if not provided. Sets `author_id` from JWT.

Body: `{ "title": "About Us", "body": "<p>...</p>", "status": "draft", "slug": "about-us" }`

Returns **201** with `{ "page": { ... } }`.

### PUT /api/admin/pages/:id

Full update — all fields optional: title, slug, body, status.

### DELETE /api/admin/pages/:id

Soft-deletes the page (sets `deleted_at`). Returns **204 No Content**.

## Categories

### GET /api/admin/categories

List categories with optional `?search=` (ILIKE on name), `?type=` filter, and `?limit=`/`?offset=` pagination.

Response: `{ "categories": [{ id, name, slug, type, description, parent_id, sort_order, created_at, updated_at }] }`

### POST /api/admin/categories

Create a category. Auto-generates slug from name if not provided.

Body: `{ "name": "Tutorials", "type": "blog", "description": "...", "parent_id": null, "sort_order": 0 }`

Returns **201** with `{ "category": { ... } }`.

### PUT /api/admin/categories/:id

Partial update — all fields optional: name, slug, type, description, parent_id, sort_order.

### DELETE /api/admin/categories/:id

Hard-deletes the category. Returns **204 No Content**.
