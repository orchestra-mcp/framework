# OPK-11: Event Tracker Package

**Type**: Epic | **Status**: done | **Priority**: medium

Migrate the Event Tracker package at src/packages/event-tracker/. Sources: packages/extensions/calendar/src/ (CalendarService.ts, MultiAccountCalendarService.ts, MeetingReminderService.ts, OAuthService.ts, calendarHandlers.ts, trayMenuIntegration.ts, types.ts, index.ts, providers/ (GoogleProvider.ts, OutlookProvider.ts, AppleProvider.ts, types.ts, index.ts)), packages/desktop/src/main/services/calendarPanelService.ts, packages/desktop/src/widget-renderer/calendar-panel.html, packages/desktop/src/widget-renderer/calendar-panel-renderer.ts, packages/desktop/src/main/calendar-panel-preload.ts, packages/chrome-extension/src/stores/calendarStore.ts. The ServiceProvider registers: widget (calendar panel), sidebar entry (calendar icon), tray menu (Upcoming Events), integrations (Google Calendar, Outlook via AccountCenter), settings (refresh interval, default calendar), notifications (meeting reminders).

## Stories

| ID | Title | Status | Priority |
|----|-------|--------|----------|
| OPK-140 | Scaffold Event Tracker package structure | backlog | high |
| OPK-141 | Migrate Event Tracker main services | backlog | high |
| OPK-142 | Migrate Event Tracker Chrome UI | backlog | high |
| OPK-143 | Build Event Tracker ServiceProvider | backlog | high |
| OPK-144 | Write Event Tracker documentation | backlog | medium |
