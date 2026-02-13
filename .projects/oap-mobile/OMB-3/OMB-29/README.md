# OMB-29: Task Management Screens (Project/Epic/Story/Task Hierarchy)

**Type**: Story | **Status**: backlog | **Points**: 13

As an employee, I want to browse my tasks through a project, epic, story, task hierarchy with markdown rendering and status updates, so that I can manage my work from my mobile device.

## Acceptance Criteria

- [ ] ProjectList screen showing all projects with progress bars
- [ ] EpicList screen showing epics in a project with status badges
- [ ] StoryList screen showing stories in an epic with point totals
- [ ] TaskDetail screen with full markdown rendering of task description
- [ ] Status update dropdown on TaskDetail (backlog, in_progress, review, done)
- [ ] Filter and sort controls on list screens (by status, priority, assignee)
- [ ] Search bar on ProjectList and EpicList
- [ ] Pull-to-refresh on all list screens
- [ ] API endpoints: GET /api/projects, GET /api/projects/:id/epics, GET /api/epics/:id/stories, GET /api/stories/:id/tasks, PATCH /api/tasks/:id
- [ ] Task list items show title, status badge, priority indicator, and assignee avatar
