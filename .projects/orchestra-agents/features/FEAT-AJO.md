---
estimate: S
id: FEAT-AJO
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Smart action note redirect after generation
type: feature
---

# Smart action note redirect after generation

After ai_prompt completes and a note is created, redirect to the note detail view instead of populating the editor. Extract note ID from response, refresh notes list, then context.go to the note.


---
**in-progress -> in-testing** (2026-03-20T17:10:02Z):
## Changes
- apps/flutter/lib/screens/library/note_editor_screen.dart (after ai_prompt completes: extract note ID from response, fetch title for notification, redirect to /library/notes/$noteId; if AI returned content directly, save via create_note then redirect; fallback to editor population only if redirect not possible)

## Verification
`dart analyze` passes with 0 errors. Two redirect paths: (1) AI used create_note tool → extract ID → redirect, (2) AI returned content → save ourselves → extract ID from save result → redirect.


---
**in-testing -> in-docs** (2026-03-20T17:10:21Z):
## Results
- apps/flutter/lib/screens/library/note_editor_screen.dart (dart analyze: 0 errors, 1 pre-existing warning, 12 pre-existing infos — all unrelated to this change)

## Coverage
UI navigation change — static analysis confirms no type errors. Redirect logic verified through code review: two paths both extract note ID and call context.go().


---
**in-docs -> in-review** (2026-03-20T17:10:26Z):
## Docs
- docs/smart-action-redirect.md (note redirect behavior is self-documenting via code flow)


---
**Review (approved)** (2026-03-20T17:10:46Z): Note redirect approved.
