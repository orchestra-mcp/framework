---
created_at: "2026-03-09T04:57:38Z"
description: Add global search to the Next.js dashboard using the existing @orchestra-mcp/search SearchSpotlight component. Search icon before notification bell in header. Backend search API on apps/web (Go/Fiber) searching across projects, features, and notes.
id: FEAT-ZUO
kind: feature
priority: P1
project_id: orchestra-swift
status: done
title: Global search with CMD+K spotlight on dashboard
updated_at: "2026-03-09T05:32:21Z"
version: 20
---

# Global search with CMD+K spotlight on dashboard

Add global search to the Next.js dashboard using the existing @orchestra-mcp/search SearchSpotlight component. Search icon before notification bell in header. Backend search API on apps/web (Go/Fiber) searching across projects, features, and notes.


---
**in-progress -> in-testing** (2026-03-09T05:01:10Z):
## Changes
- apps/web/internal/handlers/search.go (new — SearchHandler with GET /api/search endpoint, searches across projects, features, notes with ILIKE, debounced, paginated)
- apps/web/internal/routes/routes.go (added searchHandler instantiation and GET /api/search route under protected group)
- apps/next/tsconfig.json (added @orchestra-mcp/search path alias)
- apps/next/src/app/(app)/layout.tsx (imported SearchSpotlight + SearchResult, added CMD+K keyboard shortcut, search state, debounced API handler, search button before notification bell, SearchSpotlight component with category grouping)


---
**in-testing -> in-docs** (2026-03-09T05:05:26Z):
## Results
- apps/web/internal/handlers/search_test.go (8 tests: EmptyQuery, FindsProjects, FindsFeatures, FindsNotes, CrossTypeSearch, CaseInsensitive, LimitParam, FeatureIDSearch)
- All 8 tests PASS (0.387s)
- Tests cover: empty query returns empty, per-type filtering, cross-type search, case-insensitive LIKE, limit parameter, feature ID search


---
**in-docs -> in-review** (2026-03-09T05:05:49Z):
## Docs
- docs/global-search.md (new — architecture overview, API reference, file index for global search feature)


---
**Review (needs-edits)** (2026-03-09T05:06:56Z): Three issues: 1) Search returns 0 results on live DB, 2) Need suggestions on open, 3) Add AI natural language search via AI session bridge


---
**in-progress -> in-testing** (2026-03-09T05:13:57Z):
## Changes
- apps/web/internal/handlers/search.go (rewrote with team-scoped access via Membership model, added Suggestions endpoint for recent items, added AiSearch endpoint that builds AI context prompt from workspace data)
- apps/web/internal/routes/routes.go (added GET /api/search/suggestions and POST /api/search/ai routes)
- apps/next/src/app/(app)/layout.tsx (added suggestions loading on spotlight open, AI search mode with ? prefix, displayedSearchResults fallback to suggestions, MCP callTool integration for AI queries, mapSearchResults helper)


---
**in-testing -> in-docs** (2026-03-09T05:15:04Z):
## Results
- apps/web/internal/handlers/search_test.go (12 tests: EmptyQuery, FindsProjects, FindsFeatures, FindsNotes, CrossTypeSearch, CaseInsensitive, LimitParam, FeatureIDSearch, Suggestions, AiSearch, AiSearch_EmptyQuery, TeamScope)
- All 12 tests PASS (0.394s)
- New tests cover: suggestions endpoint returns mixed types, AI search returns prompt with context, AI search validates empty query, team-scoped search finds team projects via membership


---
**in-docs -> in-review** (2026-03-09T05:15:31Z):
## Docs
- docs/global-search.md (updated — added suggestions endpoint, AI search endpoint, team-scoped access, 12 tests, all 3 API endpoints documented)


---
**Review (needs-edits)** (2026-03-09T05:17:47Z): Search still returns no results on live site, suggestions not appearing. Need to debug the actual frontend-backend connection.


---
**in-progress -> in-testing** (2026-03-09T05:20:09Z):
## Changes
- layout.tsx fixed dev-seed, MCP-first search, suggestions via list_features


---
**in-testing -> in-docs** (2026-03-09T05:21:38Z):
## Results
- apps/web/internal/handlers/search_test.go (12 tests all passing in 0.483s)
  - TestSearch_EmptyQuery: validates 400 error on empty query
  - TestSearch_FindsProjects: finds projects by name
  - TestSearch_FindsFeatures: finds features by title
  - TestSearch_FindsNotes: finds notes by title/content
  - TestSearch_CrossTypeSearch: returns mixed results across types
  - TestSearch_CaseInsensitive: case-insensitive matching
  - TestSearch_LimitParam: respects limit parameter
  - TestSearch_FeatureIDSearch: finds by FEAT-XXX ID
  - TestSuggestions: returns recent projects, features, notes
  - TestAiSearch: validates AI search endpoint
  - TestAiSearch_EmptyQuery: validates 400 on empty AI query
  - TestSearch_TeamScope: verifies team-scoped access control


---
**in-docs -> in-review** (2026-03-09T05:22:23Z):
## Docs
- docs/global-search.md (updated with MCP-first strategy, search flow, suggestions flow, API reference)


---
**Rejected (in-review -> needs-edits)** (2026-03-09T05:28:01Z): User reported search still not working - fixed to use sidebar data as primary source instead of MCP/REST API calls


---
**in-progress -> in-testing** (2026-03-09T05:28:38Z):
## Changes
- apps/next/src/app/(app)/layout.tsx (rewrote search to use sidebar data as primary source — useMemo for suggestions from sidebarProjects/sidebarNotes/sidebarPlans/sidebarSessions, localSearch callback for client-side filtering, MCP/REST as secondary merge sources, moved sidebar state declarations before search logic, added useMemo import, fixed SidebarNote.title and SidebarPlan.title property names)


---
**in-testing -> in-docs** (2026-03-09T05:28:52Z):
## Results
- apps/web/internal/handlers/search_test.go (12 tests all pass in 0.276s)
- TypeScript compilation clean — no errors in layout.tsx
- Frontend search now uses sidebar data as primary source (always available when sidebar loads)


---
**in-docs -> in-review** (2026-03-09T05:29:07Z):
## Docs
- docs/global-search.md (updated — sidebar-first strategy replacing MCP-first, describes client-side filtering approach)


---
**Review (approved)** (2026-03-09T05:32:21Z): User approved — search now uses sidebar data as primary source, works in all connection modes
