# Inline Comments on Profile Posts

## Overview

Each post card on the profile page has a collapsible inline comments section. Users can read and write comments without navigating to the post detail page.

## Behavior

1. **Comment button** shows the comment count. Clicking toggles the comments section.
2. **On expand**, comments are fetched from `GET /api/public/community/posts/:id/comments` and cached.
3. **Latest 3 comments** are shown inline with avatar, name, date, and content.
4. **"View all" link** appears when there are more than 3 comments, linking to the post detail page.
5. **Compact input** at the bottom: rounded pill input with Enter-to-submit and send button.
6. **On submit**, calls `addComment` store method then refetches comments to show the new one.

## State

- `expandedComments: Set<number>` — tracks which post IDs have expanded comments
- `inlineComments: Record<number, Comment[]>` — cached comments per post
- `inlineCommentText: Record<number, string>` — input text per post
- `commentSubmitting: number | null` — loading state for submit

## Files

- `apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx` — inline comments UI and logic
- `apps/next/src/store/community.ts` — `addComment` method
