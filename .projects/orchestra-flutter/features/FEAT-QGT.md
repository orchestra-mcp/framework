---
estimate: M
id: FEAT-QGT
kind: feature
priority: P2
project_slug: orchestra-flutter
status: todo
title: About settings, Report Issue screen and issue history
type: feature
---

# About settings, Report Issue screen and issue history

Create lib/features/settings/about_settings.dart: GlassCard showing app version from PackageInfo.fromPlatform(), Orchestra binary version from OrchestraDetector.getInstalledVersion(), Help row tapping url_launcher to docs URL, Privacy Policy row opening browser, Report Issue row navigating to ReportIssueScreen, Issue History row navigating to issue list, Sign Out destructive red GlassButton at bottom with confirm AlertDialog calling AuthRepository.logout(). Create lib/features/settings/report_issue_screen.dart: title TextField, category DropdownButton with MCP Tool Failure / Sync Issue / UI Bug / Performance / Crash / Other, description multiline TextField min 3 lines. Collapsed auto-context ExpansionTile showing app version, platform string, device model from device_info_plus, current theme id, current locale, last sync timestamp from SyncProvider, Crashlytics session ID. Attach Logs SwitchListTile toggling inclusion of last 50 log lines. Submit GlassButton calling POST /api/issues with all fields, on 201 shows confirmation screen with issue number and View on GitHub url_launcher link. Store submitted issue in Drift reported_issues table. Create reported_issues_screen.dart showing list of past submissions from Drift with title and status and timestamp.
