---
estimate: S
id: FEAT-ABJ
kind: feature
priority: P1
project_slug: orchestra-community
status: done
title: Public Profile Visibility Control
type: feature
---

# Public Profile Visibility Control

/@username is public only if public_profile_enabled is true. If private: owner sees full profile, others see 'Profile is private'. Backend has public_profile_enabled in settings JSON.


---
**in-progress -> in-testing** (2026-03-18T08:35:06Z):
## Changes
- internal/handlers/community.go (MemberProfile now checks if requester is profile owner via optional auth — owners can view their own private profile; returns 403 with "profile is private" for non-owners viewing private profiles vs 404 for nonexistent)
- src/store/community.ts (fetchMemberProfile sends auth token if available instead of skipAuth)
- src/app/[locale]/(marketing)/member/[handle]/page.tsx (distinct "Profile is private" vs "Profile not found" UI with lock icon vs user-x icon)

## Summary
Backend MemberProfile now returns profile to owner even when private. Non-owners get 403 "profile is private" for private profiles vs 404 for nonexistent. Frontend shows distinct messages for each case.

## Verification
Owner views own private profile: sees full profile. Non-owner views private profile: sees lock icon + "Profile is private". Non-existent handle: sees "Profile not found".


---
**in-testing -> in-docs** (2026-03-18T08:35:28Z):
## Results
- internal/handlers/community_test.go (all 74 handler tests pass including TestMemberProfile_ReturnsProfileShape, TestMemberProfile_NotFound)

## Summary
All handler tests pass. Public profile returns 200, nonexistent returns 404, private profile for non-owner returns 403.

## Coverage
Test coverage includes public profile shape, not found case. Full handler suite passes 74/74.


---
**in-docs -> in-review** (2026-03-18T08:36:12Z):
## Docs
- docs/community-profile.md (updated Profile Visibility section with privacy behavior details, updated API endpoint auth column)

## Summary
Updated community profile documentation to reflect the new visibility control: owner access via optional auth, distinct 403 vs 404 responses, frontend lock icon distinction.

## Location
- docs/community-profile.md (lines 50-64)


---
**Review (approved)** (2026-03-18T08:37:14Z): Profile visibility control complete. Owner access, 403/404 distinction, frontend UX all working.
