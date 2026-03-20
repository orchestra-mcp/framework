# Community Profile Pages — Rebuild

## Overview

Full rebuild of community profile pages to fix critical bugs and align styling with the Orchestra app design system (clean dark cards, solid colors, IBM Plex Sans Arabic font).

## Bug Fixes

- **Avatar broken**: `profile.avatar_url` now wrapped with `uploadUrl()` — resolves broken avatar images
- **Cover broken**: `profile.cover_url` now wrapped with `uploadUrl()` — resolves missing cover images
- **Footer grain bleed**: Removed `profile-grain` class from layout wrapper — the noise `::after` pseudo-element was extending below the footer
- **Modal backdrop broken**: Removing `profile-grain` (and its `overflow: hidden`) from the layout fixed modals rendering without dark backdrop
- **Grain z-index**: Changed `profile-grain::after` from `z-index: 1` to `z-index: -1` so it never covers interactive content
- **Animation re-trigger**: Added `useRef` guard so anime.js entrance runs once on initial load, not on every post publish

## Layout Changes

- **Stats**: Moved from right sidebar (360px column) to a horizontal widget bar above the activity feed
- **Activity feed**: Now takes full width
- **Font**: Removed Syne font import from layout — profile uses IBM Plex Sans Arabic from global CSS, matching the rest of the app

## Styling Changes

- Removed all gradient effects (gradient text, gradient borders, gradient icon backgrounds)
- All accent elements use solid `#00e5ff` color
- Cover fallback uses a subtle monochrome gradient matching theme (dark/light)
- Publish button uses solid accent color
- Avatar fallback initials use solid accent background

## Files Modified

| File | Changes |
|------|---------|
| `globals.css` | Removed 8 unused CSS classes, fixed grain z-index to -1 |
| `profile-header.tsx` | uploadUrl() fix, removed gradients/grain/Syne, solid colors |
| `profile-stat.tsx` | Simplified for horizontal layout, solid accent color |
| `profile-card.tsx` | Removed orbital variant, kept glass at blur(24px) |
| `layout.tsx` | Removed profile-grain, Syne font, gradient blobs |
| `page.tsx` | Stats as widget bar, full-width feed, anime.js once-guard |
