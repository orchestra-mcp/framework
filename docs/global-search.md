# Global Search (CMD+K Spotlight)

Global search across the Orchestra dashboard using a spotlight-style CMD+K interface with AI-powered natural language search.

## Architecture

### Frontend (Next.js Dashboard)

The search uses the existing `@orchestra-mcp/search` package's `SearchSpotlight` component, integrated into the main app layout header.

**Keyboard shortcut:** `CMD+K` (macOS) / `Ctrl+K` (Windows/Linux) toggles the spotlight.

**Search button:** Positioned in the header bar before the notification bell icon.

**Debouncing:** Regular search queries are debounced by 250ms; AI search by 500ms.

**Category grouping:** Results are grouped into Projects, Features, Notes, Plans, and Wiki categories.

**Sidebar-first strategy:** Search uses already-loaded sidebar data (projects, notes, plans, sessions) as the primary source via client-side filtering. This works regardless of MCP connection or auth mode. MCP and REST API results are merged as secondary sources when available.

**Suggestions:** When the spotlight opens with no query, recent items from the sidebar state are shown automatically (derived via `useMemo` from `sidebarProjects`, `sidebarNotes`, `sidebarPlans`, `sidebarSessions`).

**AI search:** Prefix query with `?` for natural language search (e.g., `?what features are in progress?`). Uses MCP `send_message` to query the AI bridge. AI responses are parsed for JSON result arrays or displayed as prose.

**Navigation:** Selecting a result navigates to the corresponding page:
- Projects: `/projects/:slug`
- Features: `/projects/:slug/features/:id`
- Notes: `/notes/:id`
- Plans: `/plans?id=:plan_id`
- Wiki: `/wiki?file=:doc_id`

### Backend (Go/Fiber — apps/web)

**Access control:** All endpoints use team-scoped access — queries match `user_id` OR any `team_id` the user belongs to via the `memberships` table.

#### `GET /api/search`

Text search across projects, features, notes, plans, and wiki docs.

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `q` | string | required | Search query (case-insensitive) |
| `limit` | int | 20 | Max results (1-50) |
| `types` | string | `projects,features,notes,plans,docs` | Comma-separated entity types |

#### `GET /api/search/suggestions`

Returns recent items (3 projects, 5 features, 3 notes, 3 plans, 3 wiki docs) for the empty-query state.

#### `POST /api/search/ai`

AI-powered natural language search. Returns a structured prompt with workspace context.

**Request:** `{ "query": "what features are in progress?" }`

**Response:** `{ "prompt": "...", "context": "ai_search" }`

The prompt includes up to 10 projects, 20 features, 10 notes, 10 plans, and 10 wiki docs from the user's workspace, formatted for the AI to answer the query.

**Response format (all endpoints):**
```json
{
  "results": [
    {
      "id": "p1",
      "type": "project",
      "title": "Orchestra MCP",
      "description": "AI IDE platform",
      "url": "/projects/orchestra-mcp",
      "category": "project"
    }
  ]
}
```

## Files

| File | Purpose |
|------|---------|
| `apps/web/internal/handlers/search.go` | Backend: Search, Suggestions, AiSearch handlers |
| `apps/web/internal/handlers/search_test.go` | 19 test cases |
| `apps/web/internal/routes/routes.go` | Route registration (3 endpoints) |
| `apps/next/src/app/(app)/layout.tsx` | Frontend: CMD+K, suggestions, AI search integration |
| `apps/next/tsconfig.json` | Path alias for search package |
| `apps/next/packages/@orchestra-mcp/search/` | Reusable SearchSpotlight component |
