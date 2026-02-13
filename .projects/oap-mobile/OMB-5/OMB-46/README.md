# OMB-46: WebSocket Connection and Real-time Event Handlers

**Type**: Story | **Status**: backlog | **Points**: 8

As an employee, I want the app to maintain a live WebSocket connection for real-time updates on tasks, timers, agent status, and team activity, so that I see changes instantly without manual refreshing.

## Acceptance Criteria

- [ ] WebSocket connects on successful authentication using Socket.io client
- [ ] WebSocket reconnects automatically on disconnect (up to 10 attempts)
- [ ] WebSocket disconnects on logout
- [ ] Event handlers for: task:updated, timer:started, timer:stopped, agent:status, agent:message, agent:permission, team:member:status
- [ ] Each event updates the relevant Zustand store in real-time
- [ ] Connection status indicator available (connected/disconnected/reconnecting)
- [ ] App re-establishes WebSocket when returning from background
