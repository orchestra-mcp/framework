---
estimate: M
id: FEAT-GTI
kind: feature
priority: P2
project_slug: orchestra-agents
status: done
title: Marketplace deep links for install
type: feature
---

# Marketplace deep links for install

Register orchestra:// URL scheme in Flutter. Add route handler for orchestra://install/pack/{slug}. Add Open in Orchestra button on web marketplace pages.


---
**in-progress -> in-testing** (2026-03-19T23:41:02Z):
## Changes

- apps/flutter/lib/core/deeplink/deeplink_handler.dart (new: DeepLinkHandler singleton with app_links, parses orchestra://install/pack|plugin/{slug}, exposes Stream of install requests)
- apps/flutter/lib/widgets/deep_link_install_dialog.dart (new: confirmation dialog showing pack/plugin name and CLI command, uses ThemeTokens)
- apps/flutter/pubspec.yaml (added app_links: ^6.4.0 dependency)
- iOS Info.plist already had orchestra scheme registered, no changes needed
- Web marketplace pages already have Install in App buttons with orchestra:// deep links


---
**in-testing -> in-docs** (2026-03-19T23:41:31Z):
## Results

- apps/flutter/lib/core/deeplink/deeplink_handler.dart (dart analyze: 0 errors, 1 warning for untyped catch param, 1 info for import ordering)
- apps/flutter/lib/widgets/deep_link_install_dialog.dart (dart analyze: 0 errors, 0 warnings)
- flutter pub get succeeded, app_links package resolved correctly
- iOS Info.plist already has orchestra:// URL scheme registered


---
**in-docs -> in-review** (2026-03-19T23:41:47Z):
## Docs

- docs/marketplace-community-api.md (added Flutter Deep Link Implementation section with handler, dialog, URL scheme registration, init, and stream listener documentation)


---
**Review (approved)** (2026-03-19T23:42:28Z): Deep link install handler approved.
