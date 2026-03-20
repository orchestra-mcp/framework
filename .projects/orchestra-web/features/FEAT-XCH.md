---
id: FEAT-XCH
kind: chore
priority: P1
project_slug: orchestra-web
status: done
title: Single-domain Caddyfile + simplify Next.js to Dashboard/Settings/Subscription
type: feature
---

# Single-domain Caddyfile + simplify Next.js to Dashboard/Settings/Subscription

Revert Caddyfile from 2-domain to single orchestra-mcp.dev with path-based routing. Simplify Next.js app pages to only Dashboard (community profile), Settings, Subscription, and cli-auth. Delete all other app pages (projects, notes, agents, workflows, etc.).


---
**in-progress -> in-testing** (2026-03-17T09:36:06Z):
## Changes
- scripts/deploy/Caddyfile (rewritten to single-domain orchestra-mcp.dev with path-based routing)
- apps/next/.env.production (NEXT_PUBLIC_API_URL empty for same-origin, GATE_URL updated)
- apps/next/src/app/(app)/layout.tsx (replaced AppShell with MarketingNav + MarketingFooter)
- apps/next/src/app/(app)/dashboard/page.tsx (new — community profile editor page)
- apps/next/src/components/layout/app-icon-bar.tsx (simplified to dashboard + settings + subscription)
- apps/next/src/components/layout/app-sidebar.tsx (simplified to settings-only static nav)
- apps/next/src/hooks/useSidebarData.ts (stripped to settings/dashboard detection only)
- apps/next/src/components/layout/app-header.tsx (made team, onSearch, tunnelStatus optional)
- apps/next/src/app/[locale]/(auth)/login/page.tsx (redirect to /dashboard)
- apps/next/src/app/[locale]/(auth)/register/page.tsx (redirect to /dashboard)
- apps/next/src/app/auth/oauth-callback/page.tsx (redirect to /dashboard)
- apps/next/src/app/[locale]/(auth)/two-factor/page.tsx (redirect to /dashboard)
- apps/next/src/app/[locale]/(auth)/verify-otp/page.tsx (redirect to /dashboard)
- apps/next/src/components/layout/marketing-nav.tsx (links to /dashboard)
- apps/next/src/app/[locale]/(marketing)/community/page.tsx (fixed members undefined error)
- docs/flutter-web-removal.md (updated architecture docs)
- Deleted 17 directories: activity/, agents/, delegations/, devtools/, docs/, my-tasks/, notes/, notifications/, onboarding/, projects/, repos/, skills/, team/, terminal/, tunnels/, wiki/, workflows/


---
**in-testing -> in-docs** (2026-03-17T09:36:53Z):
## Results
- apps/next build verification: `npx next build` compiles successfully (only pre-existing BubbleButton.tsx type error in shared AI component, unrelated to our changes)
- Grep verification: No broken imports referencing deleted directories (projects, notes, agents, workflows, etc.)
- Grep verification: No references to removed components (useSidebarData, useDelegationsStore, useTunnelConnection, useMCP, SearchSpotlight, SmartActionBar, CreateItemModal, CreateProjectWizard, WelcomeScreen) in app layout
- apps/next/src/app/(app)/ now contains only: dashboard/, settings/, subscription/, cli-auth/, layout.tsx
- All auth redirects verified: login, register, oauth-callback, two-factor, verify-otp all redirect to /dashboard
- Caddyfile verified: single orchestra-mcp.dev domain with path-based routing
- Community page: fixed members.length TypeError (defaulted to empty array)


---
**in-docs -> in-review** (2026-03-17T09:36:58Z):
## Docs
- docs/flutter-web-removal.md (updated with single-domain architecture, marketing layout, simplified pages list)


---
**Review (approved)** (2026-03-17T09:37:30Z): User approved all changes: single-domain Caddyfile, marketing layout for app pages, new dashboard page, 17 deleted directories, auth redirects, community page fix.
