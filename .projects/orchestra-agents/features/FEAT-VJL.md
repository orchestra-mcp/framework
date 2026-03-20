---
estimate: M
id: FEAT-VJL
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Rich Markdown Editor in NoteEditorScreen
type: feature
---

# Rich Markdown Editor in NoteEditorScreen

Replace plain TextField body editor in note_editor_screen.dart with MarkdownEditor widget (toolbar + preview modes)


---
**in-progress -> in-testing** (2026-03-20T18:27:58Z):
## Changes
- apps/flutter/lib/screens/library/note_editor_screen.dart (replaced plain TextField body editor with MarkdownEditor widget, removed _preview toggle state, removed preview button from toolbar, restructured layout for bounded height with Expanded, deleted unused _buildEditor and _buildPreview methods, removed unused markdown_renderer.dart import)
- apps/flutter/lib/widgets/markdown_editor.dart (dependency — controller param from FEAT-HUL)


---
**in-testing -> in-docs** (2026-03-20T18:29:09Z):
## Results
- apps/flutter/test/screens/note_editor_screen_test.dart (4 new tests: const-constructible new/edit, ConsumerStatefulWidget check, MarkdownEditor controller integration)
- apps/flutter/test/widgets/markdown_editor_test.dart (6 existing tests pass — controller param, defaults, callbacks)
- 10/10 tests pass


---
**in-docs -> in-review** (2026-03-20T18:29:30Z):
## Docs
- docs/markdown-editor.md (added Flutter Integration — NoteEditorScreen section documenting manual mode layout, MarkdownEditor usage with controller, bounded height requirement)


---
**Review (approved)** (2026-03-20T18:29:49Z): Approved — MarkdownEditor integrated in NoteEditorScreen manual mode
