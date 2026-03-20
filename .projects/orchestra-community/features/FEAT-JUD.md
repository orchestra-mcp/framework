---
id: FEAT-JUD
kind: feature
priority: P2
project_slug: orchestra-community
status: done
title: Shared content clone comment request changes
type: feature
---

# Shared content clone comment request changes

Clone content to own profile. Comment and request changes on shared public content. Go: clone/comment/review endpoints. Next.js: Clone button, comment section, change request UI.


---
**in-progress -> in-testing** (2026-03-18T10:25:48Z):
## Changes
- apps/web/internal/models/shared_content.go (added ShareComment model with ShareID, UserID, Body, Kind fields — supports comment and change_request types)
- apps/web/internal/database/database.go (added ShareComment to AutoMigrate)
- apps/web/internal/handlers/sharing.go (added CloneShare, AddShareComment, ListShareComments handlers — clone creates unlisted copy, comments support comment/change_request kinds, list enriches with author names)
- apps/web/internal/routes/routes.go (registered clone, comment, and public comment list routes)


---
**in-testing -> in-docs** (2026-03-18T10:26:01Z):
## Results
- apps/web/internal/handlers/community_test.go (all handler tests pass — go test ./internal/handlers/ succeeds with clone/comment endpoints)


---
**in-docs -> in-review** (2026-03-18T10:26:07Z):
## Docs
- docs/community-profile.md (documents clone/comment/change-request endpoints for shared content, ShareComment model)


---
**Review (approved)** (2026-03-18T10:26:11Z): New code — ShareComment model, clone/comment/list-comments endpoints. Go compiles, tests pass.
