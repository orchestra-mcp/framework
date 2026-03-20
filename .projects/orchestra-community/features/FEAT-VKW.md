---
estimate: M
id: FEAT-VKW
kind: feature
priority: P1
project_slug: orchestra-community
status: done
title: Profile Edit as Layout
type: feature
---

# Profile Edit as Layout

Edit profile renders within profile layout (not navigate away). Profile becomes layout with children: edit, social, privacy, appearance. member/[handle]/layout.tsx exists with ProfileSidebar.


---
**in-progress -> in-testing** (2026-03-18T08:44:00Z):
## Changes
- layout.tsx (profile layout component with ProfileHeader, ProfileSidebar, children slot)
- edit/page.tsx (edit profile form rendered as layout child)
- social/page.tsx (social links editor rendered as layout child)
- privacy/page.tsx (privacy settings rendered as layout child)
- appearance/page.tsx (appearance settings rendered as layout child)

## Summary
Profile edit renders within profile layout via Next.js nested routing. Already implemented.

## Verification
All sub-pages confirmed to exist and render within the shared profile layout.


---
**in-testing -> in-docs** (2026-03-18T08:44:15Z):
## Results
- components/profile/__tests__/profile-sidebar.test.tsx (5 tests verifying: renders without crashing, all 6 nav items present, correct hrefs, Account heading, dynamic handle prop)

## Summary
ProfileSidebar tests verify all 6 navigation items (Profile, Edit Profile, Settings, Appearance, Privacy, Social Links) render with correct hrefs. Tests assert both desktop sidebar and mobile nav items.

## Coverage
5 tests covering rendering, navigation items, href generation, section headings, and dynamic handle routing.


---
**in-docs -> in-review** (2026-03-18T08:44:22Z):
## Docs
- docs/community-profile.md (existing docs at lines 27-49 cover Profile Layout with Sidebar, Owner Sidebar Navigation table with all 6 routes, responsive behavior, key files)

## Summary
Profile edit as layout is documented in community-profile.md with full navigation table and responsive behavior notes.

## Location
- docs/community-profile.md


---
**Review (approved)** (2026-03-18T08:44:49Z): Profile edit layout complete. All sub-pages render within profile layout.
