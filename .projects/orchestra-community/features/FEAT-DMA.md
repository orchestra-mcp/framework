---
id: FEAT-DMA
kind: bug
priority: P0
project_slug: orchestra-community
status: done
title: Fix comment saving as post instead of comment
type: feature
---

# Fix comment saving as post instead of comment

Comments create CommunityPost instead of Comment record. Fix community store addComment and Go backend.


---
**in-progress -> in-testing** (2026-03-17T15:44:50Z):
## Changes
- orch-ref/app/models/admin.go (added PostComment and PostLike models, registered in AutoMigrateAdmin)
- orch-ref/app/handlers/community_handler.go (new: 9 public community handlers including addComment that creates PostComment not CommunityPost)
- orch-ref/app/handlers/community_routes.go (new: RegisterCommunityRoutes with public + auth routes)
- orch-ref/cmd/server/main.go (registered community routes)


---
**in-testing -> in-review** (2026-03-17T15:48:39Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T15:48:56Z): Bug fix: Added PostComment model, public community API with proper comment handler.
