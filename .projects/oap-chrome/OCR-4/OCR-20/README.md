# OCR-20: Migrate task, timer, pomodoro, alarm, and calendar stores to extension packages

**Type**: Story | **Status**: backlog | **Points**: 5

As the system architect, I want productivity-related stores (tasks, timer, timeReport, pomodoro, alarm, calendar) moved to their respective extension packages, so that each productivity feature owns its own state.

## Acceptance Criteria

- [ ] tasksStore.ts moved to src/packages/tasks-manager/resources/chrome/stores/tasksStore.ts
- [ ] timerStore.ts moved to src/packages/time-tracker/resources/chrome/stores/timerStore.ts
- [ ] timeReportStore.ts moved to src/packages/time-tracker/resources/chrome/stores/timeReportStore.ts
- [ ] pomodoroStore.ts moved to src/packages/pomodoro/resources/chrome/stores/pomodoroStore.ts
- [ ] alarmStore.ts moved to src/packages/alarm/resources/chrome/stores/alarmStore.ts
- [ ] calendarStore.ts moved to src/packages/event-tracker/resources/chrome/stores/calendarStore.ts
- [ ] All imports in consuming components updated
- [ ] Each target directory has an index.ts barrel export
- [ ] TypeScript strict mode passes
