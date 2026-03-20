---
id: FEAT-YSN
kind: feature
priority: P1
project_slug: orchestra-tools
status: done
title: Standalone notes plugin (tools.notes)
type: feature
---

# Standalone notes plugin (tools.notes)

Replace save_note/list_notes from tools-features. Tools: create_note, get_note, update_note, delete_note, list_notes, search_notes, pin_note, tag_note. Storage: .projects/{project}/notes/{id}.md. Cleanup: remove old note tools from tools-features/internal/tools/metadata.go.

---
**in-progress -> done**: 13 tests passing (create_note, get_note, list_notes, delete_note, search_notes, tag/pin validation, storage helpers). In-memory mock StorageClient used for testing. Binary built to bin/tools-notes. Wired into plugins.yaml.