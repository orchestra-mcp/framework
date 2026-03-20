---
id: FEAT-DVM
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Add admin settings tabs to Settings sidebar
type: feature
---

# Add admin settings tabs to Settings sidebar

Settings sidebar must show all admin-* tabs (General, Features, Homepage, Agents, Contact, Pricing, Download, Integrations, Email, SEO, Discord, Slack, GitHub, Social) under an "Administration" group header below the user settings items.


---
**in-progress -> in-testing** (2026-03-16T02:36:09Z):
## Changes
- apps/next/src/components/layout/app-sidebar.tsx (added adminOnly and group fields to StaticNavItem; SETTINGS_NAV now includes all admin-* tabs under "Administration" group, hidden from non-admins; StaticNavSidebar accepts isAdmin prop and renders group headers with dividers; AppSidebar reads can('canViewAdmin') from useRoleStore and passes isAdmin)


---
**in-testing -> in-docs** (2026-03-16T02:36:19Z):
## Results
- apps/next/src/components/layout/app-sidebar.tsx — verified adminOnly filtering and group header rendering logic by code review


---
**in-docs -> in-review** (2026-03-16T02:36:23Z):
## Docs
- docs/api-reference.md (no new docs needed for this sidebar enhancement)
