# Community Activity Timeline

## Overview

The profile page has a Posts/Activity toggle. The Activity view shows a chronological timeline of the user's public actions grouped by date.

## Date Groups

- **Today** — items from today
- **Yesterday** — items from yesterday
- **This Week** — items from the last 7 days
- **Month Year** — older items grouped by month

## Activity Types

| Type | Icon | Color | Description |
|------|------|-------|-------------|
| post | bx-edit | cyan | Published a post |
| comment | bx-comment | purple | Left a comment |
| shared_note | bx-note | green | Shared a note |
| shared_skill | bx-code-alt | cyan | Shared a skill |
| shared_agent | bx-bot | amber | Shared an agent |
| shared_workflow | bx-git-merge | purple | Shared a workflow |

## API

`GET /api/public/community/members/:handle/activity?limit=20&offset=0`

Returns posts, comments, and shared content sorted by created_at desc.

## Files

- `apps/next/src/store/community.ts` — `ActivityItem` interface, `fetchActivity` method
- `apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx` — Posts/Activity toggle, activity timeline view
- `apps/web/internal/handlers/community.go` — `MemberActivity` handler
