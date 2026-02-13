# OMB-57: Theme System and Offline Support

**Type**: Story | **Status**: backlog | **Points**: 8

As a user, I want the app to follow my IDE theme preference and work offline with cached data and queued actions, so that I have a consistent visual experience and can use the app without internet.

## Acceptance Criteria

- [ ] Theme system maps IDE CSS variables to NativeWind theme tokens
- [ ] Light and dark themes fully implemented
- [ ] System theme auto-detection (follows device setting)
- [ ] Theme selection persisted in settings
- [ ] Offline indicator banner shown when device loses connectivity
- [ ] Recent dashboard, task, and notification data cached locally via AsyncStorage
- [ ] Actions performed offline (status changes, timer start/stop) queued for sync
- [ ] Queued actions replay on reconnect with conflict resolution
- [ ] Network status monitored via NetInfo library
