# Community Post Detail Page

## Route

`/@{handle}/post/{id}` or `/@{handle}/post/{id}-{slug}`

## Features

### Post Card
- Type-specific colored left border (skill=cyan, agent=purple, workflow=green)
- Type badge label next to title
- Author avatar, name, handle, date
- Markdown content via MarkdownRenderer
- Media embeds: URLs in content and media field auto-render via PostEmbed (videos, images, social, links)
- Tags display
- Like button (authenticated) + comment count

### Comments Section
- List of comments with avatar, name, date, content
- "Write a comment" textarea for authenticated users
- Real-time comment posting via addComment store method

### Related Posts
- Up to 5 related posts by shared tags
- Linked cards to other post detail pages

## API Endpoints
- `GET /api/public/community/posts/:id` — fetch post
- `GET /api/public/community/posts/:id/comments` — fetch comments
- `POST /api/community/posts/:id/comments` — add comment (auth required)
- `POST /api/community/posts/:id/like` — toggle like (auth required)
- `GET /api/public/community/posts/:id/related` — related posts

## Files
- `apps/next/src/app/[locale]/(marketing)/member/[handle]/post/[slug]/page.tsx`
- `apps/next/src/components/profile/post-embed.tsx`
- `apps/next/src/store/community.ts`
