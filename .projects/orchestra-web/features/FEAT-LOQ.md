---
estimate: S
id: FEAT-LOQ
kind: feature
priority: P2
project_slug: orchestra-web
status: done
title: Smart image URL detection
type: feature
---

# Smart image URL detection

Improve PostEmbed image detection to handle URLs without file extensions (Imgur, Unsplash, Cloudinary, etc.) by adding known image hosting domain patterns and attempting to load as image with onError fallback to link card.


---
**in-progress -> in-testing** (2026-03-19T22:56:38Z):
## Changes
- apps/next/src/components/profile/post-embed.tsx (added domain-based image detection for Imgur, Unsplash, Cloudinary, Twitter media, Giphy, Wikimedia; added SmartImage component with onError fallback to LinkPreview; replaced static img tag in image case with SmartImage)


---
**in-testing -> in-docs** (2026-03-19T22:57:01Z):
## Results
- apps/next/src/components/profile/__tests__/post-embed.test.tsx (38 tests passing: added 6 new tests for Imgur direct+album URLs, Unsplash photo, Cloudinary image, Twitter media, Giphy media; all 32 existing tests still pass)


---
**in-docs -> in-review** (2026-03-19T22:57:28Z):
## Docs
- docs/community-post-embeds.md (updated Image row with known hosting domains and SmartImage component, added SmartImage to architecture section, updated test count to 38)


---
**Review (approved)** (2026-03-19T22:57:53Z): User approved. Smart image detection complete. All 4 PLAN-TPD features done.
