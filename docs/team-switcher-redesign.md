# Team Switcher Dialog Redesign

## Overview

The team switcher dialog was redesigned to separate **team switching** from **team management**. The dialog is now streamlined for quick switching, while full team management (members, invites, editing) lives in the dedicated Team Settings screen.

## Changes

### Team Switcher Dialog (`workspace_switcher.dart`)

**Before:** Each team row had inline icon buttons for Members, Invite, Edit, plus a checkmark for active team. The dialog also had a Create Team button in the header.

**After:** Each team row shows only the avatar, name, member count/role, and a checkmark for the active team. Below the team list:

1. **Divider**
2. **Team Settings** — navigates to `/settings/team`
3. **Create New Team** — opens a bottom sheet with name field

### Team Settings Screen (`team_settings_tab.dart`)

The placeholder "coming soon" was replaced with a full settings screen at `/settings/team`:

- **Team header** — large avatar, team name, plan, role, member count
- **Editable team name** — inline text field + Save button (admin/owner only)
- **Members section** — list of all members with avatar, name, email, role badge, and remove button (admin only)
- **Invite** — button opens a bottom sheet with email + role dropdown
- **Danger zone** — Delete Team option (owner only) with confirmation dialog

### Create Team Flow

The old `AlertDialog` with just a text field was replaced with a proper bottom sheet (`showCreateTeamSheet`) featuring:

- Drag handle
- Team name text field with group icon
- Full-width Create button with loading state

## Routing

The Team Settings screen is accessible via:
- **Team Switcher dialog** > "Team Settings" item
- **Settings menu** > Team (route: `/settings/team`)

## Empty State

When no team is selected (personal workspace), the Team Settings screen shows an empty state with a "Create Team" button.
