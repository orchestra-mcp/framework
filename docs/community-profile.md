# Community Public Profile

## Overview

The community profile page (`/@username`) serves as both a public profile view and an edit entry point for the authenticated owner. After login, users are redirected to their profile at `/@username`.

## Design System: Editorial Dark

The profile pages use an "Editorial Dark" aesthetic — magazine-style design meets developer platform.

### Brand Palette
- **Accent Cyan**: `#00e5ff` — primary interactive color (links, stats, active states)
- **Accent Purple**: `#a900ff` — secondary accent, used in gradients
- **Brand Gradient**: `linear-gradient(135deg, #00e5ff, #a900ff)` — buttons, progress bars, avatar fallbacks
- The legacy `#6d5cff` accent has been fully replaced

### Typography
- **Syne** (Google Fonts, 400-800) — display font for profile names and headings, scoped to profile layout via `next/font/google` CSS variable `--font-syne`
- **Instrument Sans** — body font (global)

### Visual Effects
- **Glass morphism**: Stats sidebar uses `backdrop-filter: blur(16px)` with semi-transparent background
- **Grain overlay**: Cover images have a subtle animated grain texture via `.profile-grain` CSS class
- **Hover glow**: Cards use `.profile-card-glow` for a cyan glow + lift on hover
- **Count-up stats**: Profile stats animate from 0 on scroll intersection
- **Staggered entrance**: Activity feed items use `.fade-up-1` through `.fade-up-4` for staggered load animation

### Layout
- **Container**: 1080px max-width (CSS variable `--profile-content-max`)
- **Cover**: 280px height (`--profile-cover-height`), edge-to-edge within container
- **Avatar**: 140px (`--profile-avatar-size`), -64px overlap (`--profile-avatar-overlap`)
- **Main page grid**: Asymmetric `1fr 360px` — wider feed left, stats sidebar right
- **Responsive**: All values scale down on mobile via CSS variable overrides at 768px

## Routes

| URL | Description |
|-----|-------------|
| `/@username` | Public member profile (middleware rewrites to `/member/username`) |
| `/@username/edit` | Edit profile (name, username, bio, avatar, cover) |
| `/@username/settings` | Account settings (security, sessions, API keys) |
| `/@username/appearance` | Theme and accent color customization |
| `/@username/privacy` | Visibility toggles (public profile, show comments) |
| `/@username/social` | Social links management |
| `/@username/sponsor` | Sponsor page (markdown content) |
| `/@username/post/:id` | Single post detail page |
| `/en/community` | Community member listing |

## Post-Login Redirect

All auth flows redirect to `/@username` after success:
- Email/password login, Registration, 2FA verification, Magic link, OAuth callback, Passkey login
- Falls back to `/dashboard` when no username is available

### Username Generation
- Auto-generated from display name on registration (slugified: lowercase, hyphens, no special chars)
- If base slug is taken, appends random numeric suffix (e.g., `john-doe-42`)
- Stored as `username` field on User model (varchar(100), unique index)
- Included in all auth API responses (`userResource()`)

## Component Architecture

### Shared Components (`apps/next/src/components/profile/`)

| Component | Purpose |
|-----------|---------|
| `use-profile-theme.ts` | Hook returning `{ isDark, colors }` — single source of truth for brand tokens |
| `profile-card.tsx` | Card with 4 variants: `default`, `glass`, `elevated`, `inset` + hover glow |
| `profile-section.tsx` | Reusable page section wrapper with title, description, icon |
| `profile-tab-bar.tsx` | Horizontal scrollable tab navigation with active indicator |
| `profile-toggle.tsx` | Accessible toggle switch (`role="switch"`, `aria-checked`) with brand gradient |
| `profile-stat.tsx` | Animated stat display with IntersectionObserver count-up |
| `profile-header.tsx` | Cover image, avatar, name, bio, location, social links |
| `profile-sidebar.tsx` | Delegates to `ProfileTabBar` for owner navigation |
| `profile-edit-form.tsx` | Name/username/bio form with cover/avatar upload triggers |
| `avatar-upload-modal.tsx` | Circular crop modal (200px viewport, 400x400 output) |
| `cover-upload-modal.tsx` | Rectangular crop modal (820x200 viewport, 1640x400 output) |

### Profile Tab Navigation

When the profile owner views sub-pages, a horizontal tab bar appears below the header.

| Label | Route | Icon |
|-------|-------|------|
| Profile | `/@username` | `bx-user` |
| Edit Profile | `/@username/edit` | `bx-edit-alt` |
| Social Links | `/@username/social` | `bx-link` |
| Settings | `/@username/settings` | `bx-cog` |
| Appearance | `/@username/appearance` | `bx-palette` |
| Privacy | `/@username/privacy` | `bx-lock-alt` |
| Sponsor | `/@username/sponsor` | `bx-heart` |

