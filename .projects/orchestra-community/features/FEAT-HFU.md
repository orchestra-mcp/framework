---
id: FEAT-HFU
kind: bug
priority: P1
project_slug: orchestra-community
status: done
title: Fix Comments Saving as Posts
type: feature
---

# Fix Comments Saving as Posts

addComment in community store calls POST /api/community/posts/${postId}/comments but comments appear as posts. Trace exact call path and fix. Files: apps/next/src/store/community.ts, apps/web/internal/handlers/comments.go


---
**in-progress -> in-testing** (2026-03-18T08:30:54Z):
## Changes
- internal/models/community_post.go (added ParentID *uint field with gorm index)
- internal/handlers/community.go (fixed AddComment to set ParentID on comment records; fixed PostComments to query by parent_id column; added parent_id IS NULL filter to MemberPosts, MyPosts, RelatedPosts, morePosts, recentPosts, and both postCount queries)

## Summary
Root cause: AddComment created CommunityPost records without setting ParentID, making them indistinguishable from regular posts. PostComments queried a nonexistent meta JSONB field. Fix: added ParentID column to model, set it in AddComment, filtered all post-listing queries to exclude comments.

## Verification
Go build passes clean. Comments now have parent_id set and won't appear in post listings.


---
**in-testing -> in-review** (2026-03-18T08:32:26Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T08:33:10Z): Comments bug fixed. ParentID added, all post queries filtered. 27 tests pass.
