# Health Settings Tab

The Health settings tab provides notification preferences and sleep configuration, accessible from both the desktop settings sidebar and mobile settings menu.

## Location

- **Route**: `/settings/health`
- **File**: `apps/flutter/lib/screens/settings/tabs/health_settings_tab.dart`
- **Desktop sidebar**: Under the "Notifications" group in the settings sidebar
- **Mobile menu**: Under the "Features" section in the settings menu

## Architecture

- Loads profile data from `healthProfileProvider` (FutureProvider wrapping `getHealthProfile()`)
- Saves individual field changes immediately via `apiClientProvider.updateHealthProfile()`
- Uses optimistic UI updates: local `_pendingProfile` overlay while API save is in flight
- Invalidates `healthProfileProvider` after successful save for downstream refresh

## Sections

### Notifications (11 settings)

| Setting | Type | Key(s) | Default |
|---------|------|--------|---------|
| Weight Check-in | Toggle + Time + Stepper | `weightAlertEnabled`, `weightAlertHour`, `weightAlertMinute`, `weightAlertDelayDays` | off, 08:00, 1 day |
| Hygiene Reminder | Toggle + Stepper | `hygieneAlertEnabled`, `hygieneAlertDelayDays` | off, 1 day |
| Pomodoro Start Alert | Toggle + Stepper | `pomodoroStartAlertEnabled`, `pomodoroStartLeadMinutes` | off, 5 min |
| Pomodoro End Alert | Toggle + Stepper | `pomodoroEndAlertEnabled`, `pomodoroEndLeadMinutes` | off, 5 min |
| Heart Rate High | Stepper | `heartRateHighThreshold` | 120 bpm |
| Heart Rate Low | Stepper | `heartRateLowThreshold` | 50 bpm |
| Meal Reminder | Toggle | `mealReminderEnabled` | off |
| Coffee Time | Toggle + Time | `coffeeAlertEnabled`, `coffeeAlertHour`, `coffeeAlertMinute` | off, 14:00 |
| Hydration Alert | Toggle + Stepper | `hydrationAlertEnabled`, `hydrationAlertGapMinutes` | off, 60 min |
| Movement Alert | Toggle + Stepper | `movementAlertEnabled`, `movementAlertIntervalMinutes` | off, 60 min |
| GERD Warning | Stepper | `gerdShutdownLeadMinutes` | 30 min |

### Sleep (2 settings)

| Setting | Type | Key(s) | Default |
|---------|------|--------|---------|
| Bedtime | Time picker | `sleepBedtimeHour`, `sleepBedtimeMinute` | 23:00 |
| Shutdown Window | Stepper | `shutdownWindowHours` | 2 hrs |

## Row Widget Types

- **_ToggleRow**: Label + subtitle + Switch, fires save on toggle
- **_StepperRow**: Label + subtitle + decrement/increment buttons with value display
- **_TimePickerRow**: Label + subtitle + time display chip, opens `showTimePicker` dialog

## Conditional Rows

Toggle-dependent sub-rows (time pickers, steppers) only render when their parent toggle is enabled. This prevents UI clutter when a notification type is disabled.
