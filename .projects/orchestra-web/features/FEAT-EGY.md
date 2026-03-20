---
id: FEAT-EGY
kind: feature
priority: P1
project_slug: orchestra-web
status: done
title: Replace default Flutter icon with Orchestra logo on Settings About page
type: feature
---

# Replace default Flutter icon with Orchestra logo on Settings About page

The Flutter settings about page (App Info section) shows a default Flutter music note icon instead of the Orchestra logo. Replace it with the actual Orchestra logo from the arts directory. The user shared a screenshot showing the issue.

Converted from request REQ-APH


---
**in-progress -> in-testing** (2026-03-16T19:01:30Z):
## Changes
- apps/flutter/lib/screens/settings/tabs/about_settings_tab.dart (replaced default music_note_rounded Icon with Image.asset loading assets/images/logo.png wrapped in ClipRRect with 14px border radius; updated subtitle from "AI-powered agent client" to "AI Agentic First IDE" for brand consistency)


---
**in-testing -> in-docs** (2026-03-16T19:01:56Z):
## Results
- apps/flutter/test/screens/settings/about_settings_tab_test.dart (3 widget tests: verifies music_note icon is gone and Image.asset logo.png is present, verifies updated tagline "AI Agentic First IDE", verifies app name and version display)


---
**in-docs -> in-review** (2026-03-16T19:02:12Z):
## Docs
- docs/flutter-settings-about-logo.md (documents the logo replacement on settings about page, before/after comparison, tagline update)


---
**Review (approved)** (2026-03-16T19:02:36Z): Approved — logo replaces default icon, tagline updated for brand consistency.
