---
estimate: M
id: FEAT-KZY
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Native social media embeds (Twitter/X, Instagram, Facebook)
type: feature
---

# Native social media embeds (Twitter/X, Instagram, Facebook)

Replace link-card fallbacks for Twitter/X, Instagram, and Facebook with native oEmbed rendering. Twitter: use platform.twitter.com/widgets.js to render tweets inline. Instagram: use instagram.com/embed.js for posts/reels. Facebook: use connect.facebook.net/en_US/sdk.js for posts/videos. All render natively on the profile without leaving the page.


---
**in-progress -> in-testing** (2026-03-19T22:45:01Z):
## Changes
- apps/next/src/components/profile/post-embed.tsx (replaced Twitter link card with TwitterEmbed using platform.twitter.com/widgets.js for native tweet rendering with dark mode support; replaced Instagram link card with InstagramEmbed using iframe embed with instagram.com/embed.js processing; added Facebook detection for posts/videos/photos/watch/reels/fb.watch and FacebookEmbed using facebook.com/plugins for native post and video embeds; added shared script loader with deduplication; added EmbedSkeleton loading state; exported detectEmbed, EmbedMatch, EmbedType for testing)


---
**in-testing -> in-docs** (2026-03-19T22:45:51Z):
## Results
- apps/next/src/components/profile/__tests__/post-embed.test.tsx (26 tests passing: YouTube 3 URL formats, Vimeo, Dailymotion, Twitch channel+video, Twitter+X.com, Instagram post+reel, Facebook post+video+watch+reel+fb.watch+photo, 7 image formats, 2 fallback cases)


---
**in-docs -> in-review** (2026-03-19T22:46:42Z):
## Docs
- docs/community-post-embeds.md (updated with native social media embed details: Twitter/X widgets.js, Instagram iframe+embed.js, Facebook plugins for posts and videos, architecture section with script loader and skeleton components)


---
**Review (approved)** (2026-03-19T22:47:02Z): User approved. Native social embeds for Twitter/X, Instagram, Facebook all working.
