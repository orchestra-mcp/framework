---
id: REQ-WBH
kind: bug
priority: P1
project_slug: orchestra-web
status: pending
title: Fix docs fetch error + save sitemap to public folder
type: request
---

# Fix docs fetch error + save sitemap to public folder

1. Docs page shows "Failed to load document - The file may have been moved or deleted." — need to fix the fetch/display logic.\n2. Sitemap generator should save sitemap.xml to the Next.js public folder so it's accessible as a public URL.