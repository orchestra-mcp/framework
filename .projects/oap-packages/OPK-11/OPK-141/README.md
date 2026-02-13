# OPK-141: Migrate Event Tracker main services

**Type**: Story | **Status**: done | **Points**: 5

As a developer, I want the calendar, multi-account, meeting reminder, and OAuth services migrated from extensions/calendar/ into the Event Tracker package.

## Acceptance Criteria

- [ ] CalendarService.ts, MultiAccountCalendarService.ts, MeetingReminderService.ts migrated to src/Services/
- [ ] OAuthService.ts migrated (with TODO for AccountCenter)
- [ ] All 3 providers migrated to src/Services/Providers/
- [ ] handlers, types, trayMenu migrated
- [ ] All imports updated
- [ ] TypeScript compiles

## Tasks

| ID | Title | Status | Type |
|----|-------|--------|------|
| OPK-146 | Migrate calendar service files and providers | backlog | task |
| OPK-147 | Migrate and update Event Tracker unit tests | backlog | task |
