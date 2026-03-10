---
created_at: "2026-03-09T06:48:50Z"
description: Extend global search (CMD+K spotlight) and the Go backend search API to include Plans and Wiki docs alongside the existing Projects, Features, and Notes results.
id: FEAT-RMN
kind: feature
priority: P1
project_id: orchestra-web
status: done
title: Add Plans and Wiki to global search (spotlight + backend)
updated_at: "2026-03-09T07:09:10Z"
version: 10
---

# Add Plans and Wiki to global search (spotlight + backend)

Extend global search (CMD+K spotlight) and the Go backend search API to include Plans and Wiki docs alongside the existing Projects, Features, and Notes results.


---
**in-progress -> in-testing** (2026-03-09T06:55:02Z):
## Changes
- apps/web/internal/handlers/search.go (added plans and docs search in Search handler with LIKE queries on Plan.title/description/plan_id and Doc.title/body/category; added plans and docs to Suggestions handler returning top 3 recent each; added plans and docs to AiSearch context builder with plan/doc types in AI prompt)
- apps/next/src/app/(app)/layout.tsx (added searchPlansRef + searchDocsRef refs; spotlight data loading now fetches plans via list_plans MCP and docs via /api/docs; localSearch now matches plans by title/id and docs by name/folder; mapSearchResults handles plan and doc icon types; AI search prompt updated to include plan/doc types; categories array extended with Plans and Wiki entries)


---
**in-testing -> in-docs** (2026-03-09T06:56:32Z):
## Results
- apps/web/internal/handlers/search_test.go (19 tests all passing: TestSearch_EmptyQuery, TestSearch_FindsProjects, TestSearch_FindsFeatures, TestSearch_FindsNotes, TestSearch_CrossTypeSearch, TestSearch_CaseInsensitive, TestSearch_LimitParam, TestSearch_FeatureIDSearch, TestSearch_Suggestions, TestSearch_AiSearch, TestSearch_AiSearch_EmptyQuery, TestSearch_FindsPlans, TestSearch_FindsPlansByID, TestSearch_FindsDocs, TestSearch_FindsDocsByCategory, TestSearch_CrossTypeWithPlansAndDocs, TestSearch_SuggestionsIncludePlansAndDocs, TestSearch_AiSearchIncludesPlansAndDocs, TestSearch_TeamScope)


---
**in-docs -> in-review** (2026-03-09T06:58:28Z):
## Docs
- docs/global-search.md (updated — added plans and wiki docs to all sections: category grouping, navigation URLs, search/suggestions/AI endpoints, types param default, file table test count)


---
**Review (needs-edits)** (2026-03-09T07:00:59Z): Plans and wiki results appear in search but display without title — need to fix title rendering


---
**in-progress -> in-testing** (2026-03-09T07:03:48Z):
## Changes

- layout.tsx fixed wiki docs fetch with correct field mapping
- layout.tsx fixed plans fetch to use first project id


---
**in-testing -> in-docs** (2026-03-09T07:04:02Z):
## Results

- search_test.go 19 tests all passing after fix


---
**in-docs -> in-review** (2026-03-09T07:04:10Z):
## Docs

- docs/global-search.md already updated in prior iteration with plans and wiki docs coverage


---
**Review (approved)** (2026-03-09T07:09:10Z): Approved — plans and wiki now searchable with correct titles
