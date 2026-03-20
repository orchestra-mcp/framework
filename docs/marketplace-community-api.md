# Marketplace Community API

Public endpoints for the marketplace community features (skills, agents, workflows sharing).

## Endpoints

### List Community Items

```
GET /api/public/marketplace/:type
```

**Parameters:**
- `:type` — `skills`, `agents`, or `workflows`

**Query:**
- `?stack=go` — Filter by tech stack
- `?sort=downloads|created_at` — Sort order
- `?page=1&limit=20` — Pagination

**Response:**
```json
{
  "data": [
    {
      "slug": "commit-reviewer",
      "name": "Commit Reviewer",
      "desc": "AI-powered code review for every commit.",
      "author": "Sarah Chen",
      "author_handle": "sarachen",
      "type": "skill",
      "stacks": ["go", "typescript"],
      "downloads": 1240,
      "created_at": "2026-03-01T00:00:00Z"
    }
  ],
  "total": 42,
  "page": 1
}
```

### Get Community Item

```
GET /api/public/marketplace/:type/:slug
```

**Parameters:**
- `:type` — `skills`, `agents`, or `workflows`
- `:slug` — Item slug (e.g., `commit-reviewer`)

**Response:**
```json
{
  "data": {
    "slug": "commit-reviewer",
    "name": "Commit Reviewer",
    "desc": "AI-powered code review for every commit.",
    "author": "Sarah Chen",
    "author_handle": "sarachen",
    "author_id": 42,
    "type": "skill",
    "stacks": ["go", "typescript"],
    "downloads": 1240,
    "content": "# /commit-review\n\nRuns AI-powered code review...",
    "created_at": "2026-03-01T00:00:00Z",
    "updated_at": "2026-03-10T00:00:00Z"
  }
}
```

### Publish Community Item (Auth Required)

```
POST /api/marketplace/:type
Authorization: Bearer <token>
```

**Body:**
```json
{
  "name": "My Skill",
  "slug": "my-skill",
  "desc": "Short description",
  "content": "# Full skill/agent/workflow content...",
  "stacks": ["go", "typescript"]
}
```

### Update Community Item (Auth Required, Owner Only)

```
PUT /api/marketplace/:type/:slug
Authorization: Bearer <token>
```

### Delete Community Item (Auth Required, Owner Only)

```
DELETE /api/marketplace/:type/:slug
Authorization: Bearer <token>
```

### Increment Install Count

```
POST /api/public/marketplace/:type/:slug/install
```

Called when the deep link or CLI install completes successfully.

## Database Schema

```sql
CREATE TABLE marketplace_items (
  id          SERIAL PRIMARY KEY,
  slug        VARCHAR(100) UNIQUE NOT NULL,
  name        VARCHAR(200) NOT NULL,
  description TEXT,
  content     TEXT NOT NULL,
  type        VARCHAR(20) NOT NULL CHECK (type IN ('skill', 'agent', 'workflow')),
  stacks      TEXT[] DEFAULT '{}',
  author_id   INTEGER REFERENCES users(id),
  downloads   INTEGER DEFAULT 0,
  published   BOOLEAN DEFAULT true,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_marketplace_type ON marketplace_items(type);
CREATE INDEX idx_marketplace_author ON marketplace_items(author_id);
CREATE INDEX idx_marketplace_stacks ON marketplace_items USING GIN(stacks);
```

## Deep Link Scheme

```
orchestra://install/:type/:slug
```

Examples:
- `orchestra://install/pack/go-backend`
- `orchestra://install/plugin/engine-rag`
- `orchestra://install/skill/commit-reviewer`
- `orchestra://install/agent/security-auditor`
- `orchestra://install/workflow/pr-pipeline`

Desktop and mobile apps register `orchestra://` as a custom URL scheme. When opened:
1. Parse the path to extract type and slug
2. For packs/plugins: call `orchestra pack install <slug>` or `orchestra plugin install <slug>`
3. For skills/agents/workflows: fetch content from API, write to `.claude/skills/` or `.claude/agents/`

### Flutter Deep Link Implementation

- **Handler**: `apps/flutter/lib/core/deeplink/deeplink_handler.dart` — singleton service using `app_links` package
- **Dialog**: `apps/flutter/lib/widgets/deep_link_install_dialog.dart` — confirmation dialog showing slug and CLI command
- **URL scheme**: Registered in iOS Info.plist and Android AndroidManifest.xml
- **Init**: Call `DeepLinkHandler.instance.init()` during app startup
- **Listen**: Subscribe to `DeepLinkHandler.instance.installRequests` stream for install events

## README Rendering

Plugin and pack detail pages render README content with a two-tier fallback:

1. **GitHub fetch** — `GET https://raw.githubusercontent.com/{repo}/main/README.md` with 1-hour ISR revalidation
2. **Seed README** — Embedded content in the `PLUGINS` record (14 plugins) or generated via `generateSeedReadme()` (24 packs)

When the GitHub README is unavailable (repo not yet published, network error), the page shows an amber info banner: "Generated from plugin/pack metadata — README from GitHub unavailable."

### Seed README Content

Plugin seed READMEs include: tool listings, installation commands, feature descriptions, and configuration examples. Pack seed READMEs are dynamically generated from pack metadata (skills count, agents count, hooks count, stacks, installation commands).

### Files

- `marketplace/plugins/[slug]/page.tsx` — Server component with `fetchReadme()` + `PLUGINS` record
- `marketplace/plugins/[slug]/PluginDetailClient.tsx` — Client component with `isSeedReadme` banner
- `marketplace/packs/[slug]/page.tsx` — Server component with `fetchReadme()` + `generateSeedReadme()`
- `marketplace/packs/[slug]/PackDetailClient.tsx` — Client component with `isSeedReadme` banner
