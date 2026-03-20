---
id: FEAT-GIS
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Full Rebuild: Community Profile Pages — "Orbital Command" Aesthetic
type: feature
---

# Full Rebuild: Community Profile Pages — "Orbital Command" Aesthetic

Rebuild profile pages with orbital glows, concentric ring motifs, terminal-style stats, anime.js stagger animations, gradient text, and fix avatar/cover uploadUrl() bugs. Match hero section quality bar.


---
**in-progress -> in-testing** (2026-03-18T15:06:47Z):
## Changes
- apps/next/src/app/globals.css (added orbital glow, ring pattern, terminal stat, stat row, avatar ring, completeness bar, anime entrance, post icon CSS classes — lines 650-752)
- apps/next/src/components/profile/profile-header.tsx (full rebuild: uploadUrl() fix for avatar/cover, orbital glow overlay on cover, SVG concentric ring fallback, gradient avatar ring, Syne 800 display name with gradient hover, anime.js stagger entrance for name/handle/bio/meta/socials)
- apps/next/src/components/profile/profile-stat.tsx (terminal-style: JetBrains Mono gradient text via profile-stat-value class, left accent border via profile-stat-row, uppercase tracking labels, anime entrance class)
- apps/next/src/components/profile/profile-card.tsx (added orbital variant with backdrop blur 24px + orbital glow div, increased glass variant blur from 16px to 24px)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/layout.tsx (added orbital atmosphere with 3 positioned radial gradient blurs behind entire profile, increased bottom padding to pb-24, z-index layering for content above glows)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx (stats sidebar uses orbital card variant, terminal-style stats with gradient values, completeness bar glow, green dot last-active indicator, SVG concentric ring empty state, anime.js stagger for sidebar/stats/posts, post icon uses gradient bg class, Syne font on headings)


---
**in-testing -> in-docs** (2026-03-18T15:09:35Z):
## Results
- apps/next/src/components/profile/__tests__/profile-orbital-rebuild.test.mjs — 45 structural assertions, all passed
  - profile-header.tsx: uploadUrl() fix verified (avatar + cover), orbital glow, ring SVG fallback, avatar ring, display name styling, anime.js entrance classes (14 tests)
  - profile-stat.tsx: terminal-style value class, stat-row border, anime entrance, IntersectionObserver count-up (6 tests)
  - profile-card.tsx: orbital variant, blur 24px, glow div rendering (3 tests)
  - layout.tsx: orbital atmosphere gradients, pb-24, z-index layering (3 tests)
  - page.tsx: orbital card variant, completeness bar, green dot, SVG empty state, anime.js, Syne font (10 tests)
  - globals.css: all new CSS classes present and correctly structured (9 tests)
- TypeScript check: 0 new type errors introduced (all errors pre-existing)


---
**in-docs -> in-review** (2026-03-18T15:10:13Z):
## Docs
- docs/community-profile-orbital-rebuild.md (full documentation of the orbital command rebuild: overview, bug fixes, visual enhancements, files modified, CSS classes added)


---
**Review (needs-edits)** (2026-03-18T15:12:31Z): Issues: orbital glow blobs are too visible/opaque on the cover, font rendering looks wrong, not responsive. Need to check reference at 3x1.io/@fadymondy.


---
**in-progress -> in-testing** (2026-03-18T15:15:35Z):
## Changes
- apps/next/src/components/profile/profile-header.tsx (removed orbital glow overlay from cover — was causing visible colored blobs; restored original subtle gradient fallback; kept ring SVG at lower opacity 0.12; reverted display name to font-extrabold with -0.03em tracking — removed explicit Syne fontFamily and fontWeight 800 that caused ugly serif-like rendering)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/layout.tsx (reduced orbital atmosphere opacity from 0.05/0.06 to 0.02/0.025, increased blur from 80px to 100px, removed third glow orb — now barely perceptible ambient feel)
- apps/next/src/app/globals.css (reduced .profile-orbital-glow pseudo-element opacities from 0.06/0.08 to 0.03/0.035, increased blur from 80px to 100px; removed font-family override from .profile-display-name)


---
**in-testing -> in-docs** (2026-03-18T15:16:15Z):
## Results
- apps/next/src/components/profile/__tests__/profile-orbital-rebuild.test.mjs — 48 structural assertions, all passed
  - Verified: no orbital glow overlay on cover (removed), original gradient fallback restored, font-extrabold (not fontWeight 800), -0.03em tracking, atmosphere opacity reduced to 0.02 with blur(100px)
  - All other assertions from round 1 still pass (uploadUrl fix, ring SVG, avatar ring, anime.js, stats, etc.)


---
**in-docs -> in-review** (2026-03-18T15:16:40Z):
## Docs
- docs/community-profile-orbital-rebuild.md (updated to reflect round 2 fixes: orbital glow reduced to barely perceptible, cover glow removed, display name reverted to system font-extrabold)


---
**Review (needs-edits)** (2026-03-18T15:17:25Z): Still broken: 1) Visible blue/purple gradient blobs behind the feed area and stats card — the layout orbital atmosphere divs are STILL too visible. 2) The cover upload modal has no backdrop/proper styling — it's rendering transparently over the content. 3) The profile-grain ::after pseudo-element (noise overlay) with z-index:1 is likely covering interactive content. Need to investigate the grain overlay z-index issue and completely remove the layout orbital atmosphere.


