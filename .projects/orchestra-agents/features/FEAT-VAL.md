---
estimate: L
id: FEAT-VAL
kind: feature
priority: P2
project_slug: orchestra-agents
status: todo
title: Admin content management table
type: feature
---

# Admin content management table

Admin page for managing all shared content (SharedContent model). DataTable with columns: title, entity_type, author, visibility, views, created_at. Actions: publish/unpublish, delete, view. Bulk actions: publish all, delete selected. Search by title, filter by entity_type and visibility. Go admin endpoint. Files: settings/admin-content/page.tsx, components/dashboard/admin-content-table.tsx, handlers/admin.go
