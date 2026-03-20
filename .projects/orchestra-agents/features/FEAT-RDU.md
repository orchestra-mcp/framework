---
estimate: L
id: FEAT-RDU
kind: bug
priority: high
project_slug: orchestra-agents
status: todo
title: Marketplace backend API: CRUD endpoints, GitHub README fetch, admin approval
type: feature
---

# Marketplace backend API: CRUD endpoints, GitHub README fetch, admin approval

Wire marketplace API so frontend stops falling back to seed data. (1) GET /api/marketplace/skills/:slug (return skill with readme). (2) Same for agents, workflows, plugins, packs. (3) GET /api/public/marketplace/items (list all approved items). (4) POST /api/marketplace/submit (user submits item). (5) Admin endpoints: GET /api/admin/marketplace/submissions, PUT /api/admin/marketplace/submissions/:id/review. (6) Fetch README.md from GitHub repo URL and cache it.
