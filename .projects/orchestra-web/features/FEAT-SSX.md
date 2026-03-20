---
id: FEAT-SSX
kind: feature
priority: P2
project_slug: orchestra-web
status: done
title: Replace native selects with searchable dropdown
type: feature
---

# Replace native selects with searchable dropdown

All select elements across the project should use the SearchableSelect component instead of native HTML select elements. Must support search/filter.

Converted from request REQ-RUM

---
**todo -> in-progress** (2026-03-18T21:20:00Z):

**in-progress -> in-testing** (2026-03-18T21:35:00Z):
## Changes
- apps/next/src/components/ui/searchable-select.tsx (new: SearchableSelect component with search/filter, keyboard navigation, click-outside close, CSS variable theming)
- apps/next/src/components/projects/FilterBar.tsx (replaced 4 native selects: status, priority, kind, assignee)
- apps/next/src/app/(app)/settings/page.tsx (replaced 3 native selects: gender, timezone, language)
- apps/next/src/components/layout/create-item-modal.tsx (replaced 2 native selects: featureKind, priority)
- apps/next/src/components/dashboard/widgets/BurndownWidget.tsx (replaced 1 native select: project)
- apps/next/src/components/profile/settings-content.tsx (replaced 1 native select: platform)
- apps/next/src/app/[locale]/(marketing)/issues/page.tsx (replaced 1 native select: repo filter)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/social/page.tsx (replaced 1 native select: platform)

---
**in-testing -> in-docs** (2026-03-18T21:42:00Z):
## Results
- apps/next/src/components/ui/__tests__/searchable-select.test.ts (13 tests: filtering — empty search, label case-insensitive, value match, no results, partial strings, case insensitive; timezone filtering — region, city, continent, partial match; option structure — value/label, disabled preservation; search threshold)

All 13/13 tests passing.

---
**in-docs -> in-review** (2026-03-18T21:43:00Z):
## Docs
- docs/searchable-select.md