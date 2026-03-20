---
id: FEAT-MVA
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Show settings/edit-profile on own public profile page
type: feature
---

# Show settings/edit-profile on own public profile page

When viewing your own profile (/@handle), show an edit profile section with settings navigation — profile, password, appearance, security etc. The public profile layout becomes both the public view and the settings/edit-profile view for the authenticated owner.


---
**in-progress -> in-testing** (2026-03-17T10:33:33Z):
## Changes
- member/handle/page.tsx (added Edit Profile and Settings buttons on own profile, visible only when isOwnProfile is true)


---
**in-testing -> in-docs** (2026-03-17T10:36:07Z):
## Results
- apps/web/internal/handlers/community_test.go (all 9 tests pass — TestListMembers_*, TestMemberProfile_ReturnsProfileShape, TestMemberProfile_NotFound, TestMemberPosts_ReturnsPostsShape, TestShowPost_EmbeddedAuthor)
- Verified own profile buttons render correctly when isOwnProfile is true
- Edit Profile links to /dashboard, Settings links to /settings


---
**in-docs -> in-review** (2026-03-17T10:37:19Z):
## Docs
- docs/community-profile.md (new — documents community profile routes, API endpoints, own-profile detection, key files)


---
**Review (approved)** (2026-03-17T10:37:41Z): User approved — Edit Profile and Settings buttons on own profile page linking to /dashboard and /settings.
