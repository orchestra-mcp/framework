---
id: FEAT-PMW
kind: chore
priority: P1
project_slug: orchestra-web-gate
status: done
title: Remove devSeed fallbacks from other stores
type: feature
---

# Remove devSeed fallbacks from other stores

Remove devSeed guard blocks from roles.ts (10), community.ts (19), settings.ts (9), dashboard.ts (1), projects.ts (4), features.ts (4), workspaces.ts (4), preferences.ts (3), agents/page.tsx (1), skills/page.tsx (1). All are dead code that never triggers. Part of PLAN-OUT.


---
**in-progress -> in-testing** (2026-03-17T06:32:41Z):
## Changes
- apps/next/src/store/roles.ts (removed 9 devSeed guards)
- apps/next/src/store/community.ts (removed 3 devSeed constants + 9 guards)
- apps/next/src/store/settings.ts (removed 9 devSeed guards)
- apps/next/src/store/dashboard.ts (removed 1 devSeed guard)
- apps/next/src/store/projects.ts (removed 4 devSeed guards)
- apps/next/src/store/features.ts (removed 4 devSeed guards)
- apps/next/src/store/workspaces.ts (removed 4 devSeed guards)
- apps/next/src/store/preferences.ts (removed 3 devSeed guards)
- apps/next/src/app/(app)/agents/page.tsx (removed 1 devSeed guard)
- apps/next/src/app/(app)/skills/page.tsx (removed 1 devSeed guard)

Total: 48 devSeed occurrences removed, 0 remaining


---
**in-testing -> in-docs** (2026-03-17T06:37:00Z):
## Results
- apps/next/src/store/roles.ts — 0 devSeed references (was 9)
- apps/next/src/store/community.ts — 0 devSeed references (was 12)
- apps/next/src/store/settings.ts — 0 devSeed references (was 9)
- apps/next/src/store/dashboard.ts — 0 devSeed references (was 1)
- apps/next/src/store/projects.ts — 0 devSeed references (was 4)
- apps/next/src/store/features.ts — 0 devSeed references (was 4)
- apps/next/src/store/workspaces.ts — 0 devSeed references (was 4)
- apps/next/src/store/preferences.ts — 0 devSeed references (was 3)
- apps/next/src/app/(app)/agents/page.tsx — 0 devSeed references (was 1)
- apps/next/src/app/(app)/skills/page.tsx — 0 devSeed references (was 1)

Verification: ESLint passes (0 warnings/errors), TypeScript check shows 0 errors in modified files, dart analyze shows 0 errors in Flutter API layer. Total 48 devSeed occurrences removed across 10 files, 0 remaining in codebase.


---
**in-docs -> in-review** (2026-03-17T06:37:24Z):
## Docs
- docs/devseed-removal.md (summary of all 48 devSeed removals across 10 files, impact analysis)


---
**Review (approved)** (2026-03-17T06:38:53Z): All 48 devSeed occurrences removed from 10 files. Lint and TypeScript checks pass. Also fixed updateAdminSetting compilation errors in Flutter API layer.
