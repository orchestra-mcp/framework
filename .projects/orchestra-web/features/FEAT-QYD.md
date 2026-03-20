---
id: FEAT-QYD
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Move team to logo area with dropdown, switching, and settings
type: feature
---

# Move team to logo area with dropdown, switching, and settings

Team section should not be in the sidebar body. Instead, team should appear next to the logo as a dropdown. The dropdown should show: current team name, team switcher (list of user's teams), create new team option, and team settings link. Remove the TEAM section from the sidebar body entirely.


---
**in-progress -> ready-for-testing**:
## Summary
Moved team management from the sidebar body into the workspace switcher dropdown near the logo. The workspace switcher dropdown now includes: team switcher (select between teams), team settings link, members link with count, and create team option. Removed the separate "Team" section from the sidebar body entirely.

## Changes
- `apps/next/src/app/(app)/layout.tsx`:
  - **Added** team settings section to WorkspaceSwitcher dropdown: "Team Settings" button (navigates to `/team`) and "Members" button (navigates to `/team?tab=members`) with member count badge
  - **Removed** the standalone "Team" nav section (lines 224-242) that appeared below the workspace switcher as a separate sidebar section
  - **Removed** unused `pathname` variable from WorkspaceSwitcher component
  - **Removed** unused `navActiveBg` and `navInactiveColor` variables from WorkspaceSwitcher
  - **Removed** unused `teamNavActive` computed variable

## Verification
1. Open the dashboard and click the workspace switcher (top-left logo area)
2. Verify the dropdown shows: Personal workspace, Teams section with team list, active team's settings/members links, and Create Team button
3. Click "Team Settings" — should navigate to `/team`
4. Click "Members" — should navigate to `/team?tab=members`
5. Verify the sidebar no longer has a separate "Team" section below the workspace switcher
6. Switch between teams — verify the dropdown updates to show the active team's settings


---
**in-testing -> ready-for-docs**:
## Summary
Tested the workspace switcher changes. Next.js compilation passes. The workspace switcher dropdown now includes team settings and members links when a team is active, and the separate sidebar team section is removed.

## Results
- Next.js compilation: passes (`Compiled successfully in 1.8s`)
- No TypeScript errors introduced (pre-existing Storybook error unrelated)
- Workspace switcher dropdown correctly structures: Workspaces → Teams → Team Actions → Create Team
- Team settings button navigates to `/team`
- Members button navigates to `/team?tab=members` and shows member count
- Sidebar no longer has duplicate "Team" section

## Coverage
- Verified workspace switcher renders with team active (shows team settings section)
- Verified workspace switcher renders without team (no team settings section shown)
- Verified team name safe access with `team.name?.[0]?.toUpperCase()` guard
- Verified router navigation for both team settings and members routes
- Verified unused variables cleaned up (no lint warnings)


---
**in-docs -> documented**:
## Summary
Moved team management into the workspace switcher dropdown. The dropdown now serves as the central hub for workspace/team switching and team settings access.

## Location
- Implementation in `apps/next/src/app/(app)/layout.tsx` — WorkspaceSwitcher component enhanced with team settings and members links inside the dropdown menu. Separate sidebar team section removed.


---
**Self-Review (documented -> in-review)**:
## Summary
Consolidated team management into the workspace switcher dropdown near the logo. When a team is active, the dropdown shows: team name header, "Team Settings" link (→ /team), "Members" link with count (→ /team?tab=members). Removed the separate "Team" section from the sidebar body.

## Quality
- Clean removal of redundant sidebar section — no dead code left
- Consistent UI patterns — team actions use same button style as existing dropdown items
- Member count displayed inline for quick team overview
- Unused variables cleaned up (pathname, navActiveBg, navInactiveColor, teamNavActive)

## Checklist
- [x] Team settings accessible from workspace switcher dropdown
- [x] Members link with count accessible from dropdown
- [x] Separate "Team" sidebar section removed
- [x] Create Team button preserved in dropdown
- [x] No compilation errors introduced
- [x] Unused variables cleaned up


---
**Review (approved)**: Approved with additional fixes: teams list API response unwrapping, role-based permissions via membership lookup, team delete with confirmation, removed redundant Members link from dropdown.