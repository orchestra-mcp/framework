---
estimate: M
id: FEAT-XEL
kind: feature
priority: high
project_slug: orchestra-web
status: done
title: PostEmbed component and enhanced media rendering
type: feature
---

# PostEmbed component and enhanced media rendering

Create PostEmbed component supporting YouTube, Vimeo, Dailymotion, Twitch, Twitter/X, Instagram, images, and link cards. Add media attachment buttons to composer toolbar.


---
**in-progress -> in-testing** (2026-03-19T22:05:34Z):
## Changes
- apps/next/src/components/profile/post-embed.tsx (new file — universal PostEmbed component supporting YouTube, Vimeo, Dailymotion, Twitch, Twitter/X, Instagram, images, and link cards with favicons)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx (imported PostEmbed, added media attachment toolbar buttons for image/video/link, added inline media URL input field, replaced inline media rendering with PostEmbed component)


---
**in-testing -> in-docs** (2026-03-19T22:09:59Z):
## Results
- apps/next/src/components/profile/__tests__/post-embed.test.tsx (20 tests, all passing — covers YouTube, youtu.be, Vimeo, Dailymotion, Twitch channel/video, Twitter, x.com, Instagram post/reel, jpg/png/webp/gif/svg/avif images, image with query params, generic link, bare domain)


---
**in-docs -> in-review** (2026-03-19T22:10:19Z):
## Docs
- docs/community-post-embeds.md (new — documents PostEmbed component, supported platforms table, usage example, and composer integration)


---
**Review (approved)** (2026-03-19T22:10:52Z): PostEmbed component with 8 platform types, composer media buttons, 20 passing tests.
