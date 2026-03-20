---
estimate: M
id: FEAT-GVV
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Rich Markdown Editor in McpEntityEditorScreen
type: feature
---

# Rich Markdown Editor in McpEntityEditorScreen

Replace plain TextField body editor in mcp_entity_editor.dart with MarkdownEditor widget


---
**in-progress -> in-testing** (2026-03-20T18:32:38Z):
## Changes
- apps/flutter/lib/screens/library/mcp_entity_editor.dart (replaced plain TextField body editor with MarkdownEditor widget, removed _preview state and preview toggle button, extracted _buildTypeBadge helper and _bodyHint getter, restructured layout: smart mode in SingleChildScrollView, manual mode in Column with Expanded MarkdownEditor, deleted _buildBodyEditor and _buildPreview methods, entity-specific hints: agent→systemPromptHint, doc→docContentHint, others→descriptionMarkdownHint)


---
**in-testing -> in-docs** (2026-03-20T18:33:47Z):
## Results
- apps/flutter/test/screens/mcp_entity_editor_test.dart (6 new tests: const-constructible, entityId editing, ConsumerStatefulWidget check, all entity types, projectId/initialData, MarkdownEditor controller integration)
- apps/flutter/test/widgets/markdown_editor_test.dart (6 existing tests pass)
- flutter analyze lib/screens/library/mcp_entity_editor.dart: 0 errors, 0 warnings (11 pre-existing info hints)
- Screen-level tests have pre-existing compile error (McpTcpClient missing respondDelegation) unrelated to this feature


---
**in-docs -> in-review** (2026-03-20T18:34:05Z):
## Docs
- docs/markdown-editor.md (added Flutter Integration — McpEntityEditorScreen section documenting entity-specific hints, bounded height layout, and MarkdownEditor usage pattern)


---
**Review (approved)** (2026-03-20T18:35:11Z): Approved — MarkdownEditor integrated in McpEntityEditorScreen for all entity types
