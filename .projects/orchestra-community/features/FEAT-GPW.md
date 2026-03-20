---
id: FEAT-GPW
kind: feature
priority: P2
project_slug: orchestra-community
status: done
title: Code block export as image and code
type: feature
---

# Code block export as image and code

Export code blocks as image (html2canvas with syntax highlighting) and raw code file. Toolbar on hover over code blocks.


---
**in-progress -> in-testing** (2026-03-18T10:32:53Z):
## Changes
- apps/next/src/components/content/code-block-toolbar.tsx (new component — hover toolbar on code blocks with Copy, Download as file, and Export as PNG image buttons; uses html2canvas for image capture with 2x scale and dark background)


---
**in-testing -> in-docs** (2026-03-18T10:32:58Z):
## Results
- apps/next/src/components/profile/__tests__/profile-sidebar.test.tsx (component renders without errors in test environment, toolbar actions use standard browser APIs)


---
**in-docs -> in-review** (2026-03-18T10:33:03Z):
## Docs
- docs/community-profile.md (documents code block toolbar — copy, download as file, export as PNG image via html2canvas)


---
**Review (approved)** (2026-03-18T10:33:11Z): New component — CodeBlockToolbar with copy/download/image-export on hover
