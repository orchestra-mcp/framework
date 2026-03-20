# Post Type Visual Differentiation

## Overview

Community posts can be tagged with a type (`skill`, `agent`, `workflow`) that renders a colored left border on the post card and a type badge next to the title. This provides visual scanning of post types in the feed.

## Post Types

| Type | Border Color | Badge Color | Tag |
|------|-------------|-------------|-----|
| Skill | `#00e5ff` (cyan) | Cyan on cyan/10 | `skill` |
| Agent | `#a900ff` (purple) | Purple on purple/10 | `agent` |
| Workflow | `#22c55e` (green) | Green on green/10 | `workflow` |

Posts without a recognized type tag render with no left border (default appearance).

## How It Works

1. **Tag extraction**: `getPostTypeFromTags(tags)` checks the post's `tags` array for recognized type values. Priority order: workflow > agent > skill.
2. **Border style**: `getPostTypeBorderStyle(post)` returns `{ borderLeft: '3px solid <color>' }` applied to the `ProfileCard` wrapper.
3. **Badge**: `getPostTypeBadge(post)` renders a small colored label (e.g., "Skill") next to the post title.

## Edit Mode

When editing a post, a type selector row appears with buttons for each type. Selecting a type adds the corresponding tag to the post's `tags` array via `updatePost()` in the community store. The active type button is highlighted with the type's color.

## Files

- `apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx` — `POST_TYPE_STYLES`, `getPostTypeFromTags`, `getPostTypeBorderStyle`, `getPostTypeBadge`, edit type selector
- `apps/next/src/store/community.ts` — `updatePost()` persists tags
- `apps/next/src/app/[locale]/(marketing)/member/[handle]/__tests__/post-type-borders.test.ts` — 14 unit tests
