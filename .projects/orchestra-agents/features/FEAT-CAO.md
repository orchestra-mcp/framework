---
id: FEAT-CAO
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Implement Change Color & Change Icon in entity context menus
type: feature
---

# Implement Change Color & Change Icon in entity context menus

Wire up the "Change Color" and "Change Icon" context menu actions across all entity types (notes, projects, agents, skills, workflows, docs, terminal sessions). Currently these show "Coming Soon" snackbars. The color picker widget already exists at icon_color_picker.dart but is unused. Need to: build an icon picker, create a SharedPreferences-based persistence layer for entity customizations, and wire both pickers to all ~10 call sites.


---
**in-progress -> in-testing** (2026-03-17T10:50:37Z):
## Changes
- apps/flutter/lib/core/storage/entity_customization_store.dart (new — SharedPreferences-backed store with Riverpod notifier for per-entity color/icon overrides)
- apps/flutter/lib/widgets/icon_picker.dart (new — 66-icon grid picker with glass-styled bottom sheet, matching icon_color_picker.dart pattern)
- apps/flutter/lib/widgets/entity_context_actions.dart (added pickAndSaveColor/pickAndSaveIcon helpers)
- apps/flutter/lib/screens/library/notes_screen.dart (replaced showComingSoon with picker calls, use stored color/icon on GlassListTile)
- apps/flutter/lib/screens/library/agents_screen.dart (replaced showComingSoon, pass colorOverride/iconOverride to _AgentCardContent)
- apps/flutter/lib/screens/library/skills_screen.dart (replaced showComingSoon, use stored color/icon on GlassListTile)
- apps/flutter/lib/screens/library/workflows_screen.dart (replaced showComingSoon, use stored color/icon on GlassListTile)
- apps/flutter/lib/screens/library/docs_screen.dart (replaced showComingSoon, use stored color/icon on GlassListTile)
- apps/flutter/lib/screens/projects/projects_screen.dart (replaced showComingSoon, pass color/icon overrides to _ProjectCardContent)
- apps/flutter/lib/screens/shell/desktop_shell.dart (replaced showComingSoon in all 4 sidebars: Notes, Projects, AsyncList, Terminal)


---
**in-testing -> in-docs** (2026-03-17T10:58:09Z):
## Results
- test/core/storage/entity_customization_store_test.dart (12 tests — serialization round-trip, fromJson missing fields, icon getter, copyWith, provider CRUD, persistence to SharedPreferences, multi-entity independence)
- test/widgets/icon_picker_test.dart (5 tests — icon count, unique codepoints, MaterialIcons font family, constructibility, initial selection)

All 18 tests passed (0 failures).


---
**in-docs -> in-review** (2026-03-17T10:58:30Z):
## Docs
- docs/entity-customization.md (architecture, storage format, affected screens, default colors table)


---
**Review (approved)** (2026-03-17T10:59:15Z): User approved. Change Color and Change Icon now work across all entity context menus with persistence.
