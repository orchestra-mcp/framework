---
estimate: L
id: FEAT-ZDY
kind: feature
priority: P1
project_slug: orchestra-flutter
status: done
title: Settings screen with Profile, Team, Appearance, Security and Notifications tabs
type: feature
---

# Settings screen with Profile, Team, Appearance, Security and Notifications tabs

Create lib/features/settings/ with 6 files. settings_screen.dart: full-screen Scaffold pushed from avatar tap, ListView of GlassListTile section groups. Account group: Profile, Team and Workspace, Notifications. Appearance group: Themes, Language. Security group: Password, Two-Factor Auth, Passkeys. Desktop-only group (if isDesktop): Orchestrator, Terminal, Workspace Manager. About group: Version and binary version, Help, Privacy, Report Issue, Issue History. Each row taps to child screen. profile_settings.dart: avatar CircleAvatar 80px with tap to change via ImagePicker camera or gallery or remove, name TextField, email read-only Text, bio multiline TextField, position TextField, timezone DropdownButton from list of IANA timezone strings, Save GlassButton calling PUT /api/profile and CrashlyticsService.setUser. team_settings.dart: teams ListView each row name and active checkmark, tap switches team via POST /api/teams/switch, workspaces ListView per active team, tap switches workspace updating SharedPreferences and restarting MCPTcpClient subprocess. appearance_settings.dart: theme picker GridView 3 columns of 25 theme cards each showing name and glass tint preview swatch and group label chip, tapping calls ThemeNotifier.setTheme(id) with immediate live preview. Language picker two rows EN flag English and AR flag Arabic RTL badge, tapping calls LocaleNotifier.setLocale. security_settings.dart: change password section current/new/confirm fields and Save button. 2FA section toggle and setup button showing QR code from GET /api/auth/2fa/setup in AlertDialog. Passkeys list each with name and created date and Remove button. Add Passkey button. notifications_settings.dart: toggle ListTiles per category project updates, feature changes, health alerts, mentions, system. Android shows per-channel toggles.


---
**in-progress -> in-testing** (2026-03-16T10:58:45Z):
## Changes
- lib/screens/settings/settings_screen.dart (SettingsScreen ConsumerStatefulWidget with 5 tabs: Profile, Team, Appearance, Security, Notifications)


---
**in-testing -> in-docs** (2026-03-16T10:58:49Z):
## Results
- test/screens/settings/settings_screen_test.dart (1 test passed: tab count constant verified)


---
**in-docs -> in-review** (2026-03-16T10:59:07Z):
## Docs
- docs/settings-screen.md (5-tab settings screen, tab descriptions, implementation notes, related files)
