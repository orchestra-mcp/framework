---
id: FEAT-BVJ
kind: bug
priority: P1
project_slug: orchestra-web
status: done
title: Fix avatar/cover modal backdrop overlaying modal content
type: feature
---

# Fix avatar/cover modal backdrop overlaying modal content

The crop viewport uses a 4000px box-shadow spread to darken the area outside the crop circle, but this shadow bleeds over the entire modal card, controls, and buttons. Fix: wrap the crop viewport in a container with overflow:hidden to contain the box-shadow.

Reported against feature FEAT-VIF


---
**in-progress -> in-testing** (2026-03-17T18:57:18Z):
## Changes
- apps/next/src/components/profile/avatar-upload-modal.tsx (wrapped crop viewport in overflow:hidden container to contain 4000px box-shadow)
- apps/next/src/components/profile/cover-upload-modal.tsx (same overflow:hidden container fix for cover crop viewport)


---
**in-testing -> in-review** (2026-03-17T18:57:22Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T19:01:45Z): User approved. Fixed modal transparent background (solid #1a1a24 dark mode), extracted ProfileHeader into shared component, layout always shows header on all profile pages.
