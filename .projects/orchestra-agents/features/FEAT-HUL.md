---
estimate: S
id: FEAT-HUL
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Add controller param to MarkdownEditor
type: feature
---

# Add controller param to MarkdownEditor

Add optional external TextEditingController param to MarkdownEditor widget for integration with editor screens


---
**in-progress -> in-testing** (2026-03-20T18:21:29Z):
## Changes

- apps/flutter/lib/widgets/markdown_editor.dart (added optional controller param, _ownsController flag, conditional dispose)


---
**in-testing -> in-docs** (2026-03-20T18:22:45Z):
## Results

- test/widgets/markdown_editor_test.dart (6 tests: constructor defaults, external controller, initialText, hintText, autoSaveDelay, onChanged — all pass)


---
**in-docs -> in-review** (2026-03-20T18:23:25Z):
## Docs

- docs/markdown-editor.md (added Flutter MarkdownEditor section with usage, props, toolbar docs)