### Responsive Behavior
- Desktop (>768px): full asymmetric grid, 1080px container, 280px cover, 140px avatar
- Mobile (<768px): single column, 200px cover, 100px avatar, -44px overlap, horizontal scroll tabs

## Profile Visibility

- Controlled by `public_profile_enabled` in user settings JSON (default: not set / private)
- **Public profile** (`public_profile_enabled = "true"`): visible to everyone
- **Private profile**: returns 403 "profile is private" to non-owners, 404 for nonexistent handles
- **Owner access**: profile owner always sees their own profile via optional auth token, even when private
- Backend checks `middleware.CurrentUser(c)` for owner identity on the public endpoint
- Frontend sends auth token with `fetchMemberProfile` so the backend can identify owners
- Frontend distinguishes "private" (lock icon) vs "not found" (user-x icon) based on error message
- `/api/public/community/members` only lists users with `public_profile_enabled = "true"`

## API Endpoints

| Method | Path | Auth | Response Shape |
|--------|------|------|---------------|
| GET | `/api/public/community/members` | No | `{members: Member[], total: number}` |
| GET | `/api/public/community/members/:handle` | Optional | `{profile: PublicProfile}` (auth allows owner to view private profile) |
| GET | `/api/public/community/members/:handle/posts` | No | `{posts: CommunityPost[]}` |
| GET | `/api/public/community/posts/:id` | No | `{post: CommunityPost}` (with embedded author fields) |
| GET | `/api/public/community/posts/:id/comments` | No | `{comments: PostComment[]}` |
| GET | `/api/public/community/posts/:id/related` | No | `{posts: CommunityPost[]}` |
| POST | `/api/community/posts` | Yes | `{post: CommunityPost}` |
| POST | `/api/community/posts/:id/comments` | Yes | `{comment: PostComment}` |
| POST | `/api/community/posts/:id/like` | Yes | `{liked: bool, likes_count: int}` |
| PUT | `/api/users/profile/visibility` | Yes | `{is_public: bool}` |
| POST | `/api/users/profile/avatar` | Yes | `{ok: true, avatar_url: string}` |
| POST | `/api/users/profile/cover` | Yes | `{ok: true, cover_url: string}` |
| PUT | `/api/users/profile` | Yes | `{ok: true, user: User}` |
| PUT | `/api/users/profile/social-links` | Yes | `{ok: true}` |
| PATCH | `/api/settings/profile` | Yes | `{ok: true}` (appearance, privacy toggles) |

## Profile Editing

### PUT /api/users/profile
Updates the authenticated user's name, username, and/or bio. All fields are optional.

**Request body:**
```json
{ "name": "New Name", "username": "new-slug", "bio": "Short bio text" }
```

**Validation:**
- `name`: max 255 characters, trimmed
- `username`: slugified (lowercase, hyphens, no special chars), max 100 chars, must be unique (409 if taken)
- `bio`: max 500 characters

**Frontend:** `apps/next/src/components/profile/profile-edit-form.tsx` — Edit form with cover/avatar click-to-change, name/username/bio fields, real-time slug validation, character counter, saves via PUT.

## Avatar Upload

Users can upload a profile avatar via `POST /api/users/profile/avatar` (multipart form-data).

### Backend
- **Field**: `avatar` (multipart file)
- **Optional crop params**: `crop_x`, `crop_y`, `crop_w`, `crop_h` (integers)
- **Validation**: max 5MB, jpeg/png/webp/gif only
- **Storage**: `uploads/avatars/{userID}-{timestamp}.{ext}` served via `/uploads` static route
- **DB**: Updates `users.avatar_url` column

### Frontend Component
- `apps/next/src/components/profile/avatar-upload-modal.tsx` — Crop/resize/position modal
- **Features**: circular crop viewport (200x200), drag to reposition, zoom slider (1x-3x), rotate buttons (90 deg), canvas export at 400x400 retina
- **Upload flow**: canvas → blob → FormData → POST → updates auth store `avatar_url`

## Cover Image Upload

Users can upload a profile cover image via `POST /api/users/profile/cover` (multipart form-data).

### Backend
- **Field**: `cover` (multipart file)
- **Validation**: max 5MB, jpeg/png/webp/gif only (same as avatar)
- **Storage**: `uploads/covers/{userID}-{timestamp}.{ext}`
- **DB**: Updates `users.cover_url` column (nullable text, added to User model)
- **userResource()**: includes `cover_url` when set

### Frontend Component
- `apps/next/src/components/profile/cover-upload-modal.tsx` — Rectangular crop modal
- **Features**: 820x200 viewport (responsive), drag to reposition, zoom slider (1x-3x), rotate buttons, canvas export at 1640x400 retina
- **Upload flow**: canvas → blob → FormData → POST → updates auth store `cover_url`

## User Dropdown Navigation

Both the app header (`AppHeader`) and marketing nav (`MarketingNav`) show a user dropdown for authenticated users. The dropdown includes:

