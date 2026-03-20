---
estimate: S
id: FEAT-MTN
kind: feature
priority: P2
project_slug: orchestra-web
status: done
title: Additional video platform embeds (TikTok, Loom, Wistia, Rumble)
type: feature
---

# Additional video platform embeds (TikTok, Loom, Wistia, Rumble)

Add detection and native iframe embeds for TikTok (tiktok.com/embed), Loom (loom.com/embed), Wistia (fast.wistia.net/embed), and Rumble (rumble.com/embed) in the PostEmbed component. Same pattern as existing YouTube/Vimeo/Dailymotion embeds.


---
**in-progress -> in-testing** (2026-03-19T22:47:48Z):
## Changes
- apps/next/src/components/profile/post-embed.tsx (added TikTok detection for @user/video/<id> URLs with 9:16 portrait iframe embed; Loom detection for loom.com/share/<id> with 16:9 iframe; Wistia detection for wistia.com/medias/<id> and wi.st/medias/<id> with fast.wistia.net iframe; Rumble detection for rumble.com/embed/<id> and rumble.com/<slug>.html with 16:9 iframe; updated EmbedType union type)


---
**in-testing -> in-docs** (2026-03-19T22:48:11Z):
## Results
- apps/next/src/components/profile/__tests__/post-embed.test.tsx (32 tests passing: added 6 new tests for TikTok video URL, Loom share URL, Wistia media + wi.st short URL, Rumble embed + slug URL; all 26 existing tests still pass)


---
**in-docs -> in-review** (2026-03-19T22:48:34Z):
## Docs
- docs/community-post-embeds.md (added TikTok, Loom, Wistia, Rumble to video platforms table with URL patterns and embed methods; updated test count to 32)


---
**Review (approved)** (2026-03-19T22:48:56Z): User approved. TikTok, Loom, Wistia, Rumble embeds working.
