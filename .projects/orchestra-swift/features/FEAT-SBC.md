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
status: in-testing
title: Theme System Bootstrap
updated_at: "2026-03-09T04:04:04Z"
version: 2
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
