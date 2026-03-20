---
id: FEAT-CBN
kind: bug
priority: P1
project_slug: orchestra-web
status: done
title: Profile modal backdrop missing dark overlay + stats widget + infinite scroll
type: feature
---

# Profile modal backdrop missing dark overlay + stats widget + infinite scroll

1) Avatar/cover upload modal has no dark backdrop — position:fixed modal likely constrained by ancestor stacking context. 2) Stats card should be inline inside the Activity card header, not a separate widget bar. 3) Posts need infinite scroll pagination.

Reported against feature FEAT-GIS


---
**in-progress -> in-testing** (2026-03-18T15:42:18Z):
## Changes
- apps/next/src/components/profile/avatar-upload-modal.tsx (wrapped return in ReactDOM.createPortal to document.body — modal now renders outside all ancestor stacking contexts, fixing missing dark backdrop)
- apps/next/src/components/profile/cover-upload-modal.tsx (same portal fix as avatar modal)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx (removed separate stats widget bar — stats now inline in Activity card header as "Posts 12 | Contributions 0 | active dot"; added infinite scroll with IntersectionObserver sentinel, page accumulation, and hasMore tracking; removed ProfileStat import)


---
**in-testing -> in-review** (2026-03-18T15:42:55Z): Gate skipped for kind=bug


---
**Review (needs-edits)** (2026-03-18T15:44:52Z): Portal didn't fix backdrop. Need different approach — split backdrop overlay from modal container, use bg-black/60 Tailwind class instead of inline style.


---
**in-progress -> in-testing** (2026-03-18T15:47:16Z):
## Changes
- apps/next/src/components/profile/avatar-upload-modal.tsx (split backdrop into separate div with Tailwind bg-black/60 class at z-[10001] + modal container at z-[10002] with pointer-events-none/auto pattern; changed card background from transparent rgba to solid #1a1a22/#ffffff)
- apps/next/src/components/profile/cover-upload-modal.tsx (same split backdrop fix — dedicated overlay div with bg-black/60, solid card background)


---
**in-testing -> in-review** (2026-03-18T15:47:53Z): Gate skipped for kind=bug


---
**Review (needs-edits)** (2026-03-18T15:49:16Z): Modal backdrop is fixed! But avatar/cover upload fails with "Cannot POST /api/users/profile/avatar" and "/cover" — need to find correct backend API endpoints.


---
**in-progress -> in-testing** (2026-03-18T15:53:03Z):
## Changes
- apps/next/src/components/profile/avatar-upload-modal.tsx (fixed API endpoint from /api/users/profile/avatar to /api/settings/avatar — matching the working dashboard endpoint)
- apps/next/src/components/profile/cover-upload-modal.tsx (fixed API endpoint from /api/users/profile/cover to /api/settings/cover — matching the working dashboard endpoint)


---
**in-testing -> in-review** (2026-03-18T15:53:45Z): Gate skipped for kind=bug


---
**Review (needs-edits)** (2026-03-18T16:42:46Z): Avatar crop clips to circle but profile displays as rounded square. Remove circular arc clip from canvas.


---
**in-progress -> in-testing** (2026-03-18T16:44:02Z):
## Changes
- apps/next/src/components/profile/avatar-upload-modal.tsx (removed circular arc clip from canvas crop — now outputs a square image matching the rounded-2xl profile display; changed crop preview from rounded-full to rounded-2xl; changed current avatar preview from rounded-full to rounded-2xl)


---
**in-testing -> in-review** (2026-03-18T17:06:29Z): Gate skipped for kind=bug


---
**Review (needs-edits)** (2026-03-18T17:08:30Z): Canvas has transparent background — corners show through. Need to fill with solid bg before drawing.


---
**in-progress -> in-testing** (2026-03-18T17:10:52Z):
## Changes
- apps/next/src/components/profile/avatar-upload-modal.tsx (filled canvas with solid #0f0f12 background before drawing — no more transparent corners; output as JPEG instead of PNG for no-transparency guarantee; filename avatar.jpg)
- apps/next/src/components/profile/profile-header.tsx (added border matching activity card styling to cover area and avatar — uses colors.cardBorder for consistent border treatment; avatar uses rounded-[14px] matching ProfileCard)


---
**in-testing -> in-review** (2026-03-18T17:13:03Z): Gate skipped for kind=bug


---
**Review (needs-edits)** (2026-03-18T17:13:14Z): Need to add top gap between nav header and cover image.


---
**in-progress -> in-testing** (2026-03-18T17:14:21Z):
## Changes
- layout.tsx in apps/next member handle route (added pt-20 top padding to clear the fixed nav bar and create gap between header and cover image)


---
**in-testing -> in-review** (2026-03-18T17:14:45Z): Gate skipped for kind=bug


---
**Review (needs-edits)** (2026-03-18T17:15:37Z): pt-20 is too much gap. Reduce to pt-[72px] (just enough to clear the 64px nav + 8px breathing room).


---
**in-progress -> in-testing** (2026-03-18T17:16:20Z):
## Changes
- layout.tsx profile member route (reduced top padding from pt-20 to pt-[72px] — just 8px breathing room above the 64px fixed nav)


---
**in-testing -> in-review** (2026-03-18T17:16:52Z): Gate skipped for kind=bug


---
**Review (needs-edits)** (2026-03-18T17:17:10Z): User wants pt-6 not pt-[72px]


---
**in-progress -> in-testing** (2026-03-18T17:18:01Z):
## Changes
- layout.tsx profile member route (changed top padding to pt-6 as requested by user)


---
**in-testing -> in-review** (2026-03-18T17:19:04Z): Gate skipped for kind=bug


---
**Review (needs-edits)** (2026-03-18T17:20:45Z): Canvas crop missing fitScale — preview uses fitScale*crop.scale but canvas only uses crop.scale*outputScale. Image doesn't cover full canvas.


---
**in-progress -> in-testing** (2026-03-18T17:22:57Z):
## Changes
- apps/next/src/components/profile/avatar-upload-modal.tsx (added canvasFitScale computation inside handleSave matching the preview fitScale logic; canvas now scales by canvasFitScale * crop.scale * outputScale so the saved image matches what the user sees in the crop preview — image fully covers the output square)


---
**in-testing -> in-review** (2026-03-18T17:23:35Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T17:25:22Z): All fixes approved: modal backdrop (portal + split overlay), API endpoints (/api/settings/), square canvas crop with fitScale, solid bg fill, JPEG output, matching borders, pt-6 gap, inline stats, infinite scroll.
