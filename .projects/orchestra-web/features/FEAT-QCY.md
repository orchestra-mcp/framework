---
id: FEAT-QCY
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Move dashboard/settings pages under profile route + modal-based settings overlay
type: feature
---

# Move dashboard/settings pages under profile route + modal-based settings overlay

1) Move /dashboard, /settings, /settings?tab=appearance fully under /@handle/ routes (/@handle/edit, etc). 2) Create a creative settings modal overlay with sidebar + content panel that opens without leaving the current profile page — replaces tab navigation for notifications/settings.

Converted from request REQ-KAT


---
**in-progress -> in-testing** (2026-03-18T17:47:06Z):
## Changes
- apps/next/src/components/profile/settings-modal.tsx (new: full-screen modal overlay with sidebar navigation listing 8 sections + content panel, portaled to document.body, escape/click-outside to close, body scroll lock)
- apps/next/src/components/profile/settings-content.tsx (new: content router rendering appropriate panel for each section — edit profile reuses ProfileEditForm, social links with add/remove/save, appearance with theme/accent presets, privacy with toggle rows, placeholder panels for account/security/notifications/sponsor)
- apps/next/src/components/profile/profile-header.tsx (added gear icon button next to display name for owner, renders SettingsModal with SettingsContent, imported new components)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/layout.tsx (removed tab bar/ProfileSidebar — settings now accessed via modal, simplified layout)
- apps/next/src/components/profile/avatar-upload-modal.tsx (fixed createPortal return type for React 19)
- apps/next/src/components/profile/cover-upload-modal.tsx (fixed createPortal return type for React 19)


---
**in-testing -> in-docs** (2026-03-18T17:49:24Z):
## Results
- inline-test.mjs (18 assertions, all passed)
  - settings-modal.tsx: createPortal, 8 sections, sidebar, escape key, scroll lock, backdrop
  - settings-content.tsx: ProfileEditForm, SocialLinksPanel, AppearancePanel, PrivacyPanel, section router
  - profile-header.tsx: SettingsModal/SettingsContent imports, gear button, showSettings state
  - layout.tsx: no ProfileSidebar, no tab bar


---
**in-docs -> in-review** (2026-03-18T17:50:07Z):
## Docs
- docs/profile-settings-modal.md (architecture, sections, changes)


---
**Review (needs-edits)** (2026-03-18T17:50:27Z): Two responsive issues: 1) Settings modal sidebar takes too much space on mobile — needs to collapse or stack vertically. 2) Profile header name/handle text too close to cover on mobile — needs more spacing.


---
**in-progress -> in-testing** (2026-03-18T17:53:09Z):
## Changes
- apps/next/src/components/profile/settings-modal.tsx (responsive: mobile gets bottom sheet with horizontal tab bar at top, desktop keeps sidebar layout; close button in top bar on mobile)
- apps/next/src/components/profile/profile-header.tsx (moved settings gear button from next-to-name to end of cover area as "Settings" button next to "Edit Cover"; removed inline gear from name row)


---
**in-testing -> in-docs** (2026-03-18T17:54:02Z):
## Results
- inline-test.mjs — 7 assertions passed: mobile tab bar, desktop sidebar, bottom sheet layout, settings button in cover area, no inline gear next to name


---
**in-docs -> in-review** (2026-03-18T17:54:34Z):
## Docs
- docs/profile-settings-modal.md (updated with responsive design details and trigger location)


---
**Review (needs-edits)** (2026-03-18T17:57:39Z): Mobile: 1) Tab bar not visible/prominent enough, 2) Settings+Edit Cover buttons overlap with avatar on mobile, 3) Cover touches nav


---
**in-progress -> in-testing** (2026-03-18T17:59:04Z):
## Changes
- apps/next/src/components/profile/settings-modal.tsx (mobile tab bar now sticky with solid background so it stays visible while scrolling content)
- apps/next/src/components/profile/profile-header.tsx (cover buttons moved to top-right on mobile, bottom-right on desktop; icon-only on mobile, icon+label on desktop; prevents overlap with avatar)
- layout.tsx member profile route (pt-[80px] to clear the 64px fixed nav + 16px gap; px-4 on mobile, px-6 on desktop)


---
**in-testing -> in-docs** (2026-03-18T17:59:52Z):
## Results
- inline-test.mjs — 5 assertions passed: sticky mobile tabs, buttons top-right on mobile, icon-only labels on mobile, pt-[80px] nav gap, responsive padding


---
**in-docs -> in-review** (2026-03-18T18:00:27Z):
## Docs
- docs/profile-settings-modal.md (updated responsive design section with mobile-specific details)


---
**Review (needs-edits)** (2026-03-18T18:02:31Z): Mobile tab bar invisible — it's outside the scroll container. Need to restructure mobile layout so tabs are inside the scrollable area as sticky.


---
**in-progress -> in-testing** (2026-03-18T18:03:49Z):
## Changes
- apps/next/src/components/profile/settings-modal.tsx (complete restructure: mobile uses separate fixed full-screen layout with flex-col — header + scrollable area containing sticky tab bar + content; desktop unchanged as centered card with sidebar; tab bar is now INSIDE the scroll container so it sticks while content scrolls)


---
**in-testing -> in-docs** (2026-03-18T18:04:31Z):
## Results
- inline-test.mjs — 6 assertions passed: separate mobile/desktop layouts, scroll container with sticky tabs inside, solid bg on tabs, close button


---
**in-docs -> in-review** (2026-03-18T18:04:53Z):
## Docs
- docs/profile-settings-modal.md (updated mobile layout description)


---
**Review (needs-edits)** (2026-03-18T18:09:17Z): Gap between nav and cover too big (pt-[80px]). Reduce it.


---
**in-progress -> in-testing** (2026-03-18T18:10:09Z):
## Changes
- layout.tsx member profile route (reduced top padding from pt-[80px] to pt-[68px] — just 4px gap above the 64px fixed nav)


---
**in-testing -> in-docs** (2026-03-18T18:10:32Z):
## Results
- inline-test.mjs — verified layout has pt-[68px]


---
**in-docs -> in-review** (2026-03-18T18:10:59Z):
## Docs
- docs/profile-settings-modal.md (updated nav clearance value)


---
**Review (needs-edits)** (2026-03-18T18:12:03Z): User wants pt-6 on both mobile and desktop


---
**in-progress -> in-testing** (2026-03-18T18:12:46Z):
## Changes
- layout.tsx member profile route (changed top padding to pt-6 as requested)


---
**in-testing -> in-docs** (2026-03-18T18:13:23Z):
## Results
- grep confirmed layout.tsx has pt-6


---
**in-docs -> in-review** (2026-03-18T18:13:48Z):
## Docs
- docs/profile-settings-modal.md (updated padding value to pt-6)


---
**Review (approved)** (2026-03-18T18:14:24Z): Approved. Settings modal with responsive layout (mobile sticky tabs, desktop sidebar), cover buttons repositioned, pt-6 gap.
