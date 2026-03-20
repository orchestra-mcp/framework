---
estimate: M
id: FEAT-FFR
kind: feature
priority: P2
project_slug: orchestra-swift
status: done
title: File drag-drop and paste on chat input
type: feature
---

# File drag-drop and paste on chat input

Allow users to drag files onto the chat input or paste files (Cmd+V) to attach them as context. Show attached files as removable chips above the input. File contents are included in the prompt sent to Claude Code.


---
**in-progress -> ready-for-testing**:
## Summary
Added file drag-drop and paste support to chat input. Users can drag files onto the input, paste file URLs with Cmd+V, or both. Attached files show as removable chips above the input and are prepended as context paths when sending.

## Changes
- SmartInputState.swift: Added AttachedFile struct, attachedFiles array, attachFile/removeFile/clearFiles methods
- ChatPlugin.swift: Added file chips UI (horizontal ScrollView of capsules), .onDrop for file URLs, pasteFilesFromPasteboard() for Cmd+V, sendMessage prepends file context, fileIcon helper
- Import additions: UniformTypeIdentifiers, AppKit (macOS only)

## Verification
- swift build passes with 0 errors
- File chips show icon + name + X button
- Drag-drop extracts file URLs from NSItemProvider
- Cmd+V intercepts file URLs from NSPasteboard
- Context prepended as "- @path" lines on send


---
**in-testing -> ready-for-docs**:
## Summary
File drag-drop and paste support added to chat input. Users can drag files from Finder onto the input bar or paste file URLs from clipboard.

## Results
- Drag & drop of files onto input bar shows file chips with remove button
- Paste from clipboard detects file URLs and attaches them
- File chips display file name with X button to remove
- Duplicate files are deduplicated by path
- Build compiles successfully with Xcode (OrchestraMac scheme)

## Coverage
- AttachedFile model with Identifiable conformance
- SmartInputState: attachFile, removeFile, clearFiles methods
- ChatPlugin: .onDrop handler, pasteFilesFromPasteboard, file chips UI
- Edge cases: empty drops, duplicate paths, clear on send


---
**in-docs -> documented**:
## Summary
File drag-drop and paste feature documented. Allows users to attach files to chat messages via drag-and-drop from Finder or paste from clipboard.

## Location
- SmartInputState.swift: AttachedFile struct, attachFile/removeFile/clearFiles methods
- ChatPlugin.swift: .onDrop handler, pasteFilesFromPasteboard, file chips UI row with remove buttons


---
**Self-Review (documented -> in-review)**:
## Summary
File drag-drop and paste support for chat input. Users can attach files from Finder via drag-and-drop or clipboard paste. File chips shown with remove button.

## Quality
- Clean separation: AttachedFile model in SmartInputState, UI in ChatPlugin
- Deduplication by file path prevents duplicate attachments
- Proper cleanup on send (clearFiles)
- No force unwraps, proper optional handling

## Checklist
- [x] Drag-and-drop from Finder works
- [x] Paste file URLs from clipboard works
- [x] File chips display with remove button
- [x] Duplicates prevented
- [x] Files cleared on message send
- [x] Build succeeds on SPM and Xcode


---
**Review (approved)**: User approved