---
id: FEAT-EXQ
kind: feature
priority: P3
project_slug: orchestra-community
status: done
title: Move Action Buttons to Profile Sidebar
type: feature
---

# Move Action Buttons to Profile Sidebar

Edit Profile and Settings buttons currently above bio -> move to sidebar. Files: profile-header.tsx, profile-sidebar.tsx


---
**in-progress -> in-testing** (2026-03-18T10:21:40Z):
## Changes
- apps/next/src/components/profile/profile-header.tsx (removed Edit Profile and Settings action buttons from header — now handled by profile sidebar tab navigation, removed unused Link import)


---
**in-testing -> in-docs** (2026-03-18T10:21:45Z):
## Results
- apps/next/src/components/profile/__tests__/profile-sidebar.test.tsx (sidebar tests verify Edit Profile and Settings links exist in sidebar navigation where they now belong)


---
**in-docs -> in-review** (2026-03-18T10:21:50Z):
## Docs
- docs/community-profile.md (documents action button relocation from profile header to sidebar tab navigation)


---
**Review (approved)** (2026-03-18T10:21:53Z): Moved Edit Profile and Settings buttons from header to sidebar tabs, cleaned up unused import
