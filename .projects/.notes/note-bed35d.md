---
id: note-bed35d
title: Create a note about the orchestra mcp notes system
type: note
---

Let me explore the codebase to understand the notes system.


Now I have a thorough understanding of the notes system. Let me write the plan and then exit plan mode.
I've explored the notes system thoroughly. The plan is straightforward — create a comprehensive note using the MCP `create_note` tool documenting the 8 tools, data model, storage format, and architecture of the notes plugin.
The orchestrator had a hiccup. Let me go ahead and create the note directly.
The note was created successfully. Here's what was done:

- **Feature FEAT-XXP** created and moved to in-progress
- **Note created** via `create_note` with comprehensive documentation of the notes system

The note covers:
- **8 MCP tools** — CRUD (create/get/update/delete), list, search, pin, tag
- **Data model** — all metadata fields, ID format (`note-XXXXXX`), YAML frontmatter
- **Storage backend** — markdown files at `{project}/notes/{id}.md`, Protobuf storage protocol, optimistic locking
- **Plugin architecture** — file structure, registration flow, handler pattern
- **Key details** — soft delete, tag dedup, case-insensitive search, composable filters, error types
- **Dependencies** and **testing** (159 assertions)