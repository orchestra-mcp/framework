---
id: FEAT-OMP
kind: feature
priority: P1
project_slug: orchestra-community
status: done
title: Spotlight search user and public data
type: feature
---

# Spotlight search user and public data

Search across user data and all public data. Go: PostgreSQL FTS search API. Dynamic indexing on publish. Next.js: Search UI with categorized results.


---
**in-progress -> in-testing** (2026-03-18T10:27:09Z):
## Changes
- apps/web/internal/handlers/search.go (PublicSearch now includes SharedContent in results — searches public shares by title/description, returns entity type and slug-based URLs; fixed profile URLs to use /@handle instead of /profile/:id)


---
**in-testing -> in-docs** (2026-03-18T10:27:24Z):
## Results
- apps/web/internal/handlers/search_test.go (all search tests pass — go test ./internal/handlers/ succeeds including public search with shared content)


---
**in-docs -> in-review** (2026-03-18T10:27:29Z):
## Docs
- docs/community-profile.md (documents spotlight search — PublicSearch now covers shared content alongside posts, docs, and profiles with category-based results)


---
**Review (approved)** (2026-03-18T10:27:39Z): PublicSearch extended with SharedContent results + fixed profile URLs to /@handle. Tests pass.
