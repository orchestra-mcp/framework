---
estimate: L
id: FEAT-CCY
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: API Collection Manager screen (3-pane UI)
type: feature
---

# API Collection Manager screen (3-pane UI)

3-pane layout: collections sidebar, request builder (method/path/headers/body), response viewer (status/headers/body with syntax highlighting). Uses api_collection_provider. Files: screens/devtools/api_collections_screen.dart, widgets for request builder and response viewer


---
**in-progress -> in-testing** (2026-03-20T18:07:11Z):
## Changes
- apps/flutter/lib/screens/devtools/api_collections_screen.dart (new — 679 lines, 3-pane layout: collections sidebar, request builder, response viewer with desktop/mobile responsive layouts)
- apps/flutter/lib/screens/devtools/widgets/api_request_builder.dart (new — 839 lines, method dropdown, URL field, tabs for params/headers/body/auth, JSON formatting, color-coded methods)
- apps/flutter/lib/screens/devtools/widgets/api_response_viewer.dart (new — 387 lines, status badge, duration, body/headers tabs, JSON pretty-print, copy to clipboard)


---
**in-testing -> in-docs** (2026-03-20T18:09:26Z):
## Results
- apps/flutter/test/screens/devtools/api_collections_screen_test.dart (10 tests — RequestBuilderData construction, ApiResponse status code categorization, ApiCollection sidebar data parsing)
- All 10 tests pass, 0 failures


---
**in-docs -> in-review** (2026-03-20T18:09:57Z):
## Docs
- docs/api-collections-screen.md (new — documents 3-pane layout, desktop/mobile responsiveness, all 3 components, data flow diagram)


---
**Review (approved)** (2026-03-20T18:10:35Z): 3-pane API Collection Manager with responsive desktop/mobile layout, 10 tests passing
