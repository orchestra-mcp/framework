---
id: FEAT-ECT
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Admin sponsors community and GitHub handlers
type: feature
---

# Admin sponsors community and GitHub handlers

Implement 10 admin endpoints: sponsors CRUD, community post moderation (list/update/delete), GitHub issues (list, sync from API, list repos). All return 403 for non-admin. Part of PLAN-VFH.


---
**in-progress -> in-testing** (2026-03-16T21:10:41Z):
## Changes
- orch-ref/app/handlers/admin_external.go (new — 11 handlers: listSponsors, createSponsor, updateSponsor, deleteSponsor, listCommunityPosts, updateCommunityStatus, deleteCommunityPost, listGitHubIssues, syncGitHubIssues, deleteGitHubIssue, listGitHubRepos)
- orch-ref/app/handlers/admin_routes.go (updated community routes to /community/posts, added /github/repos route)
- orch-ref/app/handlers/admin_stubs.go (deleted — all stubs replaced with real implementations)


---
**in-testing -> in-docs** (2026-03-16T21:16:56Z):
## Results
- orch-ref/app/handlers/admin_external_test.go (27 tests — all passing)
  - Sponsors: TestListSponsors, TestListSponsors_SearchFilter, TestListSponsors_TierFilter, TestListSponsors_StatusFilter, TestCreateSponsor, TestCreateSponsor_MissingName, TestCreateSponsor_DuplicateSlug, TestUpdateSponsor, TestUpdateSponsor_NotFound, TestDeleteSponsor, TestDeleteSponsor_NotFound
  - Community: TestListCommunityPosts, TestListCommunityPosts_SearchFilter, TestListCommunityPosts_StatusFilter, TestUpdateCommunityStatus, TestUpdateCommunityStatus_InvalidStatus, TestUpdateCommunityStatus_NotFound, TestDeleteCommunityPost, TestDeleteCommunityPost_NotFound
  - GitHub: TestListGitHubIssues, TestListGitHubIssues_RepoFilter, TestListGitHubIssues_StateFilter, TestListGitHubIssues_TypeFilter, TestSyncGitHubIssues, TestDeleteGitHubIssue, TestDeleteGitHubIssue_NotFound, TestListGitHubRepos
- orch-ref/app/handlers/admin_routes_test.go (updated — fixed community paths, added github/repos route, replaced stub test with route registration test)


---
**in-docs -> in-review** (2026-03-16T21:17:25Z):
## Docs
- docs/admin-external-api.md (Sponsors CRUD, Community post moderation, GitHub issues cache endpoint documentation)


---
**Review (approved)** (2026-03-16T21:17:43Z): 11 handlers for sponsors, community, GitHub — all 27 tests passing. Final feature in PLAN-VFH. User approved.
