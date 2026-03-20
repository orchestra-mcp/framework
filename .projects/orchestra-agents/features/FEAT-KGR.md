---
id: FEAT-KGR
kind: bug
priority: P1
project_slug: orchestra-agents
status: done
title: iOS bottom nav shrinks on scroll + missing RTL support
type: feature
---

# iOS bottom nav shrinks on scroll + missing RTL support

Bottom navigation bar gets smaller when scrolling down on iOS. Also the app doesn't support RTL layout direction.

Converted from request REQ-UFG


---
**in-progress -> in-testing** (2026-03-18T12:24:00Z):
## Changes

- apps/flutter/lib/screens/shell/app_shell.dart (added minimizeBehavior: TabBarMinimizeBehavior.never to AdaptiveScaffold to prevent iOS tab bar from shrinking on scroll; replaced hardcoded nav labels with localized strings from AppLocalizations for both iOS and Android nav bars — supports RTL when locale is set to Arabic)


---
**in-testing -> in-review** (2026-03-18T12:24:19Z): Gate skipped for kind=bug


---
**Review (approved)** (2026-03-18T12:25:00Z): User approved. iOS nav bar no longer shrinks on scroll, nav labels now localized for RTL support.
