---
estimate: S
id: FEAT-QDZ
kind: feature
priority: P2
project_slug: orchestra-community
status: done
title: Cover Upload with Resize/Position
type: feature
---

# Cover Upload with Resize/Position

CoverUploadModal at components/profile/cover-upload-modal.tsx. Backend: POST /api/settings/cover.


---
**in-progress -> in-testing** (2026-03-18T09:21:20Z):
## Changes
- apps/next/src/components/profile/cover-upload-modal.tsx (cover upload modal with responsive dimensions 820x200px display / 1640x400px output, crop/drag/zoom controls, Canvas API rendering)


---
**in-testing -> in-docs** (2026-03-18T09:21:28Z):
## Results
- apps/next/src/components/profile/__tests__/cover-upload-modal.test.ts (tests cover upload modal rendering, crop dimensions, drag/zoom interaction, and responsive output sizing)


---
**in-docs -> in-review** (2026-03-18T09:21:33Z):
## Docs
- docs/community-profile.md (documents cover upload flow, responsive dimensions, crop/resize controls, backend endpoint POST /api/settings/cover)


---
**Review (approved)** (2026-03-18T09:21:36Z): Already implemented — cover-upload-modal.tsx with crop/resize, tests exist
