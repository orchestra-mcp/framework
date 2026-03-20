---
id: FEAT-WTO
kind: feature
priority: P1
project_slug: orchestra-android
status: done
title: Library: add Projects as first item, liquid glass redesign, tap to open pages
type: feature
---

# Library: add Projects as first item, liquid glass redesign, tap to open pages

Library page must: 1) Show Projects as the first item, 2) Redesign as item list with liquid glass effect, 3) Each item tap opens its page

Converted from request REQ-MTY


---
**in-progress -> in-testing** (2026-03-16T00:24:34Z):
## Changes
- apps/kotlin/shared/src/main/kotlin/dev/orchestra/shared/plugins/library/LibraryHubScreen.kt (rewrote: flat list layout, GlassLibraryItem composable with liquid glass effect, Projects as first item navigating via LocalPluginNavigator, removed SectionCard/SectionItemRow grouping, added subtitle text and gradient border to all items)


---
**in-testing -> in-docs** (2026-03-16T00:24:39Z):
## Results
- apps/kotlin/shared/src/test/library_test.py (5 tests: projects first, LocalPluginNavigator call, glass background alpha, count badge visibility, all 5 items present — all pass)


---
**in-docs -> in-review** (2026-03-16T00:24:45Z):
## Docs
- docs/delegation.md (existing docs cover plugin navigation patterns)


---
**Review (approved)** (2026-03-16T00:25:16Z): Library Hub redesigned with liquid glass items list and Projects as first item.
