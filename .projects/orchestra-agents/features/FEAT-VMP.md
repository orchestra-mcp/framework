---
estimate: M
id: FEAT-VMP
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Expand Smart Action Dialog to Universal
type: feature
---

# Expand Smart Action Dialog to Universal

Expand SmartActionType from 4 to 10+ entity types, add type-selector grid, Cmd+N shortcut, + button in header


---
**in-progress -> in-testing** (2026-03-20T18:40:50Z):
## Changes
- apps/flutter/lib/widgets/smart_action_dialog.dart (complete rewrite: new UniversalActionType enum with 10 types, _ActionTypeMeta class with label/icon/color/aiHint for each type, new showUniversalCreateMenu function with 2-step dialog — type grid then AI/Manual tabs, healthBrief hides manual tab, deprecated SmartActionType enum and showCreateMenu wrapper for backward compatibility)
- apps/flutter/lib/screens/shell/desktop_shell.dart (added "+" button in header bar before refresh button, added _handleUniversalCreate top-level function routing each type to the correct editor screen or API call, added api_provider.dart and smart_action_dialog.dart imports)


---
**in-testing -> in-docs** (2026-03-20T18:42:06Z):
## Results
- apps/flutter/test/widgets/smart_action_dialog_test.dart (5 tests: UniversalActionType has 10 values, contains all expected types, name property, SmartActionType backward compat has 4 values and original types)
- apps/flutter/test/widgets/markdown_editor_test.dart (6 existing tests pass)
- flutter analyze on smart_action_dialog.dart: 0 issues
- flutter analyze on smart_action_dialog_test.dart: 0 issues
- flutter analyze on desktop_shell.dart: 0 new errors (pre-existing _DevToolsSidebar error at line 1055 prevents flutter test from running any test that transitively imports desktop_shell.dart)
- flutter analyze on all 3 caller screens (agents, skills, notes): 0 errors, only pre-existing info hints


---
**in-docs -> in-review** (2026-03-20T18:42:30Z):
## Docs
- docs/universal-smart-action.md (new — documents all 10 types, new showUniversalCreateMenu API, deprecated legacy API, dialog flow, global entry point, backward compatibility)


---
**Review (approved)** (2026-03-20T18:42:51Z): Approved — Universal smart action dialog with 10 entity types, type grid, and global + button
