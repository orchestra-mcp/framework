# Profile Sidebar — Teams & Sponsors Cards

## Overview

The profile sidebar (`profile-sidebar.tsx`) displays two additional cards for team memberships and sponsor logos. The sponsors are manageable via the profile settings modal.

## Card 5: Teams

Renders when `profile.teams` is non-empty. Each team row shows:
- Avatar (image or 2-letter initials fallback, 28x28 rounded square)
- Team name (bold, 12px)
- Role label (dim, 10px)

## Card 6: Sponsors

Renders when `profile.sponsors` is non-empty. Uses a responsive grid (`auto-fill, minmax(60px, 1fr)`). Each sponsor shows:
- Logo image (28x28 rounded, `object-fit: contain`)
- Name label (9px, truncated)
- Links to sponsor URL in new tab
- Sorted by `order` field ascending

## Sponsors Management (Profile Settings)

The "Sponsor" tab in profile settings (`settings-content.tsx`) renders a `SponsorsPanel` component with:

| Field | Type | Placeholder |
|-------|------|-------------|
| Name | text | "Sponsor name" |
| Logo URL | url | "https://example.com/logo.png" |
| Link URL | url | "https://example.com" |

### Features
- **Add**: Up to 10 sponsors (same limit pattern as social links)
- **Remove**: Trash button deletes and re-indexes order
- **Reorder**: Up/down chevron buttons swap with adjacent item
- **Save**: `PATCH /api/settings/profile` with `{ sponsors: [...] }` (filters out empty names)

## Data Model

```typescript
// PublicProfile (store/community.ts)
teams?: { name: string; slug: string; avatar_url?: string; role: string }[]
sponsors?: { name: string; logo_url: string; url: string; order: number }[]
```

## Files

- `apps/next/src/components/profile/profile-sidebar.tsx` — Card 5 (Teams) and Card 6 (Sponsors) rendering
- `apps/next/src/components/profile/settings-content.tsx` — `SponsorsPanel` component
- `apps/next/src/store/community.ts` — `PublicProfile` type with teams/sponsors, seed data
- `apps/next/src/components/profile/__tests__/sponsors-panel.test.ts` — 12 unit tests
