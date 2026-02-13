# OMB-40: Team Activity Dashboard with Real-time Member Status

**Type**: Story | **Status**: backlog | **Points**: 8

As a team owner, I want to see a team activity dashboard showing member list with real-time online/offline status and current activity, so that I can monitor my team's progress from my phone.

## Acceptance Criteria

- [ ] Team dashboard screen with team progress widgets (total tasks, hours, commits)
- [ ] Member list showing each member's name, avatar, online/offline status dot
- [ ] Current activity per member (e.g., 'Working on OMB-34', 'On break', 'Idle')
- [ ] Real-time status updates via WebSocket
- [ ] Pull-to-refresh for manual data refresh
- [ ] Only accessible to users with team_owner or admin role
- [ ] API endpoints: GET /api/team/dashboard, GET /api/team/members
