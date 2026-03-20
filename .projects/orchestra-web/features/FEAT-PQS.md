---
estimate: M
id: FEAT-PQS
kind: feature
priority: medium
project_slug: orchestra-web
status: done
title: Enhanced Session Manager on Flutter and Backend
type: feature
---

# Enhanced Session Manager on Flutter and Backend

Enhance sessions_settings_tab: parse user-agent into device/OS/browser, add tunnel status indicator. Backend: cross-reference active tunnels with sessions, implement real session revocation (currently no-op).


---
**in-progress -> in-testing** (2026-03-19T21:52:05Z):
## Changes
- apps/web/internal/handlers/settings.go — ListSessions: added user-agent parsing (parseUserAgent extracts device/OS/browser, classifyDevice returns mobile/tablet/desktop), includes registered device tokens as additional sessions, cross-references with active tunnels for tunnel_active flag. RevokeSession: now actually deletes device tokens (was no-op), blocks revocation of current session.
- apps/flutter/lib/screens/settings/tabs/sessions_settings_tab.dart — enhanced session row to display OS + browser info from backend, shows "Tunnel connected" green indicator when tunnel_active is true, includes last_seen timestamp in info line


---
**in-testing -> in-docs** (2026-03-19T21:53:08Z):
## Results
- apps/web/internal/handlers/user_agent_test.go (2 tests, all passing):
  - TestParseUserAgent: 6 user-agent strings parsed correctly (Mac/Chrome, iPhone/Safari, Windows/Edge, Linux/Firefox, Android/Chrome, Orchestra App)
  - TestClassifyDevice: 5 device classifications (iPhone→mobile, iPad→tablet, Mac→desktop, Windows→desktop, Android Mobile→mobile)
- Go compilation clean
- Flutter dart analyze: No issues found


---
**in-docs -> in-review** (2026-03-19T21:53:25Z):
## Docs
- docs/session-manager.md (new — backend session list enhancements, revocation fix, user-agent parsing, Flutter display changes)


---
**Review (approved)** (2026-03-19T21:53:48Z): Session manager enhanced with UA parsing, device tokens, tunnel status, real revocation.
