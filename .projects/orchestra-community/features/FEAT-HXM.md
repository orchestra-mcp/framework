---
id: FEAT-HXM
kind: feature
priority: P1
project_slug: orchestra-community
status: done
title: Cover image upload with resize and position
type: feature
---

# Cover image upload with resize and position

Go: POST /api/users/profile/cover multipart upload with resize. Next.js: Crop/resize/position modal on cover click.


---
**in-progress -> in-testing** (2026-03-17T16:31:29Z):
## Changes
- orch-ref/app/models/sync.go (added CoverURL field to User model)
- orch-ref/app/handlers/auth_handler.go (added cover_url to userResource)
- orch-ref/app/handlers/community_handler.go (added uploadCover handler: 5MB limit, jpeg/png/webp/gif, saves to uploads/covers/)
- orch-ref/app/handlers/community_routes.go (added POST /api/users/profile/cover route)
- apps/next/src/components/profile/cover-upload-modal.tsx (new: rectangular crop modal 820x200, drag, zoom, rotate, canvas 1640x400 retina export)
- apps/next/src/store/auth.ts (added cover_url to User interface)


---
**in-testing -> in-docs** (2026-03-17T16:33:50Z):
## Results
- apps/next/src/components/profile/__tests__/cover-upload-modal.test.ts (19 assertions: component export, props, file input, zoom, rotation, drag, canvas, upload endpoint, FormData, Go handler, form field, DB update, upload dir, model field, auth resource, route, store — all PASS)


---
**in-docs -> in-review** (2026-03-17T16:34:43Z):
## Docs
- docs/community-profile.md (added Cover Image Upload section with backend/frontend docs, added POST /cover to API table)


---
**Review (approved)** (2026-03-17T16:36:45Z): User approved. Cover image upload with rectangular crop modal complete.
