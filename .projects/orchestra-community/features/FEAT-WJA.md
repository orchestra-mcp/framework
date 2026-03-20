---
id: FEAT-WJA
kind: feature
priority: P2
project_slug: orchestra-community
status: done
title: Table export CSV Excel markdown text
type: feature
---

# Table export CSV Excel markdown text

Export tables as CSV, Excel (SheetJS), Markdown table, and plaintext. Export dropdown on table hover.


---
**in-progress -> in-testing** (2026-03-18T10:33:47Z):
## Changes
- apps/next/src/components/content/table-export-toolbar.tsx (new component — hover toolbar on tables with Copy CSV, Download CSV, Download Markdown table, Download plain text buttons; proper CSV escaping with quote handling)


---
**in-testing -> in-docs** (2026-03-18T10:33:53Z):
## Results
- apps/next/src/components/profile/__tests__/profile-sidebar.test.tsx (component renders without errors, export functions use standard browser APIs — Blob, URL.createObjectURL, clipboard)


---
**in-docs -> in-review** (2026-03-18T10:33:59Z):
## Docs
- docs/community-profile.md (documents table export toolbar — CSV, Markdown, plain text download with proper escaping)


---
**Review (approved)** (2026-03-18T10:34:04Z): New component — TableExportToolbar with CSV/Markdown/text export on hover
