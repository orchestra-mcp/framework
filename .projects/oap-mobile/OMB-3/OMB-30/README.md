# OMB-30: Timer, Break, and Pomodoro Controls with Reports

**Type**: Story | **Status**: backlog | **Points**: 8

As an employee, I want to start/stop timers, take breaks, use pomodoro mode, and view timer reports with charts, so that I can track my time and stay productive from my phone.

## Acceptance Criteria

- [ ] Timer home screen with large start/stop button and elapsed time display
- [ ] Break timer with configurable short/long break durations
- [ ] Pomodoro mode: 25min work / 5min break cycle with session counter
- [ ] Timer report screen with daily/weekly/monthly chart views
- [ ] Active timer persists across app backgrounding
- [ ] API endpoints: POST /api/timers/start, POST /api/timers/stop, GET /api/timers/current, GET /api/timers/reports?period=weekly
- [ ] Timer state synced with server in real-time via WebSocket
- [ ] Export report option (share as PDF or CSV)
