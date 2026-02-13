# OMB-31: Version Control Overview and AI Agent Control

**Type**: Story | **Status**: backlog | **Points**: 8

As an employee, I want to view my commits, PRs, and issues, and control AI agents (status, permissions, prompts) from my phone, so that I can stay on top of development activity and respond to agent requests on the go.

## Acceptance Criteria

- [ ] Commit log screen showing recent commits with author, message, date
- [ ] PR list screen with status indicators (open, merged, closed)
- [ ] Issue list screen with labels and assignees
- [ ] PR detail screen with ability to approve/request changes
- [ ] Agent home screen showing all agents with status indicators (running, idle, waiting)
- [ ] Agent chat screen for sending prompts and viewing output log
- [ ] Agent permissions screen: approve/deny pending permission requests
- [ ] Real-time agent status via WebSocket events
- [ ] API endpoints: GET /api/commits, GET /api/pull-requests, GET /api/issues, POST /api/pull-requests/:id/review, GET /api/agents, POST /api/agents/:id/prompt, POST /api/agents/:id/permissions/:permId/respond
