---
id: FEAT-PIK
kind: bug
priority: P1
project_slug: orchestra-web
status: done
title: Redesign profile sidebar to match clean profile design
type: feature
---

# Redesign profile sidebar to match clean profile design

The profile sidebar (FEAT-GZZ) looks disconnected and doesn't match the design. Issues: card-like background creates a boxy appearance, "ACCOUNT" header looks generic, the sidebar doesn't integrate well with the profile cover/content area. Need to redesign as a clean minimal vertical nav without card background, better visual integration with the profile page.

Reported against feature FEAT-GZZ


---
**in-progress -> in-testing** (2026-03-17T18:15:51Z):
## Changes
- apps/next/src/components/profile/profile-sidebar.tsx (complete rewrite: replaced card-style vertical sidebar with clean horizontal tab bar navigation — no background, no "ACCOUNT" header, uses bottom border indicator for active tab, scrollable on mobile)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/layout.tsx (replaced flex sidebar+content layout with vertical stack: horizontal tab nav on top, full-width content below, removed unused theme imports)


---
**in-testing -> in-review** (2026-03-17T18:20:31Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-17T18:21:07Z): Sidebar redesigned from vertical card to horizontal tab bar. Clean, integrated design. 27/27 tests pass.
