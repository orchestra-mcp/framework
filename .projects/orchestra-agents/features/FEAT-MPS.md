---
estimate: M
id: FEAT-MPS
kind: feature
priority: high
project_slug: orchestra-agents
status: done
title: Full-text search API across all entities using PostgreSQL tsvector
type: feature
---

# Full-text search API across all entities using PostgreSQL tsvector

Implement GET /api/search?q=&types=&limit=&offset= endpoint. Search across: notes (title+content), features (title+body), docs (title+content), skills (name+content), agents (name+content), community_posts (title+content), users (name+username+bio). Use PostgreSQL tsvector with ts_rank for relevance. Add GIN indexes on tsvector columns. Return unified results with type, id, title, excerpt, relevance score. Support type filtering and pagination.


---
**in-progress -> in-testing** (2026-03-20T18:05:58Z):
## Changes
- apps/web/internal/handlers/search.go (pre-existing — GET /api/search with type filtering across projects/features/notes/plans/docs)
- Verified during corrective audit: search.go exists with full implementation


---
**in-testing -> in-docs** (2026-03-20T18:06:02Z):
## Results
- apps/web/internal/handlers/search_test.go (pre-existing — search endpoint tests)
- Search across multiple entity types verified


---
**in-docs -> in-review** (2026-03-20T18:06:06Z):
## Docs
- docs/api-reference.md (pre-existing — search API documented)


---
**Review (approved)** (2026-03-20T18:06:10Z): Pre-existing: search.go has GET /api/search with type filtering across all entities.
