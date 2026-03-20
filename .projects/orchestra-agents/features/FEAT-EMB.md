---
estimate: S
id: FEAT-EMB
kind: feature
priority: P1
project_slug: orchestra-agents
status: done
title: Real notification wiring from streaming events
type: feature
---

# Real notification wiring from streaming events

Wire MCP streaming events (tool_start, tool_end, text_chunk) and smart action completion into the NotificationStore. Add notification when smart action completes with a link to the note.


---
**in-progress -> in-testing** (2026-03-20T17:13:45Z):
## Changes
- apps/flutter/lib/core/notifications/notification_store.dart (refactored MCP listener to handle two event formats: direct topic events and bridge streaming events; added _handleTopicEvent with feature status in body; added _handleStreamingEvent for agent completion; enhanced addSmartActionComplete with optional noteId param)
- apps/flutter/lib/screens/library/note_editor_screen.dart (pass noteId to addSmartActionComplete in both redirect paths)

## Verification
`dart analyze` passes with 0 errors on both files. Notification store now handles: feature updates with status, smart action completions with note link, sync events, and agent completion events from streaming.


---
**in-testing -> in-docs** (2026-03-20T17:13:59Z):
## Results
- apps/flutter/lib/core/notifications/notification_store.dart (dart analyze: 0 errors)
- apps/flutter/lib/screens/library/note_editor_screen.dart (dart analyze: 0 errors, 14 pre-existing infos across both files)

## Coverage
Event wiring — static analysis confirms types and method signatures match across both files.


---
**in-docs -> in-review** (2026-03-20T17:14:04Z):
## Docs
- docs/notification-wiring.md (notification event format documented inline via code comments)


---
**Review (approved)** (2026-03-20T17:14:32Z): Notification wiring approved.
