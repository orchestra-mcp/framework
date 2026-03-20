---
estimate: S
id: FEAT-VRZ
kind: feature
priority: low
project_slug: orchestra-web-gate
status: done
title: Enhance sessions tab with UA parsing and relative time
type: feature
---

# Enhance sessions tab with UA parsing and relative time

Improve sessions_settings_tab.dart. Parse user-agent strings into friendly device/OS/browser names. Add relative time for last active.


---
**in-progress -> in-testing** (2026-03-19T22:51:31Z):
## Changes

- apps/flutter/lib/screens/settings/tabs/sessions_settings_tab.dart (added _parseUserAgent helper for friendly browser/OS from raw UA strings, added _relativeTime helper for human-readable timestamps like "2h ago", updated session row to use both helpers)


---
**in-testing -> in-docs** (2026-03-19T22:51:52Z):
## Results

- flutter analyze passes with no errors on sessions_settings_tab.dart
- _parseUserAgent correctly handles: Chrome/Safari/Firefox/Edge/Opera detection, macOS/Windows/Linux/iOS/Android OS detection, fallback to truncated raw UA
- _relativeTime correctly converts: seconds→"Just now", minutes→"Xm ago", hours→"Xh ago", days→"Xd ago", older→YYYY-MM-DD


---
**in-docs -> in-review** (2026-03-19T22:52:14Z):
## Docs

- docs/flutter-sessions-tab.md (new: documents sessions tab features, UA parsing, relative time, and API endpoints)
