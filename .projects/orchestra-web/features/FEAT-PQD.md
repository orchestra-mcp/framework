---
id: FEAT-PQD
kind: feature
priority: P0
project_slug: orchestra-web
status: backlog
title: Dashboard + Project Management + Epic/Story/Task Hierarchy
type: feature
---

# Dashboard + Project Management + Epic/Story/Task Hierarchy

Main dashboard and full project management with Epic → Story → Task hierarchy, sync status, and team-scoped access.

**Dashboard** (`resources/js/pages/dashboard.tsx`):
- Stats cards: total projects, synced devices, active tasks, completed tasks
- Platform capabilities showcase: MCP tool count, agent count, skills count, platform icons
- Recent projects list: name, sync_status badge (synced|syncing|error|not_synced), last_synced_at, quick actions
- Recent notes sidebar: pinned notes at top, latest 5 notes
- Activity feed: recent sync_log entries (what changed, when, from which device)

**Projects** (`resources/js/pages/projects/`):
- `index.tsx` — grid/list toggle, search, filter by team, sort by last_synced/created/name; `POST /projects` → create project modal (name, description, team selector, icon, color)
- `show.tsx` — project detail with tab navigation:
  - **Overview**: description, stats (epics, stories, tasks, completion %), sync status card
  - **Epics**: accordion list of epics with stories inside
  - **Team Members**: member list with role badges, invite button → calls `POST /projects/{project}/team-members`
  - **Settings**: name, description, icon, color, danger zone (delete project)

**Epic/Story/Task hierarchy** (inline in project show):
- Epic list: `GET /api/projects/{slug}/epics` → expandable rows
- Each epic: title, story count, status badge, expand → shows stories
- Each story: title, task count, status, expand → shows tasks
- Each task: title, status badge, priority badge, assignee avatar, due date
- Inline create: "+" button at each level → inline form (no separate page)
- Status workflow per task: todo → in-progress → done (dropdown)
- Priority: low|medium|high|critical (colored badge)
- All CRUD via API: `POST/PUT /api/projects/{slug}/epics/{epicId}/stories/{storyId}/tasks`
- Drag-to-reorder within same parent (HTML5 drag or mouse events)

**Project API Controllers** (`Api/ProjectController`, `Api/EpicController`, `Api/StoryController`, `Api/TaskController`):
- Full CRUD for projects, epics, stories, tasks
- `GET /api/projects/{slug}/tree` — full hierarchy in single response (for desktop/mobile)
- `GET /api/projects/stats/tasks` — task stats across all projects

**Notifications** (`resources/js/pages/notifications.tsx`):
- Real-time notification bell in top nav with unread count
- Notification list: type icon, message, timestamp, read/unread state
- Mark read on click, mark all read button
- Types: team_invitation, sync_conflict, subscription_expiry, task_assigned

Acceptance: dashboard loads with real stats, projects list/create/delete works, epic/story/task hierarchy renders and supports inline CRUD, task status updates via dropdown, notification bell shows unread count