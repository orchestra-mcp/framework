---
id: FEAT-DRU
kind: feature
priority: P1
project_slug: orchestra-ai
status: done
title: Redesign Team Switcher dialog UX
type: feature
---

# Redesign Team Switcher dialog UX

Simplify TeamSwitcher dialog to be switching-only. Move team management (edit, invite, members) into the existing Team Settings screen. Add a "Team Settings" separator item in the dialog and a "Create New Team" item with proper name+avatar flow.


---
**in-progress -> in-testing** (2026-03-17T11:30:21Z):
## Changes
- apps/flutter/lib/screens/tray/workspace_switcher.dart (redesigned TeamSwitcher: removed inline action buttons from _TeamRow, removed _IconAction widget, removed old create/edit/invite/members dialogs, added "Team Settings" and "Create New Team" items with separator, added showCreateTeamSheet bottom sheet)
- apps/flutter/lib/screens/settings/tabs/team_settings_tab.dart (new file — full team settings screen with team header, editable team name, members list with remove, invite bottom sheet, danger zone with delete team)
- apps/flutter/lib/screens/settings/settings_screen.dart (replaced placeholder _TeamSettingsTab with real TeamSettingsTab, added "Team" title mapping, added import)


---
**in-testing -> in-docs** (2026-03-17T11:38:05Z):
## Results
- apps/flutter/test/screens/tray/team_switcher_test.dart (6 tests: Team model validation, fromJson parsing for both nested and flat formats)
- apps/flutter/test/screens/settings/tabs/team_settings_tab_test.dart (24 tests: Team isOwner/isAdmin, Team.fromJson, Team.personal, TeamMember.fromJson, TeamMember constructor)

All 30 tests pass via `flutter test`.


---
**in-docs -> in-review** (2026-03-17T11:38:27Z):
## Docs
- docs/team-switcher-redesign.md (new — documents the dialog redesign, team settings screen, create team flow, routing, and empty state)


---
**Review (approved)** (2026-03-17T11:40:08Z): User approved the team switcher redesign.
