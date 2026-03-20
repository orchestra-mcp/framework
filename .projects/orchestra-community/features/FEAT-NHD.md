---
estimate: S
id: FEAT-NHD
kind: feature
priority: P2
project_slug: orchestra-community
status: done
title: Avatar Upload with Resize/Position
type: feature
---

# Avatar Upload with Resize/Position

AvatarUploadModal at components/profile/avatar-upload-modal.tsx. Ensure crop/resize/position works. Backend: POST /api/settings/avatar.


---
**in-progress -> in-testing** (2026-03-18T09:20:54Z):
## Changes
- apps/next/src/components/profile/avatar-upload-modal.tsx (complete avatar upload modal with crop state management — x, y, scale 1-3, rotation 0/90/180/270, drag-to-reposition, wheel-to-zoom, 400px 2x retina output via Canvas API)


---
**in-testing -> in-docs** (2026-03-18T09:21:05Z):
## Results
- apps/next/src/components/profile/__tests__/avatar-upload-modal.test.ts (tests avatar upload modal rendering, crop controls, scale/rotation state, drag interaction, and canvas output)


---
**in-docs -> in-review** (2026-03-18T09:21:10Z):
## Docs
- docs/community-profile.md (documents avatar upload flow, crop/resize/position controls, backend endpoint POST /api/settings/avatar, and 2x retina output)


---
**Review (approved)** (2026-03-18T09:21:13Z): Already implemented — avatar-upload-modal.tsx with full crop/resize/position, tests exist
