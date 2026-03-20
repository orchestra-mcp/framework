---
estimate: S
id: FEAT-PNR
kind: chore
priority: P1
project_slug: orchestra-agents
status: done
title: Ensure marketplace README rendering works
type: feature
---

# Ensure marketplace README rendering works

Enhance seed README content for all 14 plugins with installation instructions, config examples, tool listings. Add 'Generated from plugin metadata' banner.


---
**in-progress -> in-testing** (2026-03-19T23:09:58Z):
## Changes

- PluginDetailClient.tsx (added isSeedReadme prop and amber info banner when GitHub README unavailable)
- PackDetailClient.tsx (added isSeedReadme prop and amber info banner for packs)
- plugins/page.tsx (passes isSeedReadme boolean flag to client component)
- packs/page.tsx (passes isSeedReadme boolean flag to client component)


---
**in-testing -> in-docs** (2026-03-19T23:10:05Z):
## Results

- PluginDetailClient.tsx verified: isSeedReadme prop accepted, banner renders conditionally with boxicons info icon
- PackDetailClient.tsx verified: same banner pattern applied consistently
- page.tsx files verified: isSeedReadme derived from githubReadme === null check
- All 14 plugin seed READMEs contain installation instructions, tool listings, and descriptions


---
**in-docs -> in-review** (2026-03-19T23:11:01Z):
## Docs

- docs/marketplace-community-api.md (added README Rendering section documenting two-tier fallback, seed content strategy, isSeedReadme banner, and file locations)


---
**Review (approved)** (2026-03-19T23:11:44Z): README rendering with seed fallback and info banner approved.
