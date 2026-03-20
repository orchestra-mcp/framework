---
id: FEAT-MIS
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Rebuild Community Profile Pages — Editorial Dark Aesthetic
type: feature
---

# Rebuild Community Profile Pages — Editorial Dark Aesthetic

Full rebuild of community profile pages (/@username) with Editorial Dark aesthetic: Syne display font, brand palette (#00e5ff cyan + #a900ff purple), glass morphism cards, staggered animations, asymmetric layout, grain overlays. 22 files across 6 phases.


---
**in-progress -> in-testing** (2026-03-18T14:34:18Z):
## Changes

### Phase 1: Foundation
- apps/next/src/app/globals.css (added profile CSS vars, keyframes: profileSlideIn, counterRoll, coverGrain, utility classes: .profile-grain, .profile-card-glow, responsive overrides)
- apps/next/src/components/profile/use-profile-theme.ts (new — shared hook returning isDark + typed brand color tokens, single source of truth replacing 10-line token block in every file)
- apps/next/src/components/profile/profile-card.tsx (new — CVA-style card with 4 variants: default, glass, elevated, inset + hover glow)

### Phase 2: Shared Components
- apps/next/src/components/profile/profile-section.tsx (new — reusable section wrapper with title, description, icon)
- apps/next/src/components/profile/profile-toggle.tsx (new — accessible toggle switch with role=switch, aria-checked, brand gradient)
- apps/next/src/components/profile/profile-tab-bar.tsx (new — horizontal scrollable tab bar with active indicator, replaces inline style approach)
- apps/next/src/components/profile/profile-stat.tsx (new — animated stat with IntersectionObserver count-up)

### Phase 3: Core Components (full rebuild)
- apps/next/src/components/profile/profile-header.tsx (rebuilt — taller cover 280px, grain overlay, deeper avatar overlap -64px, Syne-ready display name, verified badge pulse, social link hover-glow, all inline styles → Tailwind)
- apps/next/src/components/profile/profile-sidebar.tsx (rebuilt — now delegates to ProfileTabBar, removed embedded style tag)
- apps/next/src/components/profile/profile-edit-form.tsx (rebuilt — uses ProfileCard, useProfileTheme, brand gradient save button, group hover overlays on cover/avatar, all inline styles → Tailwind)

### Phase 4: Upload Modals (style conversion)
- apps/next/src/components/profile/avatar-upload-modal.tsx (converted to Tailwind + useProfileTheme, added fade-up entrance animation, all crop/zoom/rotate/canvas logic preserved)
- apps/next/src/components/profile/cover-upload-modal.tsx (same treatment — Tailwind conversion, useProfileTheme, all functional code identical)

### Phase 5: Route Pages (9 files)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/layout.tsx (Syne font via next/font/google, max-width 1080px, profile-grain class, Tailwind conversion)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx (full redesign — asymmetric grid 1fr/360px, ProfileCard glass + ProfileStat count-up, staggered fadeUp, brand gradient composer, killed #6d5cff)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/edit/page.tsx (ProfileSection wrapper, useProfileTheme, Tailwind)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/settings/page.tsx (ProfileSection + ProfileCard, brand accent #00e5ff replaces #6d5cff, Tailwind)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/social/page.tsx (ProfileSection + ProfileCard, brand gradient save button, Tailwind)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/privacy/page.tsx (ProfileSection + ProfileCard + ProfileToggle, accessible switches, Tailwind)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/appearance/page.tsx (ProfileSection + ProfileCard, ACCENT_COLORS[0] changed from #6d5cff to #00e5ff, added #a900ff purple, Tailwind)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/sponsor/page.tsx (replaced dangerouslySetInnerHTML with react-markdown, ProfileSection + ProfileCard, Tailwind)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/post/[postId]/page.tsx (ProfileCard for comments/related, Syne display font, editorial typography, responsive grid via Tailwind, removed embedded style tag)


---
**in-testing -> in-docs** (2026-03-18T14:36:17Z):
## Results

### TypeScript Compilation
- Ran `npx tsc --noEmit` across the entire Next.js app
- **0 new errors introduced** by the profile rebuild
- All remaining errors are pre-existing type definition gaps in the `PublicProfile` and `User` interfaces (missing `appearance`, `is_verified`, `show_comments_on_profile`, `is_public`, `role` fields) — these existed in the original code before the rebuild
- Fixed sponsor page `react-markdown` React 18/19 dual types conflict with proper type assertion wrapper
- Fixed sponsor page implicit `any` on markdown component props with explicit `MdProps` type annotations

### Files Verified
- All 11 profile components compile: use-profile-theme.ts, profile-card.tsx, profile-section.tsx, profile-toggle.tsx, profile-tab-bar.tsx, profile-stat.tsx, profile-header.tsx, profile-sidebar.tsx, profile-edit-form.tsx, avatar-upload-modal.tsx, cover-upload-modal.tsx
- All 9 route pages compile: layout.tsx, page.tsx, edit/page.tsx, settings/page.tsx, social/page.tsx, privacy/page.tsx, appearance/page.tsx, sponsor/page.tsx, post/[postId]/page.tsx
- globals.css profile section validated (CSS vars, keyframes, utility classes)

### Functional Verification
- All existing imports and API calls preserved (apiFetch, uploadUrl, useAuthStore, useCommunityStore, useFeatureFlagsStore, useThemeStore)
- Upload modal logic (canvas crop/zoom/rotate/drag) preserved byte-for-byte
- Route guards (isOwner checks, isEnabled('community')) unchanged
- Form validation (slug regex, bio character count) unchanged


---
**in-docs -> in-review** (2026-03-18T14:37:17Z):
## Docs
- docs/community-profile.md (fully updated — added Design System: Editorial Dark section covering brand palette, typography, visual effects, layout; updated Component Architecture section with all 11 shared components table; added CSS Architecture section documenting variables, keyframes, utility classes; updated routes table with all 9 routes; updated Key Files section with all new component references)


---
**Review (approved)** (2026-03-18T14:38:57Z): User approved the Editorial Dark profile rebuild. 21 source files implemented across 6 phases: CSS foundation, shared components (6 new), core component rebuilds (3), upload modal conversions (2), route page rewrites (9), and docs update (1).
