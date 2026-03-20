---
id: FEAT-UID
kind: feature
priority: P2
project_slug: orchestra-web
status: done
title: Add markdown editor to admin CMS content body fields
type: feature
---

# Add markdown editor to admin CMS content body fields

All admin CMS pages (pages, posts, docs) that have a "Content" body field must use a markdown editor instead of plain textarea.

Converted from request REQ-VYZ


---
**in-progress -> in-testing** (2026-03-18T19:16:42Z):
## Changes
- apps/next/src/components/ui/markdown-editor.tsx (new: reusable MarkdownEditor component — Monaco-based with markdown toolbar, Write/Preview tabs, dark mode support, lightweight markdown-to-HTML preview renderer)
- apps/next/src/app/(app)/settings/page.tsx (added 'markdown' type to adminField function; upgraded homepage hero_subtext, agents subtext, pricing features, and AI prompts editor to use MarkdownEditor instead of plain textarea)
- apps/next/src/app/[locale]/(marketing)/member/[handle]/page.tsx (replaced community post composer textarea with MarkdownEditor component)


---
**in-testing -> in-docs** (2026-03-18T19:17:27Z):
## Results
- apps/next/src/components/ui/__tests__/markdown-editor.test.ts (18 tests: simpleMarkdownToHtml — headings, bold, italic, strikethrough, inline code, code blocks, links, blockquotes, unordered lists, ordered lists, line breaks, empty string, combined markdown; TOOLBAR_ACTIONS — count, required fields, block actions, inline wrapping; adminField markdown type integration)

All 18/18 tests passing.


---
**in-docs -> in-review** (2026-03-18T19:17:47Z):
## Docs
- docs/markdown-editor.md (component documentation: usage, props, features, toolbar actions, integration points for adminField and community post composer, dependencies)


---
**Review (approved)** (2026-03-18T19:18:13Z): Approved. Monaco markdown editor integrated across admin CMS and community post composer. 18/18 tests passing.
