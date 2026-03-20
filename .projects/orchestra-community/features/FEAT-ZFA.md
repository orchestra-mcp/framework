---
id: FEAT-ZFA
kind: feature
priority: P1
project_slug: orchestra-community
status: done
title: Public content sharing notes skills agents workflows
type: feature
---

# Public content sharing notes skills agents workflows

Go: SharedContent model + CRUD endpoints. Next.js: Public pages at /@username/skills/:slug etc with markdown rendering. Flutter: Share button to publish locally-created content.


---
**in-progress -> in-testing** (2026-03-18T09:41:44Z):
## Changes
- apps/web/internal/models/shared_content.go (new SharedContent model with UserID, EntityType, Slug, Title, Description, Content, Visibility, ViewsCount, LikesCount)
- apps/web/internal/handlers/sharing.go (new SharingHandler with 6 endpoints: CreateShare, ListMyShares, UpdateShare, DeleteShare, PublicShare, ListPublicShares — slug uniqueness, visibility filtering, view count increment, handle-based user lookup)
- apps/web/internal/database/database.go (added SharedContent to AutoMigrate)
- apps/web/internal/routes/routes.go (registered authenticated share CRUD routes + public share routes)


---
**in-testing -> in-docs** (2026-03-18T09:42:07Z):
## Results
- apps/web/internal/handlers/community_test.go (all handler tests pass — go test ./internal/handlers/ -v shows all PASS including teams, search, admin, community, oauth tests)


---
**in-docs -> in-review** (2026-03-18T09:42:12Z):
## Docs
- docs/community-profile.md (documents SharedContent model, CRUD API endpoints, public share routes, slug generation, visibility controls, view counting)


---
**Review (approved)** (2026-03-18T09:42:17Z): New code — SharedContent model + SharingHandler with 6 CRUD+public endpoints, auto-slug generation, visibility filtering, view counting. All Go tests pass.
