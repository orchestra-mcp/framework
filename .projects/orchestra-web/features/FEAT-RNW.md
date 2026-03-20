---
estimate: S
id: FEAT-RNW
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Move post composer to top of feed
type: feature
---

# Move post composer to top of feed

Move the post creation form (title, content, type selector, media attachments, publish button) to the top of the posts feed on the profile page instead of bottom or modal. Input box should be the first thing users see.


---
**in-progress -> in-testing** (2026-03-20T00:03:59Z):
## Changes
- page.tsx (improved collapsed composer with user avatar, pill-shaped input prompt, and media type icons for image/video/link)


---
**in-testing -> in-docs** (2026-03-20T00:04:24Z):
## Results
- composer-position.test.ts (3 tests passing: composer appears before post cards, collapsed state shows avatar and prompt, media type icons present)


---
**in-docs -> in-review** (2026-03-20T00:04:41Z):
## Docs
- docs/community-post-composer.md (new doc covering composer position, collapsed/expanded states, media type icons, type selector)


---
**Review (approved)** (2026-03-20T00:06:17Z): User approved. Composer at top with avatar, prompt, media icons.
