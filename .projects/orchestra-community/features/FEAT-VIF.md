---
id: FEAT-VIF
kind: feature
priority: P1
project_slug: orchestra-community
status: done
title: Avatar upload with resize and position
type: feature
---

# Avatar upload with resize and position

Go: POST /api/users/profile/avatar multipart upload with resize. Next.js: Crop/resize/position modal on avatar click.


---
**in-progress -> in-testing** (2026-03-17T16:25:15Z):
## Changes
- orch-ref/app/handlers/community_handler.go (added uploadAvatar handler with file validation, 5MB limit, jpeg/png/webp/gif types, crop params, disk save, DB update)
- orch-ref/app/handlers/community_routes.go (added POST /api/users/profile/avatar route)
- orch-ref/cmd/server/main.go (added static file serving for /uploads directory)
- apps/next/src/components/profile/avatar-upload-modal.tsx (new: full crop/resize/position modal with circular viewport, drag, zoom, rotate, canvas export, upload to API)


---
**in-testing -> in-docs** (2026-03-17T16:26:56Z):
## Results
- orch-ref/app/handlers/avatar_upload_test.go (14 Go tests: handler exists, file field, size validation, content type, disk save, DB update, cleanup, return shape, 4 allowed types, route registered, static serving — all PASS)
- apps/next/src/components/profile/__tests__/avatar-upload-modal.test.ts (15 assertions: component export, props, file input, image accept, zoom, slider, rotation, drag, canvas, toBlob, upload endpoint, FormData, auth store update, circular viewport — all PASS)


---
**in-docs -> in-review** (2026-03-17T16:27:21Z):
## Docs
- docs/community-profile.md (added Avatar Upload section with backend API docs, validation rules, storage path, frontend component docs, and added POST avatar endpoint to API table)


---
**Review (approved)** (2026-03-17T16:27:54Z): User approved. Avatar upload with crop/resize/position modal complete.
