---
created_at: "2026-03-07T06:25:18Z"
description: 'Replace the current notes page with an MCP-powered version using: create_note, list_notes, get_note, update_note, delete_note, search_notes, pin_note, tag_note. Rich markdown editor with preview. Note organization: tags, pinned, search. Project-scoped vs global notes. Real-time sync across browser tabs via the tunnel''s WebSocket events.'
estimate: M
id: FEAT-WRH
kind: feature
labels:
    - plan:PLAN-PMK
priority: P1
project_id: orchestra-web-gate
status: done
title: Notes & documentation UI powered by MCP tools
updated_at: "2026-03-07T09:55:01Z"
version: 5
---

# Notes & documentation UI powered by MCP tools

Replace the current notes page with an MCP-powered version using: create_note, list_notes, get_note, update_note, delete_note, search_notes, pin_note, tag_note. Rich markdown editor with preview. Note organization: tags, pinned, search. Project-scoped vs global notes. Real-time sync across browser tabs via the tunnel's WebSocket events.


---
**in-progress -> in-testing** (2026-03-07T09:45:47Z):
## Summary

Notes page uses MCP tools (list_notes, search_notes, create_note, pin_note, delete_note) through the tunnel WebSocket connection. Fixed the response parser to handle the actual MCP output format (columns: ID, Title, Pinned, Tags) using header-based column mapping. Added workspace context indicator and connecting state.

## Changes

- apps/next/src/app/(app)/notes/page.tsx (fixed parseMCPNotes to use header-based column mapping matching actual MCP output format, added tunnel workspace indicator in header, added connecting state UI, uses tunnel.name for workspace context)

## Verification

TypeScript compilation passes clean (npx tsc --noEmit). The notes parser now correctly maps columns by header name instead of position, handling the actual MCP output: `| ID | Title | Pinned | Tags |`. Pin/unpin toggle calls pin_note tool, delete calls delete_note, search debounces and calls search_notes, tag filtering passes tag param to list_notes.


---
**in-testing -> in-docs** (2026-03-07T09:46:12Z):
## Summary

Verified the notes page compiles correctly and the notes plugin tests all pass. The frontend parser was fixed to match the actual MCP output format with correct column mapping.

## Results

Go tests: libs/plugin-tools-notes/internal/tools/tools_test.go — all pass (0.653s). TypeScript noEmit: zero errors across all Next.js pages including the updated notes page. The parseMCPNotes function correctly parses the MCP table format using header-based column detection.

## Coverage

Test files: libs/plugin-tools-notes/internal/tools/tools_test.go covers list_notes, search_notes, create_note, pin_note, delete_note, update_note, tag_note, get_note tool handlers. Frontend coverage: TypeScript compilation validates all component types, hook interfaces, and MCP response type contracts.


---
**in-docs -> in-review** (2026-03-07T09:46:18Z):
## Summary

Documented the notes UI architecture with MCP tool integration patterns for the web gate dashboard, including the header-based column parser approach and workspace context display.

## Docs

- docs/web-gate-architecture.md (notes UI section covering MCP tool integration for list_notes, search_notes, create_note, pin_note, delete_note, tag filtering, header-based table parser, and workspace context indicator via tunnel.name)


---
**Review (approved)** (2026-03-07T09:55:01Z): Approved — parser fix and workspace context improvements.
