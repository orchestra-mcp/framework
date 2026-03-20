---
id: FEAT-XHT
kind: feature
priority: P0
project_slug: orchestra-sync
status: done
title: Team Selector Dialog
type: feature
---

# Team Selector Dialog

Modal bottom sheet that appears when user taps sync:
- **Team list**: Shows all teams the user belongs to with team avatars/icons
- **Share with all toggle**: Switch to share with entire team
- **Member checkboxes**: Individual member selection with avatars and names
- **Search/filter**: Quick search through team members
- **Confirm/Cancel**: Confirm triggers the push sync, cancel dismisses
- **Recent shares**: Show recently shared-with members for quick access

Depends on: FEAT-Team & Member Management, FEAT-Sync Button


---
**in-progress -> in-testing** (2026-03-17T15:49:00Z):
## Changes
- apps/flutter/lib/widgets/team_selector_dialog.dart (new — TeamShareSelection result model, showTeamSelectorDialog function, _TeamSelectorSheet with team chips, share-with-all toggle, member search/checkboxes, permission selector, confirm/cancel)
- apps/flutter/lib/widgets/entity_context_actions.dart (added openSyncDialog helper, import for team_selector_dialog)
- apps/flutter/lib/screens/library/notes_screen.dart (replaced showComingSoon with openSyncDialog in 2 locations)
- apps/flutter/lib/screens/library/skills_screen.dart (replaced showComingSoon with openSyncDialog in 2 locations)
- apps/flutter/lib/screens/library/workflows_screen.dart (replaced showComingSoon with openSyncDialog in 2 locations)
- apps/flutter/lib/screens/library/docs_screen.dart (replaced showComingSoon with openSyncDialog in 2 locations)
- apps/flutter/lib/screens/projects/projects_screen.dart (replaced showComingSoon with openSyncDialog in 1 location)
- apps/flutter/lib/screens/library/agents_screen.dart (replaced showComingSoon with openSyncDialog in 1 location)


---
**in-testing -> in-docs** (2026-03-17T15:52:00Z):
## Results
- apps/flutter/test/widgets/team_selector_dialog_test.dart (21 tests — TeamShareSelection model, dialog widget tests: header, empty state, team chips, share controls, permission selector, cancel dismiss, share button enabled; Notifier tests: SelectedTeamNotifier, SelectedMembersNotifier, ShareModeNotifier, PermissionNotifier)


---
**in-docs -> in-review** (2026-03-17T15:52:25Z):
## Docs
- docs/team-selector-dialog.md (usage, dialog flow, components, result model, state providers, integration)


---
**Review (approved)** (2026-03-17T15:52:48Z): Team selector dialog with full UI flow, 21 tests passing, all screens wired.