| Item | Route | Condition |
|------|-------|-----------|
| Profile | `/@username` | Only when `username` exists |
| Settings | `/@username/settings` | Falls back to `/settings` if no username |
| Dashboard | `/dashboard` | Always shown (marketing nav only) |
| Subscription | `/subscription` | Always shown (app header only) |
| Sign out | — | Always shown |

The hamburger overlay menu (mobile) also shows a Profile link with avatar for logged-in users.

### Key Files
- `apps/next/src/components/layout/app-header.tsx` — Dashboard header with user dropdown
- `apps/next/src/components/layout/marketing-nav.tsx` — Marketing header with user dropdown + hamburger overlay

## CSS Architecture

Profile-specific CSS is in `apps/next/src/app/globals.css`:

### CSS Variables
- `--profile-cover-height`, `--profile-avatar-size`, `--profile-avatar-overlap`, `--profile-content-max`, `--profile-sidebar-width`
- All override at 768px breakpoint for mobile

### Keyframe Animations
- `profileSlideIn` — entrance slide from bottom
- `counterRoll` — stat counter roll-in
- `coverGrain` — animated noise texture overlay

### Utility Classes
- `.profile-grain` — grain overlay pseudo-element on cover images
- `.profile-card-glow` — hover glow + lift effect for cards

## Key Files

- `apps/next/src/app/[locale]/(marketing)/member/[handle]/layout.tsx` — Profile layout (Syne font, 1080px container, grain)
- `apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx` — Main profile (asymmetric grid, stats, feed)
- `apps/next/src/app/[locale]/(marketing)/member/[handle]/edit/page.tsx` — Edit Profile page
- `apps/next/src/app/[locale]/(marketing)/member/[handle]/settings/page.tsx` — Settings page
- `apps/next/src/app/[locale]/(marketing)/member/[handle]/appearance/page.tsx` — Appearance page
- `apps/next/src/app/[locale]/(marketing)/member/[handle]/privacy/page.tsx` — Privacy page
- `apps/next/src/app/[locale]/(marketing)/member/[handle]/social/page.tsx` — Social Links page
- `apps/next/src/app/[locale]/(marketing)/member/[handle]/sponsor/page.tsx` — Sponsor page (react-markdown)
- `apps/next/src/app/[locale]/(marketing)/member/[handle]/post/[postId]/page.tsx` — Post detail
- `apps/next/src/components/profile/` — All shared profile components (11 files)
- `apps/next/src/store/community.ts` — Zustand store
- `orch-ref/app/handlers/community_handler.go` — All community API handlers
- `orch-ref/app/handlers/community_routes.go` — Community route registration
- `apps/next/src/middleware.ts` — `/@handle` rewrite (lines 50-59)
- `apps/next/src/components/community/ShareButton.tsx` — Reusable share button component

## User Dropdown

The app-header dropdown shows 3 items: **Profile** (`/@handle`), **Settings** (`/@handle/settings`), **Sign out**. Subscription was removed to keep the dropdown focused.

## Activity Feed Filter

The profile activity feed supports grouped filtering by content type via a tab bar above the posts list.

### Filter Tabs
- **All** — shows all posts (default)
- **Posts** — regular posts (no skill/agent/workflow tag)
- **Skills** — posts tagged `skill`
- **Agents** — posts tagged `agent`
- **Workflows** — posts tagged `workflow`

Each tab shows a count of matching items. Active tab is color-coded to match the type's accent color.

### Implementation
- `feedFilter` state: `'all' | 'post' | 'skill' | 'agent' | 'workflow'`
- `feedCounts` computed from `rawPosts` using tag detection
- `displayPosts` filtered from `rawPosts` based on active filter

## Entity Sharing

Users can share notes, skills, agents, and workflows to their public profile.

### API Endpoints

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| POST | `/api/community/share` | Yes | Share an entity (upsert) |
| DELETE | `/api/community/share/:id` | Yes | Unshare an entity (soft delete) |
| GET | `/api/public/community/shared/:handle` | No | List shared entities for a user |

### Share Request Body

```json
{
  "entity_type": "skill",
  "entity_id": "uuid",
  "title": "My Skill",
  "description": "Does something useful",
  "content": "# Skill content...",
  "visibility": "public",
  "tags": ["go", "testing"],
  "icon": "bx-terminal",
  "color": "#00e5ff"
}
```

### Database

Table `shared_entities` with unique constraint on `(user_id, entity_type, entity_id)`. Supports upsert — re-sharing updates the existing entry. Soft delete via `deleted_at`.

### Frontend

- `ShareButton` component in `apps/next/src/components/community/ShareButton.tsx`
- Community store actions: `shareEntity()`, `unshareEntity()`, `fetchSharedEntities()`
- Shared entities displayed on `/@handle` profile under categorized sections
