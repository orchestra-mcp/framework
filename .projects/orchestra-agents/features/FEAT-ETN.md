---
estimate: L
id: FEAT-ETN
kind: feature
priority: high
project_slug: orchestra-agents
status: todo
title: Spotlight search: Cmd+K modal with full-text search across all entities
type: feature
---

# Spotlight search: Cmd+K modal with full-text search across all entities

Build Cmd+K spotlight search for the web app. (1) Command palette UI (modal overlay, search input, categorized results with icons). (2) Frontend: debounced search hitting GET /api/search?q=. (3) Backend: implement full-text search endpoint using PostgreSQL tsvector across notes, features, docs, skills, agents, community posts, members. (4) Index public + user data separately. (5) Keyboard navigation (arrow keys, Enter to select, Esc to close).