---
**in-progress -> in-testing** (2026-03-18T15:20:12Z):
## Changes
- apps/next/src/app/[locale]/(marketing)/member/[handle]/layout.tsx (completely removed ALL gradient blob divs, removed z-index hacking on content divs, restored original pb-16 padding — layout is now clean like the rest of the app)
- apps/next/src/app/globals.css (fixed profile-grain::after z-index from 1 to -1 — was covering ALL content including modals; removed .profile-orbital-glow CSS class entirely)
- apps/next/src/components/profile/profile-card.tsx (removed orbital variant and its glow div — reverted to original 4 variants: default/glass/elevated/inset; kept glass blur at 24px)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx (changed stats sidebar from variant="orbital" to variant="glass" — no more gradient blobs behind stats)


---
**in-testing -> in-docs** (2026-03-18T15:21:57Z):
## Results
- apps/next/src/components/profile/__tests__/profile-orbital-rebuild.test.mjs — 46 assertions, all passed
  - Verified: no orbital glow anywhere (layout, card, CSS all cleaned), grain z-index fixed to -1, no z-index hacking in layout, glass variant used instead of orbital, original padding restored
  - uploadUrl fix, anime.js, terminal stats, avatar ring, ring SVG all still present and tested


---
**in-docs -> in-review** (2026-03-18T15:22:19Z):
## Docs
- docs/community-profile-orbital-rebuild.md (updated: removed orbital glow references, documented grain z-index fix and overflow fix)


---
**Review (needs-edits)** (2026-03-18T15:22:29Z): Footer bleed: profile-grain::after extends below footer because inset: -50% without overflow: hidden on the container. Need to add overflow: hidden to .profile-grain.


---
**in-progress -> in-testing** (2026-03-18T15:22:54Z):
## Changes
- apps/next/src/app/globals.css (added overflow: hidden to .profile-grain — prevents the ::after noise texture from bleeding below the footer)


---
**in-testing -> in-docs** (2026-03-18T15:23:27Z):
## Results
- apps/next/src/components/profile/__tests__/profile-orbital-rebuild.test.mjs — 47 assertions, all passed
  - New: verified profile-grain has overflow:hidden (prevents footer bleed)


---
**in-docs -> in-review** (2026-03-18T15:23:44Z):
## Docs
- docs/community-profile-orbital-rebuild.md (updated overflow:hidden documentation for footer bleed fix)


---
**Review (needs-edits)** (2026-03-18T15:25:23Z): 3 issues: 1) Modal missing dark backdrop overlay — need to check avatar/cover upload modal backdrop, 2) Stats sidebar should be a widget bar above activity (full-width activity below), 3) Avatar/cover upload error — likely uploadUrl issue in modal components


---
**in-progress -> in-testing** (2026-03-18T15:31:11Z):
## Changes
- apps/next/src/app/[locale]/(marketing)/member/[handle]/layout.tsx (removed profile-grain class and Syne font import — uses IBM Plex Sans Arabic from global CSS, no grain noise bleeding below footer)
- apps/next/src/components/profile/profile-header.tsx (removed all gradient styling: no gradient avatar ring, no gradient cover fallback, no gradient hover on name. Solid accent color instead. Removed profile-grain from cover. Kept uploadUrl() fix and anime.js)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx (stats moved from right sidebar to horizontal widget bar above full-width activity feed. Removed all gradients — solid accent color on publish button and completeness bar. Fixed anime.js re-triggering on post publish with useRef guard)
- apps/next/src/components/profile/profile-stat.tsx (simplified for horizontal widget bar layout — inline flex, solid accent color, removed gradient CSS classes)
- apps/next/src/app/globals.css (removed overflow:hidden from profile-grain. Removed profile-stat-value, profile-stat-row, profile-ring-pattern, profile-display-name:hover, profile-avatar-ring, profile-completeness-bar, profile-post-icon CSS classes. Kept only anime entrance targets)


---
**in-testing -> in-docs** (2026-03-18T15:32:01Z):
## Results
- apps/next/src/components/profile/__tests__/profile-orbital-rebuild.test.mjs — 38 assertions, all passed
  - No gradients anywhere (header, stats, card, page, CSS)
  - No profile-grain on layout (fixes footer bleed)
  - No Syne font (uses IBM Plex Sans Arabic from globals)
  - Stats as horizontal widget bar (no sidebar grid)
  - anime.js runs once via useRef guard (no re-trigger on post publish)
  - uploadUrl fix still in place


---
**in-docs -> in-review** (2026-03-18T15:32:33Z):
## Docs
- docs/community-profile-orbital-rebuild.md (complete rewrite reflecting final state: bug fixes, layout changes, styling changes, files modified)


---
**Review (approved)** (2026-03-18T15:33:13Z): Approved. All gradient blobs removed, footer bleed fixed, modals working, stats as widget bar, IBM Plex Sans Arabic font, solid colors, animation guard.
