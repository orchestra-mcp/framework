---
id: FEAT-EOO
kind: chore
priority: P1
project_slug: orchestra-web
status: done
title: Remove AI Copilot settings tab
type: feature
---

# Remove AI Copilot settings tab




---
**in-progress -> in-testing** (2026-03-16T02:40:03Z):
## Changes
- apps/next/src/app/(app)/settings/page.tsx (removed useChatStore/CopilotDockMode/PromptCardEditor/PromptCard imports; removed 'copilot' from Tab type; removed CopilotSettingsTab render block; removed CopilotSettingsTab function and DOCK_MODES/ICON_STYLES/CHAT_MODES_LIST constants)
- apps/next/src/components/layout/app-sidebar.tsx (removed AI Copilot item from SETTINGS_NAV; fixed Rules of Hooks violation by moving settings/admin early returns to after all hooks; rebuilt ADMIN_NAV with all real admin pages — users/roles/teams/posts/pages/docs/categories/community/contact/issues/marketplace/sponsors/notifications — removed settings tab links from admin nav)


---
**in-testing -> in-docs** (2026-03-16T02:40:08Z):
## Results
- apps/next/src/app/(app)/settings/page.tsx — verified copilot tab render removed, imports cleaned
- apps/next/src/components/layout/app-sidebar.tsx — verified hooks order fixed, admin nav rebuilt


---
**in-docs -> in-review** (2026-03-16T02:40:13Z):
## Docs
- docs/api-reference.md (no new docs needed)
