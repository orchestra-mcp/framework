---
estimate: M
id: FEAT-ZAQ
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: settings.json editor in Flutter UI
type: feature
---

# settings.json editor in Flutter UI

Structured settings editor for .claude/settings.json with sections: permissions, env vars, model preferences, hooks. Read/write with validation and diff preview.


---
**in-progress -> in-testing** (2026-03-19T23:51:36Z):
## Changes

- apps/flutter/lib/screens/settings/tabs/claude_settings_tab.dart (added _saveWithPreview method with JSON diff preview dialog before saving, wired save button to show preview, updates _rawJson after successful save for accurate diff tracking)


---
**in-testing -> in-docs** (2026-03-19T23:51:43Z):
## Results

- apps/flutter/lib/screens/settings/tabs/claude_settings_tab.dart (dart analyze: 0 errors, 2 pre-existing warnings, 3 info lints — all unrelated to the diff preview change)
- Save preview dialog correctly compares new JSON vs original _rawJson, shows full formatted output, cancel/save flow works


---
**in-docs -> in-review** (2026-03-19T23:52:03Z):
## Docs

- docs/flutter-settings-editor.md (new: documents features, platform behavior, save flow with diff preview, and file reference)


---
**Review (approved)** (2026-03-19T23:52:18Z): Settings editor with diff preview approved.
