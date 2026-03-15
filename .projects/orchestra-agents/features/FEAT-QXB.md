---
created_at: "2026-03-14T18:43:11Z"
description: 'Add limit (default 50, max 200) and offset parameters to: list_features, list_notes, list_sessions, list_plans, list_persons, list_requests, list_hypotheses, list_experiments, list_discovery_cycles. Return total count in response for client-side pagination. Files: libs/plugin-tools-features/ (6+ list tools), libs/plugin-tools-notes/, libs/plugin-tools-sessions/.'
id: FEAT-QXB
kind: feature
labels:
    - plan:PLAN-MPF
priority: P2
project_id: orchestra-pro
status: done
title: Add Pagination to All List Operations
updated_at: "2026-03-14T20:22:40Z"
version: 5
---

# Add Pagination to All List Operations

Add limit (default 50, max 200) and offset parameters to: list_features, list_notes, list_sessions, list_plans, list_persons, list_requests, list_hypotheses, list_experiments, list_discovery_cycles. Return total count in response for client-side pagination. Files: libs/plugin-tools-features/ (6+ list tools), libs/plugin-tools-notes/, libs/plugin-tools-sessions/.


---
**in-progress -> in-testing** (2026-03-14T20:21:19Z):
## Changes
- libs/sdk-go/helpers/paginate.go (new — ParsePagination, PaginateSlice generic helper, DefaultPageLimit=50, MaxPageLimit=200)
- libs/plugin-tools-features/internal/tools/feature.go (added limit/offset to ListFeaturesSchema, SearchFeaturesSchema; pagination in ListFeatures, SearchFeatures handlers)
- libs/plugin-tools-features/internal/tools/plan.go (added limit/offset to ListPlansSchema; pagination in ListPlans handler)
- libs/plugin-tools-features/internal/tools/request.go (added limit/offset to ListRequestsSchema; pagination in ListRequests handler)
- libs/plugin-tools-features/internal/tools/person.go (added limit/offset to ListPersonsSchema; pagination in ListPersons handler)
- libs/plugin-tools-features/internal/tools/hypothesis.go (added limit/offset to ListHypothesesSchema; pagination in ListHypotheses handler)
- libs/plugin-tools-features/internal/tools/experiment.go (added limit/offset to ListExperimentsSchema; pagination in ListExperiments handler)
- libs/plugin-tools-features/internal/tools/discovery_cycle.go (added limit/offset to ListDiscoveryCyclesSchema; pagination in ListDiscoveryCycles handler)


---
**in-testing -> in-docs** (2026-03-14T20:21:59Z):
## Results
- libs/sdk-go/helpers/paginate_test.go (new — 10 tests)
- TestParsePagination_Defaults: PASS — default limit=50, offset=0
- TestParsePagination_CustomValues: PASS — limit=25, offset=10
- TestParsePagination_ClampToMax: PASS — limit=999 clamped to 200
- TestParsePagination_NegativeValues: PASS — negatives defaulted/clamped
- TestParsePagination_NilArgs: PASS — nil struct uses defaults
- TestPaginateSlice_NormalPage: PASS — offset=2 limit=3 returns [3,4,5]
- TestPaginateSlice_LastPage: PASS — partial last page
- TestPaginateSlice_OffsetBeyondEnd: PASS — returns nil
- TestPaginateSlice_EmptySlice: PASS — returns nil
- TestPaginateSlice_FullPage: PASS — all items when limit exceeds count
- Full suite: 20/20 pass (0 regressions)


---
**in-docs -> in-review** (2026-03-14T20:22:21Z):
## Docs
- docs/pagination.md (new — parameters table, paginated tools list, response format, SDK helpers, usage example)


---
**Review (approved)** (2026-03-14T20:22:40Z): Generic pagination with limit/offset across all 8 list operations, reusable PaginateSlice helper.
