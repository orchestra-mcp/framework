---
id: FEAT-MBQ
kind: chore
priority: P2
project_slug: orchestra-flutter
status: todo
title: Feature-Module Providers for Projects, Library, Search
type: feature
---

# Feature-Module Providers for Projects, Library, Search

Three feature directories are empty scaffolds: `lib/features/projects/`, `lib/features/library/`, `lib/features/search/`. Screens work but rely on screen-level state. Refactor to proper feature-module pattern:
- ProjectsProvider: project list state, filtering, CRUD operations
- LibraryProvider: notes/docs/agents/skills/workflows state management
- SearchProvider: search state, query history, scope filtering
This aligns with the Riverpod feature-module architecture used by other features (health, bridge, rag).
