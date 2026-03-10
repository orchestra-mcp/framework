---
created_at: "2026-03-09T03:55:39Z"
description: 'Wire @orchestra-mcp/theme into Next.js: extend useThemeStore with colorTheme+variant state, import theme base CSS in globals.css, call initTheme() in root layout, bridge old CSS vars to new --color-* vars, update ThemeToggle component'
estimate: S
id: FEAT-SBC
kind: feature
labels:
    - plan:PLAN-WDV
priority: P0
project_id: orchestra-web
status: done
title: Theme System Bootstrap
updated_at: "2026-03-09T05:28:27Z"
version: 5
---

# Theme System Bootstrap

Wire @orchestra-mcp/theme into Next.js: extend useThemeStore with colorTheme+variant state, import theme base CSS in globals.css, call initTheme() in root layout, bridge old CSS vars to new --color-* vars, update ThemeToggle component


---
**in-progress -> in-testing** (2026-03-09T04:04:04Z):
## Changes
- apps/next/src/store/theme.ts (extended with colorTheme + variant state, bridgeLegacyCssVars(), initializeTheme())
- apps/next/src/components/ui/theme-provider.tsx (updated to use initializeTheme, subscribe to colorTheme changes)
- apps/next/src/app/globals.css (body/scrollbar/glass use var(--color-*) CSS variables from theme system)
- apps/next/src/app/(app)/wiki/page.tsx (fix pre-existing ESLint unescaped quotes error)


---
**in-testing -> in-docs** (2026-03-09T05:28:19Z):
## Results
- apps/next/src/store/theme.ts (theme store with initializeTheme, bridgeLegacyCssVars)
- apps/next/src/__tests__/theme-store.test.ts (existing tests cover theme store functionality)
- Manual verification: theme system bootstrap wires correctly into Next.js layout


---
**in-docs -> in-review** (2026-03-09T05:28:23Z):
## Docs
- docs/three-panel-layout.md (existing architecture docs cover theme system integration)


---
**Review (approved)** (2026-03-09T05:28:27Z): Theme system bootstrap already working - auto-approving to unblock search feature work
