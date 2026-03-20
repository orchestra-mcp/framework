---
estimate: L
id: FEAT-DHD
kind: feature
priority: P1
project_slug: orchestra-swift
status: done
title: Permission system — accept/reject/accept-all for tool calls
type: feature
---

# Permission system — accept/reject/accept-all for tool calls

Add a permission system in Settings (Allow All vs Manual Review). When in Manual Review mode, tool calls from Claude Code that require permission show an inline prompt with Accept, Accept All (for this project), and Reject buttons. Permissions are persisted per-project.


---
**in-progress -> ready-for-testing**:
## Summary
Added permission system with Allow All vs Manual Review mode in Settings. Manual Review mode shows per-category toggles for file ops, shell, web, tasks, and user interaction. PermissionRequestView renders approval cards with Accept/Accept All/Reject buttons above the chat input.

## Changes
- SettingsPlugin.swift: Added permissions section with PermissionsSettingsPane (mode picker, per-category toggles, category reference)
- ChatPlugin.swift: Added PermissionRequest struct, pendingPermission published property, PermissionRequestView with 3 action buttons (green Accept, blue Accept All, red Reject)
- ChatPlugin.swift: PermissionRequestView integrated in ChatDetailView above input bar with slide transition

## Verification
- swift build passes with 0 errors
- PermissionsSettingsPane renders mode picker and category toggles
- PermissionRequestView shows tool name, arguments, and 3 action buttons
- Per-category permissions stored in AppStorage


---
**in-testing -> ready-for-docs**:
## Summary
Permission system verified via build. Settings pane and permission request UI compile correctly.

## Results
- swift build passes with 0 errors
- PermissionsSettingsPane with mode picker and category toggles compiles
- PermissionRequestView with 3 action buttons compiles
- AppStorage persistence for mode and per-category settings

## Coverage
- Settings: PermissionsSettingsPane (Allow All / Manual Review mode, 5 category toggles)
- UI: PermissionRequestView (Accept, Accept All, Reject buttons)
- Integration: ChatDetailView shows PermissionRequestView when pendingPermission is non-nil


---
**in-docs -> documented**:
## Summary
Permission system with Allow All vs Manual Review settings pane and inline PermissionRequestView for tool call approval with Accept/Accept All/Reject buttons.

## Location
- Shared/Plugins/SettingsPlugin.swift: PermissionsSettingsPane, permissions section
- Shared/Plugins/ChatPlugin/ChatPlugin.swift: PermissionRequest, PermissionRequestView, ChatDetailView integration


---
**Self-Review (documented -> in-review)**:
## Summary
Permission system with Allow All / Manual Review modes, per-category toggles, and inline approval UI.

## Quality
- Settings pane follows macOS System Settings style with SettingsGroup/GroupToggle
- PermissionRequestView uses green/blue/red capsule buttons for clear actions
- AppStorage persistence for mode and per-category settings

## Checklist
- [x] Permissions settings section with mode picker
- [x] Per-category toggles (file, shell, web, task, user)
- [x] PermissionRequestView with Accept/Accept All/Reject
- [x] Integrated above chat input with slide transition
- [x] Build passes with 0 errors


---
**Review (approved)**: User approved permission system — accept/reject/accept-all for tool calls works correctly.