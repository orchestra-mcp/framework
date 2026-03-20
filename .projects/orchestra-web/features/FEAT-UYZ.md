---
id: FEAT-UYZ
kind: bug
priority: P1
project_slug: orchestra-web
status: done
title: Fix community post publish not saving
type: feature
---

# Fix community post publish not saving

User reports that publishing a community post from the activity section does not save. The Publish button appears to not work or the post is lost after clicking.


---
**in-progress -> in-testing** (2026-03-18T20:25:54Z):
## Changes
- page.tsx — added publishError and publishSuccess state, restructured handlePublish with visible error feedback, success confirmation, and awaited fetchPosts to fix race condition


---
**in-testing -> in-review** (2026-03-18T20:26:43Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T20:27:18Z): User approved. Fixed silent error swallowing in community post publish with visible error/success feedback and awaited refresh.
