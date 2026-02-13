# OPK-10: Alarm Package

**Type**: Epic | **Status**: backlog | **Priority**: low

Migrate the Alarm package at src/packages/alarm/. Sources: packages/extensions/alarms/src/ (AlarmService.ts, alarmHandlers.ts, trayMenuIntegration.ts, types.ts, index.ts), packages/desktop/src/main/services/alarmPanelService.ts, packages/desktop/src/widget-renderer/alarm-panel.html, packages/desktop/src/widget-renderer/alarm-panel-renderer.ts, packages/desktop/src/main/alarm-panel-preload.ts, packages/chrome-extension/src/stores/alarmStore.ts, packages/chrome-extension/src/sidepanel/tasks/AlarmSettings.tsx. The ServiceProvider registers: widget (alarm panel), tray menu (Alarms), notifications (alarm triggers), settings (sound, snooze duration).
