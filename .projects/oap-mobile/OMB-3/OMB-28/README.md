# OMB-28: Dashboard Home with Progress Widgets and Main Tab Navigator

**Type**: Story | **Status**: backlog | **Points**: 8

As an employee, I want a dashboard home screen with progress widgets and quick actions inside a bottom tab navigator, so that I can see my work summary at a glance and navigate to key features.

## Acceptance Criteria

- [ ] Bottom tab navigator with 5 tabs: Dashboard, Tasks, Timers, Agent, More
- [ ] Dashboard screen shows progress widgets: tasks completed, time tracked, commits today
- [ ] Weekly activity chart (bar or line chart)
- [ ] Quick action buttons: Start Timer, View Tasks, Check Agent
- [ ] Pull-to-refresh refreshes all widget data
- [ ] API endpoints consumed: GET /api/dashboard/summary, GET /api/dashboard/weekly-chart
- [ ] Tab icons use appropriate icons from a vector icon library
- [ ] Badge on Agent tab when there are pending permissions
